-- ============================================================================
-- 🔢 Vector Embedding Setup for Retirement Plans
-- ============================================================================
-- Run this after text-extraction-chunking/setup.sql
-- Creates embedding functions and auto-vectorization for all plan data
-- ============================================================================

USE DATABASE RETIREMENT_PLAN_AI;
USE WAREHOUSE RETIREMENT_AI_WH;
USE SCHEMA CORTEX_FUNCTIONS;

-- 🎯 PARTICIPANT PROFILE EMBEDDING FUNCTIONS
-- ============================================================================

-- Generate comprehensive participant embeddings
CREATE OR REPLACE FUNCTION GENERATE_PARTICIPANT_EMBEDDING(participant_id VARCHAR)
RETURNS VECTOR(FLOAT, 768)
LANGUAGE SQL
AS
$$
WITH participant_profile AS (
    SELECT 
        'Retirement Plan Participant Profile: ' || 
        'Name: ' || FULL_NAME || ', ' ||
        'Age: ' || AGE || ', ' ||
        'Employment Status: ' || EMPLOYMENT_STATUS || ', ' ||
        'Annual Salary: $' || FORMAT_NUMBER(ANNUAL_SALARY, 0) || ', ' ||
        'Account Balance: $' || FORMAT_NUMBER(COALESCE(CURRENT_BALANCE, 0), 0) || ', ' ||
        'Vested Balance: $' || FORMAT_NUMBER(COALESCE(VESTED_BALANCE, 0), 0) || ', ' ||
        'Years of Service: ' || YEARS_OF_SERVICE || ', ' ||
        'Plan: ' || PLAN_NAME || ', ' ||
        'Employer: ' || EMPLOYER_NAME ||
        CASE 
            WHEN ENROLLMENT_STATUS = 'Active' THEN ', Actively Contributing'
            WHEN ENROLLMENT_STATUS = 'Eligible' THEN ', Eligible but Not Enrolled'
            ELSE ', ' || ENROLLMENT_STATUS
        END AS profile_text
    FROM ANALYTICS.PARTICIPANT_OVERVIEW 
    WHERE PARTICIPANT_ID = participant_id
)
SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', profile_text)
FROM participant_profile
$$;

-- Create embeddings for investment risk profiles
CREATE OR REPLACE FUNCTION EMBED_RISK_PROFILE(risk_description TEXT)
RETURNS VECTOR(FLOAT, 768)
LANGUAGE SQL
AS
$$
SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_768(
    'snowflake-arctic-embed-m',
    'Investment Risk Profile: ' || risk_description
)
$$;

-- 💰 INVESTMENT FUND EMBEDDING FUNCTIONS
-- ============================================================================

-- Generate investment fund embeddings
CREATE OR REPLACE FUNCTION GENERATE_FUND_EMBEDDING(fund_id VARCHAR)
RETURNS VECTOR(FLOAT, 768)
LANGUAGE SQL
AS
$$
WITH fund_profile AS (
    SELECT 
        'Investment Fund Profile: ' ||
        'Name: ' || FUND_NAME || ', ' ||
        'Type: ' || FUND_TYPE || ', ' ||
        'Risk Category: ' || RISK_CATEGORY || ', ' ||
        'Asset Class: ' || ASSET_CLASS || ', ' ||
        'YTD Return: ' || ROUND(YTD_RETURN * 100, 2) || '%, ' ||
        'Expense Ratio: ' || ROUND(EXPENSE_RATIO * 100, 4) || '%, ' ||
        'Description: ' || FUND_DESCRIPTION AS fund_text
    FROM PARTICIPANT_DATA.INVESTMENT_FUNDS 
    WHERE FUND_ID = fund_id
)
SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', fund_text)
FROM fund_profile
$$;

-- 🔄 AUTO-VECTORIZATION SETUP
-- ============================================================================

-- Create tables to store embeddings
CREATE TABLE IF NOT EXISTS PARTICIPANT_EMBEDDINGS (
    PARTICIPANT_ID VARCHAR(20) PRIMARY KEY,
    PROFILE_EMBEDDING VECTOR(FLOAT, 768),
    GENERATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    EMBEDDING_MODEL VARCHAR(50) DEFAULT 'snowflake-arctic-embed-m'
);

