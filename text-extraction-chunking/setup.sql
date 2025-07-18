-- ============================================================================
-- 📄 Text Extraction & Chunking Setup for Retirement Plans
-- ============================================================================
-- Run this after executing setup/initial-setup.sql
-- Creates specialized functions and procedures for processing plan documents
-- ============================================================================

USE DATABASE RETIREMENT_PLAN_AI;
USE WAREHOUSE RETIREMENT_AI_WH;
USE SCHEMA CORTEX_FUNCTIONS;

-- 🤖 DOCUMENT PROCESSING FUNCTIONS
-- ============================================================================

-- Function to process and chunk a single document
CREATE OR REPLACE PROCEDURE CHUNK_PLAN_DOCUMENT(
    document_id VARCHAR,
    document_name VARCHAR,
    chunk_size INTEGER DEFAULT 1000,
    chunk_overlap INTEGER DEFAULT 200
)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    extracted_text TEXT;
    chunk_count INTEGER DEFAULT 0;
    chunk_start INTEGER DEFAULT 1;
    chunk_end INTEGER;
    current_chunk TEXT;
    chunk_id VARCHAR;
BEGIN
    -- Get the extracted text for the document
    SELECT EXTRACTED_TEXT INTO extracted_text 
    FROM DOCUMENTS.DOCUMENT_REGISTRY 
    WHERE DOCUMENT_ID = document_id;
    
    -- If no text found, return error
    IF (extracted_text IS NULL OR LENGTH(extracted_text) = 0) THEN
        RETURN 'Error: No extracted text found for document ' || document_id;
    END IF;
    
    -- Delete existing chunks for this document
    DELETE FROM DOCUMENTS.DOCUMENT_CHUNKS WHERE DOCUMENT_ID = document_id;
    
    -- Create chunks with overlap
    WHILE (chunk_start <= LENGTH(extracted_text)) DO
        chunk_end := LEAST(chunk_start + chunk_size - 1, LENGTH(extracted_text));
        current_chunk := SUBSTRING(extracted_text, chunk_start, chunk_size);
        
        -- Skip very small chunks at the end
        IF (LENGTH(current_chunk) >= 100) THEN
            chunk_count := chunk_count + 1;
            chunk_id := document_id || '_CHUNK_' || LPAD(chunk_count, 3, '0');
            
            -- Insert chunk with embedding
            INSERT INTO DOCUMENTS.DOCUMENT_CHUNKS (
                CHUNK_ID, 
                DOCUMENT_ID, 
                CHUNK_TEXT, 
                CHUNK_INDEX, 
                EMBEDDING,
                METADATA
            ) VALUES (
                chunk_id,
                document_id,
                current_chunk,
                chunk_count,
                SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', current_chunk),
                OBJECT_CONSTRUCT(
                    'chunk_size', LENGTH(current_chunk),
                    'chunk_start', chunk_start,
                    'chunk_end', chunk_end,
                    'document_name', document_name
                )
            );
        END IF;
        
        -- Move to next chunk with overlap
        chunk_start := chunk_start + chunk_size - chunk_overlap;
    END WHILE;
    
    -- Update document status
    UPDATE DOCUMENTS.DOCUMENT_REGISTRY 
    SET PROCESSING_STATUS = 'CHUNKED'
    WHERE DOCUMENT_ID = document_id;
    
    RETURN 'Successfully created ' || chunk_count || ' chunks for document ' || document_id;
END;
$$;

-- Function to process a document from a stage
CREATE OR REPLACE PROCEDURE PROCESS_DOCUMENT_FROM_STAGE(
    stage_name VARCHAR,
    file_name VARCHAR,
    document_type VARCHAR,
    plan_id VARCHAR DEFAULT NULL
)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    document_id VARCHAR;
    extracted_content VARIANT;
    extracted_text TEXT;
    processing_result VARCHAR;
BEGIN
    -- Generate unique document ID
    document_id := 'DOC_' || UPPER(REPLACE(REPLACE(file_name, '.pdf', ''), '-', '_')) || '_' || 
                   TO_VARCHAR(CURRENT_TIMESTAMP(), 'YYYYMMDDHH24MISS');
    
    -- Parse the document using Cortex
    SELECT SNOWFLAKE.CORTEX.PARSE_DOCUMENT('@' || stage_name, file_name, {'mode': 'LAYOUT'})
    INTO extracted_content;
    
    -- Extract text from the parsed content
    extracted_text := GET(extracted_content, 'text');
    
    -- Insert into document registry
    INSERT INTO DOCUMENTS.DOCUMENT_REGISTRY (
        DOCUMENT_ID,
        DOCUMENT_NAME,
        DOCUMENT_TYPE,
        FILE_PATH,
        PROCESSING_STATUS,
        EXTRACTED_TEXT,
        METADATA,
        PLAN_ID
    ) VALUES (
        document_id,
        file_name,
        document_type,
        stage_name || '/' || file_name,
        'EXTRACTED',
        extracted_text,
        extracted_content,
        plan_id
    );
    
    -- Automatically chunk the document
    CALL CHUNK_PLAN_DOCUMENT(document_id, file_name);
    
    RETURN 'Successfully processed document: ' || document_id;
