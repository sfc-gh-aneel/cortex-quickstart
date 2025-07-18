# 🔢 Vector Embedding for Retirement Plan Data

Transform your retirement plan information into AI-searchable vectors with Snowflake Cortex's powerful embedding models!

## 🎯 What You'll Build

Convert all types of retirement plan data into semantic vectors:
- **📄 Document Embeddings**: Plan documents, forms, communications
- **💰 Participant Data**: Create searchable profiles and account summaries  
- **📊 Investment Information**: Fund descriptions, performance data, risk profiles
- **📋 Compliance Content**: Regulatory text, audit findings, requirements
- **🔄 Auto-Vectorization**: Automatically embed new data as it arrives

## 🚀 Quick Demo (2 Minutes!)

### 1. Test Multiple Embedding Models

```sql
-- Compare different embedding models on the same text
USE DATABASE RETIREMENT_PLAN_AI;
USE SCHEMA CORTEX_FUNCTIONS;

WITH sample_text AS (
    SELECT 'TechCorp offers a 401(k) plan with 4% employer matching and immediate vesting for employee contributions' AS text
)
SELECT 
    'snowflake-arctic-embed-m' AS model,
    SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', text) AS embedding
FROM sample_text
UNION ALL
SELECT 
    'snowflake-arctic-embed-l' AS model,
    SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-l', text) AS embedding  
FROM sample_text;
```

### 2. Auto-Vectorize Participant Data

```sql
-- Create semantic embeddings for participant profiles
SELECT 
    PARTICIPANT_ID,
    FULL_NAME,
    GENERATE_PARTICIPANT_EMBEDDING(PARTICIPANT_ID) AS profile_embedding
FROM ANALYTICS.PARTICIPANT_OVERVIEW
LIMIT 5;
```

### 3. Smart Investment Matching

```sql
-- Find investment funds similar to a participant's risk profile
SELECT 
    fund_name,
    risk_category,
    VECTOR_COSINE_SIMILARITY(
        fund_embedding,
        EMBED_RISK_PROFILE('Conservative investor, age 55, retiring in 10 years')
    ) AS match_score
FROM INVESTMENT_FUND_EMBEDDINGS
ORDER BY match_score DESC
LIMIT 5;
```

## 📁 What's Included

```
vector-embedding/
├── 📄 README.md                    # This guide
├── 🔧 setup.sql                    # Vector embedding setup
├── 🤖 embedding-functions.sql      # Custom embedding functions
├── 📊 model-comparison.sql         # Compare different embedding models
├── 🔄 auto-vectorization.sql       # Automatic embedding pipelines
├── 💾 vector-storage.sql           # Optimized vector storage patterns
├── 🎯 similarity-examples.sql      # Vector similarity use cases
└── 📈 performance-tuning.sql       # Scale embeddings efficiently
```

## 🏗️ Setup Instructions

### Step 1: Run the Vector Setup

```sql
-- Execute this in your Snowflake worksheet
-- Creates embedding functions and auto-vectorization
@vector-embedding/setup.sql
```

### Step 2: Choose Your Embedding Strategy

```sql
-- Test different models on your data
CALL COMPARE_EMBEDDING_MODELS('sample retirement plan text');

-- Set up auto-embedding for new documents
CALL ENABLE_AUTO_VECTORIZATION('DOCUMENTS', 'snowflake-arctic-embed-m');
```

### Step 3: Verify Vector Quality

```sql
-- Check embedding quality and performance
SELECT * FROM VECTOR_QUALITY_METRICS;

-- Test semantic similarity
SELECT * FROM TABLE(TEST_SEMANTIC_SIMILARITY());
```

## 🎪 Demo Scenarios

### Scenario 1: Multi-Model Document Embedding
**Use Case**: Compare embedding models for plan document search

