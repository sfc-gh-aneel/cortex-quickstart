# 📄 Text Extraction & Chunking for Retirement Plans

Transform your plan documents, participant communications, and regulatory filings into AI-searchable knowledge with Snowflake Cortex Document AI!

## 🎯 What You'll Build

Extract and analyze text from crucial retirement plan documents:
- **📋 Plan Documents**: SPDs, Plan Amendments, Investment Policy Statements
- **📝 Participant Forms**: Enrollment forms, Beneficiary designations, Loan applications  
- **📊 Compliance Reports**: Form 5500, Audit reports, Government correspondence
- **✉️ Communications**: Participant letters, Annual notices, Distribution forms

## 🚀 Quick Demo (3 Minutes!)

### 1. Process Your First Plan Document

```sql
-- Upload a sample SPD and extract text instantly
USE DATABASE RETIREMENT_PLAN_AI;
USE SCHEMA DOCUMENTS;

-- Parse a Summary Plan Description
SELECT SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
    @PLAN_DOCUMENTS, 
    'sample-spd-techcorp-401k.pdf',
    {'mode': 'LAYOUT'}
) AS extracted_content;
```

### 2. Smart Chunking for Better Search

```sql
-- Chunk the document for optimal AI retrieval
CALL CHUNK_PLAN_DOCUMENT('DOC_SPD_001', 'Summary Plan Description - TechCorp 401(k)');

-- See your chunks ready for vector search
SELECT 
    CHUNK_ID,
    LEFT(CHUNK_TEXT, 100) || '...' AS preview,
    METADATA:section_type AS document_section
FROM DOCUMENT_CHUNKS 
WHERE DOCUMENT_ID = 'DOC_SPD_001'
LIMIT 5;
```

### 3. Ask Questions About Your Documents

```sql
-- Natural language search across all plan documents
SELECT CORTEX.SEARCH(
    'RETIREMENT_DOC_SEARCH',
    'What is the vesting schedule for employer matching contributions?'
) AS search_results;
```

## 📁 What's Included

```
text-extraction-chunking/
├── 📄 README.md                    # This guide
├── 🔧 setup.sql                    # Document processing setup
├── 📝 sample-documents/            # Realistic test documents
│   ├── spd-examples/              # Sample plan descriptions  
│   ├── forms/                     # Participant forms
│   └── compliance/                # Regulatory documents
├── 🤖 extraction-functions.sql     # Custom processing functions
├── 🔍 chunking-strategies.sql      # Different chunking approaches
├── 📊 analysis-examples.sql        # Document analysis queries
└── 🛠️ troubleshooting.md          # Common issues & solutions
```

## 🏗️ Setup Instructions

### Step 1: Run the Setup Script

```sql
-- Execute this in your Snowflake worksheet
-- Creates specialized functions for retirement plan documents
@text-extraction-chunking/setup.sql
```

### Step 2: Upload Sample Documents

```bash
# Use SnowSQL or Snowflake web interface to upload
PUT file://sample-documents/spd-examples/* @RETIREMENT_PLAN_AI.DOCUMENTS.PLAN_DOCUMENTS;
PUT file://sample-documents/forms/* @RETIREMENT_PLAN_AI.DOCUMENTS.PARTICIPANT_COMMS;
PUT file://sample-documents/compliance/* @RETIREMENT_PLAN_AI.DOCUMENTS.REGULATORY_DOCS;
```

### Step 3: Test Document Processing

```sql
-- Process all uploaded documents
CALL PROCESS_ALL_PLAN_DOCUMENTS();

-- Verify processing results
SELECT 
    DOCUMENT_TYPE,
    COUNT(*) AS document_count,
    SUM(CASE WHEN PROCESSING_STATUS = 'COMPLETED' THEN 1 ELSE 0 END) AS processed_count
FROM DOCUMENT_REGISTRY 
GROUP BY DOCUMENT_TYPE;
```

## 🎪 Demo Scenarios

### Scenario 1: Plan Document Analysis
**Use Case**: Extract key information from Summary Plan Descriptions

```sql
-- Find eligibility requirements across all plans
SELECT CORTEX.SEARCH(
    'RETIREMENT_DOC_SEARCH',
    'eligibility requirements age service hours',
    {
        'filter': {'document_type': 'SPD'},
        'limit': 5
    }
) AS eligibility_info;
```

### Scenario 2: Form Processing with Document AI
**Use Case**: Extract structured data from participant forms

```sql
-- Process beneficiary designation forms
SELECT 
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
        @PARTICIPANT_COMMS,
        'beneficiary-form-12345.pdf',
        {'mode': 'FORM'}
    ) AS parsed_form;

-- Extract specific fields using Document AI
SELECT 
    GET(parsed_form, 'participant_name') AS participant_name,
    GET(parsed_form, 'beneficiary_name') AS beneficiary_name,
    GET(parsed_form, 'relationship') AS relationship,
    GET(parsed_form, 'percentage') AS percentage
FROM (
    SELECT SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
        @PARTICIPANT_COMMS,
        'beneficiary-form-12345.pdf',
        {'mode': 'FORM', 'extract_fields': ['participant_name', 'beneficiary_name', 'relationship', 'percentage']}
    ) AS parsed_form
);
```

### Scenario 3: Compliance Document Monitoring
**Use Case**: Track regulatory filing requirements

```sql
-- Find all mentions of IRS deadlines and requirements
SELECT CORTEX.SEARCH(
    'RETIREMENT_DOC_SEARCH',
    'IRS deadline filing requirement Form 5500',
    {
        'filter': {'document_type': 'Compliance'},
        'limit': 10
    }
) AS compliance_requirements;
```