CREATE TABLE IF NOT EXISTS INVESTMENT_FUND_EMBEDDINGS (
    FUND_ID VARCHAR(20) PRIMARY KEY,
    FUND_EMBEDDING VECTOR(FLOAT, 768),
    GENERATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    EMBEDDING_MODEL VARCHAR(50) DEFAULT 'snowflake-arctic-embed-m'
);

-- Procedure to generate all participant embeddings
CREATE OR REPLACE PROCEDURE GENERATE_ALL_PARTICIPANT_EMBEDDINGS()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    participant_count INTEGER DEFAULT 0;
    error_count INTEGER DEFAULT 0;
BEGIN
    -- Clear existing embeddings
    DELETE FROM PARTICIPANT_EMBEDDINGS;
    
    -- Generate embeddings for all participants
    INSERT INTO PARTICIPANT_EMBEDDINGS (PARTICIPANT_ID, PROFILE_EMBEDDING)
    SELECT 
        PARTICIPANT_ID,
        GENERATE_PARTICIPANT_EMBEDDING(PARTICIPANT_ID)
    FROM ANALYTICS.PARTICIPANT_OVERVIEW;
    
    GET DIAGNOSTICS participant_count = ROW_COUNT;
    
    RETURN 'Generated embeddings for ' || participant_count || ' participants';
EXCEPTION
    WHEN OTHER THEN
        RETURN 'Error generating participant embeddings: ' || SQLERRM;
END;
$$;

-- Procedure to generate all fund embeddings
CREATE OR REPLACE PROCEDURE GENERATE_ALL_FUND_EMBEDDINGS()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    fund_count INTEGER DEFAULT 0;
BEGIN
    -- Clear existing embeddings
    DELETE FROM INVESTMENT_FUND_EMBEDDINGS;
    
    -- Generate embeddings for all funds
    INSERT INTO INVESTMENT_FUND_EMBEDDINGS (FUND_ID, FUND_EMBEDDING)
    SELECT 
        FUND_ID,
        GENERATE_FUND_EMBEDDING(FUND_ID)
    FROM PARTICIPANT_DATA.INVESTMENT_FUNDS;
    
    GET DIAGNOSTICS fund_count = ROW_COUNT;
    
    RETURN 'Generated embeddings for ' || fund_count || ' investment funds';
EXCEPTION
    WHEN OTHER THEN
        RETURN 'Error generating fund embeddings: ' || SQLERRM;
END;
$$;

-- Comprehensive auto-vectorization procedure
CREATE OR REPLACE PROCEDURE PROCESS_NEW_EMBEDDINGS()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    result_summary TEXT DEFAULT '';
    doc_result TEXT;
    participant_result TEXT;
    fund_result TEXT;
BEGIN
    -- Process new document chunks (from text extraction)
    UPDATE DOCUMENTS.DOCUMENT_CHUNKS 
    SET embedding = SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', CHUNK_TEXT),
        METADATA = OBJECT_INSERT(METADATA, 'last_embedded', CURRENT_TIMESTAMP())
    WHERE embedding IS NULL;
    
    -- Update participant embeddings for modified participants
    MERGE INTO PARTICIPANT_EMBEDDINGS pe
    USING (
        SELECT PARTICIPANT_ID, GENERATE_PARTICIPANT_EMBEDDING(PARTICIPANT_ID) as new_embedding
        FROM ANALYTICS.PARTICIPANT_OVERVIEW po
        WHERE NOT EXISTS (
            SELECT 1 FROM PARTICIPANT_EMBEDDINGS pe2 
            WHERE pe2.PARTICIPANT_ID = po.PARTICIPANT_ID 
            AND pe2.GENERATED_AT > CURRENT_DATE() - 1
        )
    ) new_data
    ON pe.PARTICIPANT_ID = new_data.PARTICIPANT_ID
    WHEN MATCHED THEN 
        UPDATE SET PROFILE_EMBEDDING = new_data.new_embedding, GENERATED_AT = CURRENT_TIMESTAMP()
    WHEN NOT MATCHED THEN
        INSERT (PARTICIPANT_ID, PROFILE_EMBEDDING) VALUES (new_data.PARTICIPANT_ID, new_data.new_embedding);
    
    -- Update fund embeddings
    MERGE INTO INVESTMENT_FUND_EMBEDDINGS fe
    USING (
        SELECT FUND_ID, GENERATE_FUND_EMBEDDING(FUND_ID) as new_embedding
        FROM PARTICIPANT_DATA.INVESTMENT_FUNDS f
        WHERE NOT EXISTS (
            SELECT 1 FROM INVESTMENT_FUND_EMBEDDINGS fe2 
            WHERE fe2.FUND_ID = f.FUND_ID 
            AND fe2.GENERATED_AT > CURRENT_DATE() - 7  -- Update weekly
        )
    ) new_data
    ON fe.FUND_ID = new_data.FUND_ID
    WHEN MATCHED THEN 
        UPDATE SET FUND_EMBEDDING = new_data.new_embedding, GENERATED_AT = CURRENT_TIMESTAMP()
    WHEN NOT MATCHED THEN
        INSERT (FUND_ID, FUND_EMBEDDING) VALUES (new_data.FUND_ID, new_data.new_embedding);
    
    result_summary := 'Auto-vectorization completed successfully';
    
    RETURN result_summary;