```sql
-- Embed the same document with different models
WITH document_text AS (
    SELECT EXTRACTED_TEXT 
    FROM DOCUMENTS.DOCUMENT_REGISTRY 
    WHERE DOCUMENT_ID = 'DOC_SAMPLE_SPD_001'
)
SELECT 
    'arctic-embed-m' AS model_name,
    768 AS dimensions,
    SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', EXTRACTED_TEXT) AS embedding,
    'Balanced performance and cost' AS use_case
FROM document_text
UNION ALL
SELECT 
    'arctic-embed-l' AS model_name,
    1024 AS dimensions, 
    SNOWFLAKE.CORTEX.EMBED_TEXT_1024('snowflake-arctic-embed-l', EXTRACTED_TEXT) AS embedding,
    'Higher accuracy for complex documents' AS use_case
FROM document_text;
```

### Scenario 2: Participant Profile Embeddings
**Use Case**: Create searchable participant profiles for personalized recommendations

```sql
-- Generate rich participant embeddings
WITH participant_profiles AS (
    SELECT 
        p.PARTICIPANT_ID,
        p.FULL_NAME,
        'Participant: ' || p.FULL_NAME || 
        ', Age: ' || p.AGE || 
        ', Employment: ' || p.EMPLOYMENT_STATUS ||
        ', Annual Salary: $' || p.ANNUAL_SALARY ||
        ', Current Balance: $' || COALESCE(p.CURRENT_BALANCE, 0) ||
        ', Years of Service: ' || p.YEARS_OF_SERVICE ||
        ', Plan: ' || p.PLAN_NAME AS profile_text
    FROM ANALYTICS.PARTICIPANT_OVERVIEW p
)
SELECT 
    PARTICIPANT_ID,
    FULL_NAME,
    profile_text,
    SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', profile_text) AS profile_embedding
FROM participant_profiles;
```

### Scenario 3: Investment Fund Matching
**Use Case**: Recommend funds based on semantic similarity to risk preferences

```sql
-- Create investment fund embeddings with risk profiles
WITH fund_descriptions AS (
    SELECT 
        FUND_ID,
        FUND_NAME,
        'Investment Fund: ' || FUND_NAME ||
        ', Type: ' || FUND_TYPE ||
        ', Risk: ' || RISK_CATEGORY ||
        ', Asset Class: ' || ASSET_CLASS ||
        ', YTD Return: ' || (YTD_RETURN * 100) || '% ' ||
        FUND_DESCRIPTION AS fund_text
    FROM PARTICIPANT_DATA.INVESTMENT_FUNDS
)
SELECT 
    FUND_ID,
    FUND_NAME,
    fund_text,
    SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', fund_text) AS fund_embedding
FROM fund_descriptions;

-- Find similar funds to user preferences
WITH user_preference AS (
    SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_768(
        'snowflake-arctic-embed-m', 
        'Conservative investment strategy for someone nearing retirement, low risk, stable returns, income focus'
    ) AS preference_embedding
)
SELECT 
    f.FUND_NAME,
    f.RISK_CATEGORY,
    f.YTD_RETURN,
    VECTOR_COSINE_SIMILARITY(fe.fund_embedding, up.preference_embedding) AS similarity_score
FROM fund_descriptions f
JOIN fund_embeddings fe ON f.FUND_ID = fe.FUND_ID
CROSS JOIN user_preference up
ORDER BY similarity_score DESC
LIMIT 10;
```

### Scenario 4: Auto-Vectorization Pipeline
**Use Case**: Automatically embed new data as it's uploaded

```sql
-- Set up automatic embedding for new documents
CREATE TASK AUTO_EMBED_NEW_DOCUMENTS
WAREHOUSE = RETIREMENT_AI_WH
SCHEDULE = '5 MINUTE'
AS
CALL PROCESS_NEW_EMBEDDINGS();

-- Monitor auto-vectorization progress
SELECT 
    DATE_TRUNC('hour', UPLOAD_DATE) AS upload_hour,
    COUNT(*) AS documents_uploaded,
    SUM(CASE WHEN embedding IS NOT NULL THEN 1 ELSE 0 END) AS documents_embedded,
    AVG(DATEDIFF('minute', UPLOAD_DATE, LAST_EMBEDDED)) AS avg_processing_time_minutes
FROM DOCUMENTS.DOCUMENT_CHUNKS
WHERE UPLOAD_DATE >= CURRENT_DATE() - 1
GROUP BY upload_hour
ORDER BY upload_hour DESC;
```

## 🎯 Customization Guide