EXCEPTION
    WHEN OTHER THEN
        -- Log error and update status
        UPDATE DOCUMENTS.DOCUMENT_REGISTRY 
        SET PROCESSING_STATUS = 'ERROR'
        WHERE DOCUMENT_ID = document_id;
        
        RETURN 'Error processing document: ' || SQLERRM;
END;
$$;

-- Function to process all pending documents
CREATE OR REPLACE PROCEDURE PROCESS_ALL_PLAN_DOCUMENTS()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    processed_count INTEGER DEFAULT 0;
    error_count INTEGER DEFAULT 0;
    total_files INTEGER;
    file_record RECORD;
    processing_result VARCHAR;
BEGIN
    -- Process files from PLAN_DOCUMENTS stage
    FOR file_record IN (
        SELECT relative_path as file_name 
        FROM TABLE(RESULT_SCAN(LAST_QUERY_ID())) 
        WHERE relative_path LIKE '%.pdf'
    ) LOOP
        BEGIN
            CALL PROCESS_DOCUMENT_FROM_STAGE('PLAN_DOCUMENTS', file_record.file_name, 'SPD', 'PLAN001');
            processed_count := processed_count + 1;
        EXCEPTION
            WHEN OTHER THEN
                error_count := error_count + 1;
        END;
    END FOR;
    
    RETURN 'Processing complete. Processed: ' || processed_count || ', Errors: ' || error_count;
END;
$$;

-- 🔍 SEARCH AND ANALYSIS FUNCTIONS
-- ============================================================================

-- Function to search documents with filters
CREATE OR REPLACE FUNCTION SEARCH_PLAN_DOCUMENTS(
    search_query VARCHAR,
    document_type VARCHAR DEFAULT NULL,
    plan_id VARCHAR DEFAULT NULL,
    result_limit INTEGER DEFAULT 5
)
RETURNS TABLE (
    document_name VARCHAR,
    document_type VARCHAR,
    chunk_text VARCHAR,
    relevance_score FLOAT,
    plan_id VARCHAR
)
LANGUAGE SQL
AS
$$
    WITH search_results AS (
        SELECT 
            dr.DOCUMENT_NAME,
            dr.DOCUMENT_TYPE,
            dc.CHUNK_TEXT,
            VECTOR_COSINE_SIMILARITY(
                dc.EMBEDDING,
                SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', search_query)
            ) AS relevance_score,
            dr.PLAN_ID
        FROM DOCUMENTS.DOCUMENT_CHUNKS dc
        JOIN DOCUMENTS.DOCUMENT_REGISTRY dr ON dc.DOCUMENT_ID = dr.DOCUMENT_ID
        WHERE dr.PROCESSING_STATUS = 'CHUNKED'
        AND (document_type IS NULL OR dr.DOCUMENT_TYPE = document_type)
        AND (plan_id IS NULL OR dr.PLAN_ID = plan_id)
    )
    SELECT 
        document_name,
        document_type,
        chunk_text,
        relevance_score,
        plan_id
    FROM search_results
    WHERE relevance_score > 0.7
    ORDER BY relevance_score DESC
    LIMIT result_limit
$$;

-- Function to extract key information from plan documents
CREATE OR REPLACE FUNCTION EXTRACT_PLAN_DETAILS(document_id VARCHAR)
RETURNS VARIANT
LANGUAGE SQL
AS
$$
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'llama3.1-8b',
    'Extract key retirement plan information from this document text. Focus on: ' ||
    '1. Plan name and type, 2. Eligibility requirements, 3. Vesting schedule, ' ||
    '4. Contribution limits, 5. Investment options, 6. Distribution rules. ' ||
    'Format as JSON. Document text: ' || 
    (SELECT LEFT(EXTRACTED_TEXT, 3000) FROM DOCUMENTS.DOCUMENT_REGISTRY WHERE DOCUMENT_ID = document_id)
)
$$;

-- 📊 ANALYTICS AND MONITORING
-- ============================================================================

-- View for document processing status
CREATE OR REPLACE VIEW DOCUMENTS.PROCESSING_DASHBOARD AS
SELECT 
    DOCUMENT_TYPE,
    PROCESSING_STATUS,
    COUNT(*) as document_count,
    AVG(LENGTH(EXTRACTED_TEXT)) as avg_text_length,
    MIN(UPLOAD_DATE) as earliest_upload,
    MAX(UPLOAD_DATE) as latest_upload,
    COUNT(DISTINCT PLAN_ID) as unique_plans
FROM DOCUMENTS.DOCUMENT_REGISTRY
GROUP BY DOCUMENT_TYPE, PROCESSING_STATUS;