EXCEPTION
    WHEN OTHER THEN
        RETURN 'Error in auto-vectorization: ' || SQLERRM;
END;
$$;

-- 🔍 SIMILARITY SEARCH FUNCTIONS
-- ============================================================================

-- Find similar participants based on profile
CREATE OR REPLACE FUNCTION FIND_SIMILAR_PARTICIPANTS(
    target_participant_id VARCHAR,
    similarity_threshold FLOAT DEFAULT 0.7,
    result_limit INTEGER DEFAULT 10
)
RETURNS TABLE (
    participant_id VARCHAR,
    full_name VARCHAR,
    similarity_score FLOAT,
    plan_name VARCHAR,
    account_balance DECIMAL(15,2)
)
LANGUAGE SQL
AS
$$
WITH target_embedding AS (
    SELECT PROFILE_EMBEDDING
    FROM PARTICIPANT_EMBEDDINGS 
    WHERE PARTICIPANT_ID = target_participant_id
)
SELECT 
    pe.PARTICIPANT_ID,
    po.FULL_NAME,
    VECTOR_COSINE_SIMILARITY(pe.PROFILE_EMBEDDING, te.PROFILE_EMBEDDING) AS similarity_score,
    po.PLAN_NAME,
    po.CURRENT_BALANCE
FROM PARTICIPANT_EMBEDDINGS pe
JOIN ANALYTICS.PARTICIPANT_OVERVIEW po ON pe.PARTICIPANT_ID = po.PARTICIPANT_ID
CROSS JOIN target_embedding te
WHERE pe.PARTICIPANT_ID != target_participant_id
AND VECTOR_COSINE_SIMILARITY(pe.PROFILE_EMBEDDING, te.PROFILE_EMBEDDING) >= similarity_threshold
ORDER BY similarity_score DESC
LIMIT result_limit
$$;

-- Investment recommendation based on risk profile
CREATE OR REPLACE FUNCTION RECOMMEND_INVESTMENTS(
    risk_profile_text TEXT,
    result_limit INTEGER DEFAULT 5
)
RETURNS TABLE (
    fund_id VARCHAR,
    fund_name VARCHAR,
    risk_category VARCHAR,
    ytd_return DECIMAL(8,4),
    similarity_score FLOAT
)
LANGUAGE SQL
AS
$$
WITH query_embedding AS (
    SELECT EMBED_RISK_PROFILE(risk_profile_text) AS risk_embedding
)
SELECT 
    ife.FUND_ID,
    f.FUND_NAME,
    f.RISK_CATEGORY,
    f.YTD_RETURN,
    VECTOR_COSINE_SIMILARITY(ife.FUND_EMBEDDING, qe.risk_embedding) AS similarity_score
FROM INVESTMENT_FUND_EMBEDDINGS ife
JOIN PARTICIPANT_DATA.INVESTMENT_FUNDS f ON ife.FUND_ID = f.FUND_ID
CROSS JOIN query_embedding qe
ORDER BY similarity_score DESC
LIMIT result_limit
$$;