### 1. Choose the Right Embedding Model

```sql
-- Model selection guide for different content types
CREATE OR REPLACE FUNCTION GET_OPTIMAL_EMBEDDING_MODEL(content_type VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
SELECT CASE content_type
    WHEN 'short_text' THEN 'snowflake-arctic-embed-m'  -- Forms, titles, brief descriptions
    WHEN 'long_document' THEN 'snowflake-arctic-embed-l'  -- SPDs, legal documents  
    WHEN 'structured_data' THEN 'snowflake-arctic-embed-m'  -- Participant profiles
    WHEN 'compliance' THEN 'snowflake-arctic-embed-l'  -- Regulatory text, complex rules
    WHEN 'multilingual' THEN 'snowflake-arctic-embed-m'  -- Mixed language content
    ELSE 'snowflake-arctic-embed-m'  -- Default: balanced performance
END
$$;
```

### 2. Custom Embedding Strategies

```sql
-- Plan-specific embedding approach
CREATE OR REPLACE FUNCTION EMBED_PLAN_CONTENT(
    content_text TEXT,
    plan_id VARCHAR,
    content_category VARCHAR
)
RETURNS VECTOR(FLOAT, 768)
LANGUAGE SQL
AS
$$
SELECT CASE 
    WHEN content_category = 'legal_document' THEN
        SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-l', content_text)
    WHEN content_category = 'participant_communication' THEN
        SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', 
            'Plan: ' || plan_id || ' - ' || content_text)
    ELSE
        SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', content_text)
END
$$;
```

### 3. Embedding Quality Monitoring

```sql
-- Track embedding quality over time
CREATE OR REPLACE VIEW EMBEDDING_QUALITY_DASHBOARD AS
SELECT 
    DATE_TRUNC('day', CREATED_AT) AS embedding_date,
    COUNT(*) AS total_embeddings,
    COUNT(DISTINCT DOCUMENT_TYPE) AS content_types,
    AVG(VECTOR_L2_DISTANCE(embedding, VECTOR_FILL(768, 0.0))) AS avg_vector_magnitude,
    COUNT(CASE WHEN embedding IS NULL THEN 1 END) AS failed_embeddings
FROM DOCUMENTS.DOCUMENT_CHUNKS
GROUP BY embedding_date
ORDER BY embedding_date DESC;
```

## 🔥 Advanced Features

### 1. Embedding Model Performance Comparison

```sql
-- Benchmark different models on your actual data
CREATE OR REPLACE PROCEDURE BENCHMARK_EMBEDDING_MODELS(sample_size INTEGER DEFAULT 100)
RETURNS TABLE (
    model_name VARCHAR,
    avg_processing_time_ms FLOAT,
    vector_quality_score FLOAT,
    recommended_use_case VARCHAR
)
LANGUAGE SQL
AS
$$
-- Implementation compares arctic-embed-m vs arctic-embed-l
-- on processing time, semantic quality, and cost
$$;
```

### 2. Contextual Embeddings with Plan Information

```sql
-- Add plan context to improve embedding relevance
CREATE OR REPLACE FUNCTION EMBED_WITH_PLAN_CONTEXT(
    content_text TEXT,
    plan_id VARCHAR
)
RETURNS VECTOR(FLOAT, 768)
LANGUAGE SQL
AS
$$
WITH plan_context AS (
    SELECT 
        'Plan Context: ' || PLAN_NAME || ', Type: ' || PLAN_TYPE || 
        ', Employer: ' || EMPLOYER_NAME || '. Content: ' || content_text AS contextualized_text
    FROM PARTICIPANT_DATA.RETIREMENT_PLANS
    WHERE PLAN_ID = plan_id
)
SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', contextualized_text)
FROM plan_context
$$;
```

### 3. Incremental Embedding Updates