-- Function to get document insights
CREATE OR REPLACE FUNCTION GET_DOCUMENT_INSIGHTS(plan_id VARCHAR DEFAULT NULL)
RETURNS VARIANT
LANGUAGE SQL
AS
$$
SELECT OBJECT_CONSTRUCT(
    'total_documents', COUNT(*),
    'document_types', ARRAY_AGG(DISTINCT DOCUMENT_TYPE),
    'total_chunks', (SELECT COUNT(*) FROM DOCUMENTS.DOCUMENT_CHUNKS 
                     WHERE DOCUMENT_ID IN (
                         SELECT DOCUMENT_ID FROM DOCUMENTS.DOCUMENT_REGISTRY 
                         WHERE plan_id IS NULL OR PLAN_ID = plan_id
                     )),
    'processing_status', OBJECT_CONSTRUCT(
        'completed', SUM(CASE WHEN PROCESSING_STATUS = 'CHUNKED' THEN 1 ELSE 0 END),
        'pending', SUM(CASE WHEN PROCESSING_STATUS = 'PENDING' THEN 1 ELSE 0 END),
        'errors', SUM(CASE WHEN PROCESSING_STATUS = 'ERROR' THEN 1 ELSE 0 END)
    ),
    'search_readiness', CASE 
        WHEN SUM(CASE WHEN PROCESSING_STATUS = 'CHUNKED' THEN 1 ELSE 0 END) > 0 
        THEN 'Ready for AI search and analysis'
        ELSE 'Upload and process documents first'
    END
) as insights
FROM DOCUMENTS.DOCUMENT_REGISTRY
WHERE plan_id IS NULL OR PLAN_ID = plan_id
$$;

-- 🎯 SAMPLE DATA INSERTION
-- ============================================================================

-- Insert sample document entries (for testing without actual files)
INSERT INTO DOCUMENTS.DOCUMENT_REGISTRY (
    DOCUMENT_ID, DOCUMENT_NAME, DOCUMENT_TYPE, FILE_PATH, 
    PROCESSING_STATUS, EXTRACTED_TEXT, PLAN_ID
) VALUES 
(
    'DOC_SAMPLE_SPD_001',
    'TechCorp 401k Summary Plan Description',
    'SPD',
    'sample-documents/spd-techcorp-401k.pdf',
    'EXTRACTED',
    'SUMMARY PLAN DESCRIPTION - TECHCORP 401(K) RETIREMENT PLAN
    
Plan Year: January 1 - December 31
Effective Date: January 1, 2024

ELIGIBILITY
You are eligible to participate in the Plan if you are an employee who has completed 90 days of service and are at least 18 years old.

CONTRIBUTIONS
Employee Contributions: You may contribute between 1% and 50% of your eligible compensation, up to the annual IRS limit ($23,000 for 2024, $30,500 if age 50 or older).

Employer Matching: TechCorp will match 100% of your contributions up to 4% of your eligible compensation.

VESTING
Employee contributions are always 100% vested. Employer matching contributions vest according to the following schedule:
- Less than 2 years of service: 0% vested
- 2 years of service: 25% vested  
- 3 years of service: 50% vested
- 4 years of service: 75% vested
- 5 or more years of service: 100% vested

INVESTMENT OPTIONS
The Plan offers 15 investment options including target-date funds, index funds, and actively managed funds across various asset classes.',
    'PLAN001'
),
(
    'DOC_SAMPLE_FORM_001', 
    'Beneficiary Designation Form Template',
    'Beneficiary_Form',
    'sample-documents/beneficiary-form-template.pdf',
    'EXTRACTED',
    'BENEFICIARY DESIGNATION FORM
    
Participant Information:
Name: [PARTICIPANT_NAME]
Social Security Number: XXX-XX-[LAST_4_SSN]
Employee ID: [EMPLOYEE_ID]
Plan: [PLAN_NAME]

Primary Beneficiary Information:
Name: [BENEFICIARY_NAME]
Relationship: [RELATIONSHIP]  
Percentage: [PERCENTAGE]%
Date of Birth: [DOB]
Social Security Number: XXX-XX-[BENEFICIARY_SSN]

Contingent Beneficiary Information:
Name: [CONTINGENT_BENEFICIARY_NAME]
Relationship: [CONTINGENT_RELATIONSHIP]
Percentage: [CONTINGENT_PERCENTAGE]%

Participant Signature: _________________________ Date: _______',
    'PLAN001'
);

-- Create initial chunks for sample documents
CALL CHUNK_PLAN_DOCUMENT('DOC_SAMPLE_SPD_001', 'TechCorp 401k Summary Plan Description');
CALL CHUNK_PLAN_DOCUMENT('DOC_SAMPLE_FORM_001', 'Beneficiary Designation Form Template');

-- ✅ VERIFICATION AND SUCCESS MESSAGE
-- ============================================================================

SELECT '🎉 Text Extraction & Chunking Setup Complete!' as status,
       'Functions created for document processing, chunking, and search' as details;

-- Test the setup
SELECT GET_DOCUMENT_INSIGHTS() as setup_verification; 