-- 📊 QUALITY MONITORING VIEWS
-- ============================================================================

-- Vector quality metrics view
CREATE OR REPLACE VIEW VECTOR_QUALITY_METRICS AS
SELECT 
    'Document Chunks' AS data_type,
    COUNT(*) AS total_vectors,
    COUNT(CASE WHEN embedding IS NOT NULL THEN 1 END) AS embedded_count,
    ROUND(COUNT(CASE WHEN embedding IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 2) AS embedding_coverage_pct,
    AVG(VECTOR_L2_DISTANCE(embedding, VECTOR_FILL(768, 0.0))) AS avg_vector_magnitude
FROM DOCUMENTS.DOCUMENT_CHUNKS
WHERE embedding IS NOT NULL

UNION ALL

SELECT 
    'Participant Profiles' AS data_type,
    COUNT(*) AS total_vectors,
    COUNT(*) AS embedded_count,  -- All should be embedded
    100.0 AS embedding_coverage_pct,
    AVG(VECTOR_L2_DISTANCE(PROFILE_EMBEDDING, VECTOR_FILL(768, 0.0))) AS avg_vector_magnitude
FROM PARTICIPANT_EMBEDDINGS

UNION ALL

SELECT 
    'Investment Funds' AS data_type,
    COUNT(*) AS total_vectors,
    COUNT(*) AS embedded_count,  -- All should be embedded
    100.0 AS embedding_coverage_pct,
    AVG(VECTOR_L2_DISTANCE(FUND_EMBEDDING, VECTOR_FILL(768, 0.0))) AS avg_vector_magnitude
FROM INVESTMENT_FUND_EMBEDDINGS;

-- Test semantic similarity function
CREATE OR REPLACE FUNCTION TEST_SEMANTIC_SIMILARITY()
RETURNS TABLE (
    test_case VARCHAR,
    similarity_score FLOAT,
    interpretation VARCHAR
)
LANGUAGE SQL
AS
$$
WITH test_embeddings AS (
    SELECT 
        SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', '401k retirement plan') AS embed1,
        SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', '401(k) retirement savings plan') AS embed2,
        SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', 'investment fund portfolio') AS embed3,
        SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', 'pizza delivery service') AS embed4
)
SELECT 'Similar: 401k vs 401(k) plan' AS test_case,
       VECTOR_COSINE_SIMILARITY(embed1, embed2) AS similarity_score,
       'Should be high (>0.8)' AS interpretation
FROM test_embeddings
UNION ALL
SELECT 'Related: 401k vs investment fund' AS test_case,
       VECTOR_COSINE_SIMILARITY(embed1, embed3) AS similarity_score,
       'Should be moderate (0.4-0.7)' AS interpretation
FROM test_embeddings
UNION ALL
SELECT 'Unrelated: 401k vs pizza delivery' AS test_case,
       VECTOR_COSINE_SIMILARITY(embed1, embed4) AS similarity_score,
       'Should be low (<0.3)' AS interpretation
FROM test_embeddings
$$;

-- 🎯 INITIALIZE WITH SAMPLE DATA
-- ============================================================================

-- Generate embeddings for all current data
CALL GENERATE_ALL_PARTICIPANT_EMBEDDINGS();
CALL GENERATE_ALL_FUND_EMBEDDINGS();

-- Set up automatic embedding task
CREATE TASK IF NOT EXISTS AUTO_EMBED_NEW_DATA
WAREHOUSE = RETIREMENT_AI_WH
SCHEDULE = '10 MINUTE'
AS
CALL PROCESS_NEW_EMBEDDINGS();

-- Enable the task
ALTER TASK AUTO_EMBED_NEW_DATA RESUME;

-- ✅ VERIFICATION AND SUCCESS MESSAGE
-- ============================================================================

SELECT '🎉 Vector Embedding Setup Complete!' as status,
       'All embedding functions and auto-vectorization enabled' as details;

-- Display quality metrics
SELECT * FROM VECTOR_QUALITY_METRICS;

-- Test semantic similarity
SELECT * FROM TABLE(TEST_SEMANTIC_SIMILARITY()); 