```sql
-- Only re-embed content that has changed
CREATE OR REPLACE PROCEDURE UPDATE_MODIFIED_EMBEDDINGS()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    updated_count INTEGER DEFAULT 0;
BEGIN
    -- Update embeddings for modified documents
    UPDATE DOCUMENTS.DOCUMENT_CHUNKS 
    SET 
        embedding = SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', CHUNK_TEXT),
        last_embedded = CURRENT_TIMESTAMP()
    WHERE 
        last_embedded < (
            SELECT MAX(UPLOAD_DATE) 
            FROM DOCUMENTS.DOCUMENT_REGISTRY dr 
            WHERE dr.DOCUMENT_ID = DOCUMENT_CHUNKS.DOCUMENT_ID
        )
        OR embedding IS NULL;
    
    GET DIAGNOSTICS updated_count = ROW_COUNT;
    RETURN 'Updated ' || updated_count || ' embeddings';
END;
$$;
```

## 📊 Success Metrics

Monitor your embedding effectiveness:

```sql
-- Embedding analytics dashboard
WITH embedding_stats AS (
    SELECT 
        COUNT(*) AS total_vectors,
        COUNT(DISTINCT DOCUMENT_ID) AS unique_documents,
        AVG(ARRAY_SIZE(embedding)) AS avg_vector_dimensions,
        MIN(LAST_EMBEDDED) AS oldest_embedding,
        MAX(LAST_EMBEDDED) AS newest_embedding
    FROM DOCUMENTS.DOCUMENT_CHUNKS
    WHERE embedding IS NOT NULL
),
similarity_quality AS (
    SELECT 
        AVG(max_similarity) AS avg_max_similarity,
        STDDEV(max_similarity) AS similarity_distribution
    FROM (
        SELECT 
            CHUNK_ID,
            MAX(VECTOR_COSINE_SIMILARITY(
                embedding, 
                (SELECT embedding FROM DOCUMENTS.DOCUMENT_CHUNKS dc2 
                 WHERE dc2.CHUNK_ID != DOCUMENT_CHUNKS.CHUNK_ID LIMIT 1)
            )) AS max_similarity
        FROM DOCUMENTS.DOCUMENT_CHUNKS
        WHERE embedding IS NOT NULL
        GROUP BY CHUNK_ID
        LIMIT 100  -- Sample for performance
    )
)
SELECT 
    es.*,
    sq.avg_max_similarity,
    sq.similarity_distribution,
    CASE 
        WHEN es.total_vectors > 1000 AND sq.avg_max_similarity BETWEEN 0.3 AND 0.8 
        THEN 'Excellent embedding quality'
        WHEN es.total_vectors > 100
        THEN 'Good embedding coverage'
        ELSE 'More data needed for quality assessment'
    END AS quality_assessment
FROM embedding_stats es
CROSS JOIN similarity_quality sq;
```

## 🚨 Troubleshooting

### Common Issues

**Problem**: Embeddings taking too long to generate
**Solution**: 
```sql
-- Use smaller embedding model for faster processing
ALTER TABLE DOCUMENTS.DOCUMENT_CHUNKS 
ADD COLUMN fast_embedding VECTOR(FLOAT, 384);

-- Batch process embeddings
CALL BATCH_GENERATE_EMBEDDINGS(1000);  -- Process 1000 at a time
```

**Problem**: Poor similarity search results
**Solution**: 
```sql
-- Check embedding distribution
SELECT 
    DOCUMENT_TYPE,
    COUNT(*) AS chunk_count,
    AVG(VECTOR_L2_DISTANCE(embedding, VECTOR_FILL(768, 0.0))) AS avg_magnitude
FROM DOCUMENTS.DOCUMENT_CHUNKS dc
JOIN DOCUMENTS.DOCUMENT_REGISTRY dr ON dc.DOCUMENT_ID = dr.DOCUMENT_ID
WHERE embedding IS NOT NULL
GROUP BY DOCUMENT_TYPE;

-- Re-embed with better text preprocessing
CALL REGENERATE_EMBEDDINGS_WITH_PREPROCESSING();
```

## 🎉 Next Steps

1. **Build Search**: Use these embeddings → `../vector-search-retrieval/`
2. **Create Recommendations**: Personalized investment suggestions → `../structured-data-processing/`
3. **Integrate Everything**: Unified search across all data → `../orchestration/`

---

**🏆 Pro Tip**: Start with arctic-embed-m for most use cases - it provides the best balance of quality, speed, and cost. Upgrade to arctic-embed-l only for complex legal documents that need highest accuracy! 