## 🎯 Customization Guide

### Adding Your Own Documents

1. **Update Document Types**:
```sql
-- Add new document categories
ALTER TABLE DOCUMENT_REGISTRY 
ADD COLUMN IF NOT EXISTS COMPLIANCE_CATEGORY VARCHAR(50);

-- Example categories: 'ERISA', 'IRS', 'DOL', 'State'
```

2. **Custom Chunking Strategies**:
```sql
-- Customize chunking for different document types
-- For legal documents: smaller chunks with overlap
-- For forms: chunk by section
-- For communications: chunk by paragraph

CALL CREATE_CUSTOM_CHUNKING_STRATEGY(
    'legal_document', 
    500,  -- chunk_size
    100   -- overlap
);
```

3. **Plan-Specific Processing**:
```sql
-- Process documents by specific plan
CALL PROCESS_PLAN_DOCUMENTS('[YOUR_PLAN_ID]');

-- Set up automatic processing for new uploads
CREATE TASK AUTO_PROCESS_NEW_DOCS
WAREHOUSE = RETIREMENT_AI_WH
SCHEDULE = '5 MINUTE'
AS
CALL PROCESS_PENDING_DOCUMENTS();
```

## 🔥 Advanced Features

### 1. Multi-Language Support
```sql
-- Process documents in multiple languages
SELECT SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
    @PLAN_DOCUMENTS,
    'spanish-enrollment-guide.pdf',
    {'mode': 'LAYOUT', 'language': 'es'}
) AS spanish_content;
```

### 2. Document Comparison
```sql
-- Compare different versions of plan documents
WITH current_spd AS (
    SELECT CHUNK_TEXT FROM DOCUMENT_CHUNKS 
    WHERE DOCUMENT_ID = 'SPD_2024_V1'
),
previous_spd AS (
    SELECT CHUNK_TEXT FROM DOCUMENT_CHUNKS 
    WHERE DOCUMENT_ID = 'SPD_2023_V1'
)
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'llama3.1-8b',
    'Compare these two plan document versions and highlight key changes: ' ||
    'Current: ' || current_spd.CHUNK_TEXT || 
    ' Previous: ' || previous_spd.CHUNK_TEXT
) AS document_changes
FROM current_spd, previous_spd
LIMIT 5;
```

### 3. Intelligent Document Classification
```sql
-- Automatically classify uploaded documents
CREATE OR REPLACE FUNCTION CLASSIFY_PLAN_DOCUMENT(document_text TEXT)
RETURNS TEXT
LANGUAGE SQL
AS
$$
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'llama3.1-8b',
    'Classify this retirement plan document. Categories: SPD, Plan_Amendment, Form_5500, ' ||
    'Participant_Communication, Beneficiary_Form, Investment_Statement, Compliance_Report, Other. ' ||
    'Document text: ' || LEFT(document_text, 2000) ||
    '. Respond with just the category name.'
)
$$;
```

## 📊 Success Metrics

Track your document processing effectiveness:

```sql
-- Document processing dashboard
SELECT 
    DOCUMENT_TYPE,
    COUNT(*) AS total_documents,
    AVG(LENGTH(EXTRACTED_TEXT)) AS avg_text_length,
    COUNT(DISTINCT PLAN_ID) AS plans_covered,
    MAX(UPLOAD_DATE) AS latest_upload
FROM DOCUMENT_REGISTRY
WHERE PROCESSING_STATUS = 'COMPLETED'
GROUP BY DOCUMENT_TYPE
ORDER BY total_documents DESC;

-- Search quality metrics
SELECT 
    DATE_TRUNC('day', CURRENT_TIMESTAMP()) AS search_date,
    COUNT(*) AS total_searches,
    AVG(ARRAY_SIZE(search_results)) AS avg_results_per_search
FROM SEARCH_LOG  -- Create this table to track usage
WHERE search_date >= CURRENT_DATE() - 7;
```

## 🚨 Troubleshooting

### Common Issues

**Problem**: PDF extraction returns empty text
**Solution**: 
```sql
-- Check if document is image-based (scanned)
SELECT 
    DOCUMENT_NAME,
    LENGTH(EXTRACTED_TEXT) AS text_length,
    CASE 
        WHEN LENGTH(EXTRACTED_TEXT) < 100 THEN 'Likely scanned PDF - use OCR mode'
        ELSE 'Text extraction successful'
    END AS diagnosis
FROM DOCUMENT_REGISTRY
WHERE PROCESSING_STATUS = 'COMPLETED';

-- For scanned documents, use OCR mode
SELECT SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
    @PLAN_DOCUMENTS,
    'scanned-form.pdf',
    {'mode': 'OCR'}
) AS ocr_content;
```

**Problem**: Chunking creates too many small pieces
**Solution**: 
```sql
-- Adjust chunking parameters
CALL UPDATE_CHUNKING_STRATEGY(
    'default',
    1500,  -- Larger chunk size
    300    -- More overlap for context
);
```

## 🎉 Next Steps

1. **Try Vector Embedding**: Process these chunks → `../vector-embedding/`
2. **Build Search Interface**: Create searchable knowledge base → `../vector-search-retrieval/`  
3. **Connect to Structured Data**: Link documents to participant data → `../orchestration/`

---

**🏆 Pro Tip**: Start with SPDs and participant communications - they typically have the most immediate business impact and are easiest to demonstrate to stakeholders! 