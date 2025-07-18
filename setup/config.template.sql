-- ============================================================================
-- Snowflake Cortex Configuration Template
-- ============================================================================
-- Copy this file to config.sql and customize with your Snowflake details
-- ============================================================================

-- 🔧 SNOWFLAKE CONNECTION SETTINGS
-- Replace [YOUR_*] placeholders with your actual values

-- Account Information
SET ACCOUNT_NAME = '[YOUR_SNOWFLAKE_ACCOUNT]';  -- e.g., 'abc12345.us-east-1'
SET REGION = '[YOUR_REGION]';                   -- e.g., 'us-east-1', 'eu-west-1'

-- Database and Schema Names (customize as needed)
SET DATABASE_NAME = '[YOUR_DATABASE_NAME]';     -- Default: 'CORTEX_AI_LAB'
SET SCHEMA_NAME = '[YOUR_SCHEMA_NAME]';         -- Default: 'EXPERIMENTS'

-- Warehouse Configuration
SET WAREHOUSE_NAME = '[YOUR_WAREHOUSE]';        -- Default: 'CORTEX_WH'
SET WAREHOUSE_SIZE = '[YOUR_WAREHOUSE_SIZE]';   -- Options: X-SMALL, SMALL, MEDIUM, LARGE

-- Role and User
SET ROLE_NAME = '[YOUR_ROLE]';                  -- Ensure it has necessary permissions
SET USERNAME = '[YOUR_USERNAME]';               -- Your Snowflake username

-- 🗂️ STORAGE SETTINGS
-- Stage for file uploads (PDFs, documents, etc.)
SET STAGE_NAME = '[YOUR_STAGE_NAME]';           -- Default: 'CORTEX_FILES'
SET EXTERNAL_STAGE_URL = '[YOUR_S3_BUCKET_URL]'; -- Optional: for S3 integration

-- 🤖 CORTEX FEATURE SETTINGS
-- Enable/disable specific Cortex features for testing
SET ENABLE_DOCUMENT_AI = TRUE;
SET ENABLE_VECTOR_SEARCH = TRUE;
SET ENABLE_CORTEX_ANALYST = TRUE;
SET ENABLE_MCP_INTEGRATION = TRUE;

-- 🔑 MODEL PREFERENCES
-- Choose your preferred models (will fallback to available models)
SET PREFERRED_LLM = 'llama3.1-8b';             -- Options: llama3.1-8b, mistral-7b, mixtral-8x7b
SET PREFERRED_EMBEDDING_MODEL = 'snowflake-arctic-embed-m'; -- Default embedding model

-- 📊 SAMPLE DATA SETTINGS
-- Configure which sample datasets to load
SET LOAD_SAMPLE_DOCUMENTS = TRUE;              -- PDF documents for text extraction
SET LOAD_SAMPLE_STRUCTURED_DATA = TRUE;        -- Tables for structured data processing
SET LOAD_SAMPLE_VECTOR_DATA = TRUE;            -- Pre-embedded vectors for search demos

-- 🔍 SEARCH SETTINGS
-- Vector search configuration
SET VECTOR_DIMENSION = 768;                    -- Dimension for embeddings (768 for arctic-embed-m)
SET SIMILARITY_THRESHOLD = 0.7;                -- Minimum similarity score for search results

-- 🎯 DEMO CONFIGURATION
-- Set up demo-specific parameters
SET DEMO_PDF_COUNT = 10;                       -- Number of sample PDFs to process
SET DEMO_CHUNK_SIZE = 1000;                    -- Character size for text chunking
SET DEMO_CHUNK_OVERLAP = 200;                  -- Overlap between chunks

-- ⚠️ IMPORTANT NOTES:
-- 1. Ensure your role has ACCOUNTADMIN privileges for initial setup
-- 2. Warehouse will auto-suspend after 1 minute of inactivity (cost optimization)
-- 3. All sample data uses publicly available, non-sensitive content
-- 4. Vector operations require MEDIUM or larger warehouse for best performance

-- 🚀 QUICK VALIDATION
-- Run this after setup to verify your configuration:
-- SELECT CURRENT_ACCOUNT(), CURRENT_DATABASE(), CURRENT_SCHEMA(), CURRENT_WAREHOUSE(); 