-- ============================================================================
-- 🏦 Snowflake Cortex Setup for Retirement Plan Administration
-- ============================================================================
-- Execute this script in your Snowflake worksheet with ACCOUNTADMIN role
-- This sets up the complete environment for testing AI features with 
-- retirement plan data
-- ============================================================================

-- Load configuration (make sure you've customized config.sql first!)
-- @setup/config.sql

-- 🏗️ CREATE CORE INFRASTRUCTURE
-- ============================================================================

-- Create database for retirement plan AI operations
CREATE DATABASE IF NOT EXISTS RETIREMENT_PLAN_AI
COMMENT = 'AI-powered retirement plan administration and analytics';

USE DATABASE RETIREMENT_PLAN_AI;

-- Create schemas for different data types
CREATE SCHEMA IF NOT EXISTS DOCUMENTS
COMMENT = 'Document storage and AI processing for plan documents, forms, communications';

CREATE SCHEMA IF NOT EXISTS PARTICIPANT_DATA  
COMMENT = 'Structured participant and account data';

CREATE SCHEMA IF NOT EXISTS COMPLIANCE
COMMENT = 'Regulatory and compliance data processing';

CREATE SCHEMA IF NOT EXISTS ANALYTICS
COMMENT = 'AI-powered analytics and insights';

CREATE SCHEMA IF NOT EXISTS CORTEX_FUNCTIONS
COMMENT = 'Custom AI functions and processing workflows';

-- 🏭 CREATE WAREHOUSE FOR AI WORKLOADS
-- ============================================================================
CREATE WAREHOUSE IF NOT EXISTS RETIREMENT_AI_WH
WITH 
    WAREHOUSE_SIZE = 'MEDIUM'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = FALSE
COMMENT = 'Dedicated warehouse for Cortex AI operations';

USE WAREHOUSE RETIREMENT_AI_WH;

-- 🗂️ CREATE FILE STORAGE STAGES
-- ============================================================================
USE SCHEMA DOCUMENTS;

-- Stage for plan documents (PDFs, Word docs)
CREATE STAGE IF NOT EXISTS PLAN_DOCUMENTS
DIRECTORY = (ENABLE = TRUE)
COMMENT = 'Storage for plan documents, SPDs, amendments, compliance reports';

-- Stage for participant communications
CREATE STAGE IF NOT EXISTS PARTICIPANT_COMMS
DIRECTORY = (ENABLE = TRUE)  
COMMENT = 'Participant letters, enrollment forms, beneficiary forms';

-- Stage for regulatory filings
CREATE STAGE IF NOT EXISTS REGULATORY_DOCS
DIRECTORY = (ENABLE = TRUE)
COMMENT = 'Form 5500, audit reports, government correspondence';

-- 📊 CREATE SAMPLE PARTICIPANT DATA TABLES
-- ============================================================================
USE SCHEMA PARTICIPANT_DATA;

-- Core participant information
CREATE OR REPLACE TABLE PARTICIPANTS (
    PARTICIPANT_ID VARCHAR(20) PRIMARY KEY,
    SSN_LAST_4 VARCHAR(4),
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    EMAIL VARCHAR(100),
    DATE_OF_BIRTH DATE,
    HIRE_DATE DATE,
    EMPLOYMENT_STATUS VARCHAR(20),
    ANNUAL_SALARY DECIMAL(12,2),
    PLAN_ID VARCHAR(10),
    ELIGIBILITY_DATE DATE,
    ENROLLMENT_STATUS VARCHAR(20),
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Account balances and contributions
CREATE OR REPLACE TABLE ACCOUNT_BALANCES (
    ACCOUNT_ID VARCHAR(20) PRIMARY KEY,
    PARTICIPANT_ID VARCHAR(20),
    PLAN_ID VARCHAR(10),
    EMPLOYEE_CONTRIB_PCT DECIMAL(5,2),
    EMPLOYER_MATCH_PCT DECIMAL(5,2),
    CURRENT_BALANCE DECIMAL(15,2),
    VESTED_BALANCE DECIMAL(15,2),
    YTD_EMPLOYEE_CONTRIB DECIMAL(12,2),
    YTD_EMPLOYER_CONTRIB DECIMAL(12,2),
    LAST_UPDATED TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (PARTICIPANT_ID) REFERENCES PARTICIPANTS(PARTICIPANT_ID)
);

-- Investment fund information
CREATE OR REPLACE TABLE INVESTMENT_FUNDS (
    FUND_ID VARCHAR(20) PRIMARY KEY,
    FUND_NAME VARCHAR(100),
    FUND_TYPE VARCHAR(50),
    EXPENSE_RATIO DECIMAL(6,4),
    YTD_RETURN DECIMAL(8,4),
    RISK_CATEGORY VARCHAR(20),
    ASSET_CLASS VARCHAR(30),
    FUND_DESCRIPTION TEXT
);

-- Participant investment allocations
CREATE OR REPLACE TABLE INVESTMENT_ALLOCATIONS (
    ALLOCATION_ID VARCHAR(30) PRIMARY KEY,
    PARTICIPANT_ID VARCHAR(20),
    FUND_ID VARCHAR(20),
    ALLOCATION_PCT DECIMAL(5,2),
    EFFECTIVE_DATE DATE,
    FOREIGN KEY (PARTICIPANT_ID) REFERENCES PARTICIPANTS(PARTICIPANT_ID),
    FOREIGN KEY (FUND_ID) REFERENCES INVESTMENT_FUNDS(FUND_ID)
);

-- Plan information
CREATE OR REPLACE TABLE RETIREMENT_PLANS (
    PLAN_ID VARCHAR(10) PRIMARY KEY,
    PLAN_NAME VARCHAR(100),
    PLAN_TYPE VARCHAR(20),
    EMPLOYER_EIN VARCHAR(10),
    EMPLOYER_NAME VARCHAR(100),
    PLAN_YEAR_END DATE,
    ENTRY_REQUIREMENTS TEXT,
    VESTING_SCHEDULE TEXT,
    MAXIMUM_MATCH_PCT DECIMAL(5,2),
    AUTO_ENROLL_ENABLED BOOLEAN,
    DEFAULT_CONTRIB_PCT DECIMAL(5,2)
);

-- 💬 CREATE DOCUMENT PROCESSING TABLES
-- ============================================================================
USE SCHEMA DOCUMENTS;

-- Track processed documents
CREATE OR REPLACE TABLE DOCUMENT_REGISTRY (
    DOCUMENT_ID VARCHAR(50) PRIMARY KEY,
    DOCUMENT_NAME VARCHAR(200),
    DOCUMENT_TYPE VARCHAR(50),
    FILE_PATH VARCHAR(500),
    UPLOAD_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    PROCESSING_STATUS VARCHAR(20) DEFAULT 'PENDING',
    EXTRACTED_TEXT TEXT,
    METADATA VARIANT,
    PLAN_ID VARCHAR(10)
);

-- Store text chunks for vector search
CREATE OR REPLACE TABLE DOCUMENT_CHUNKS (
    CHUNK_ID VARCHAR(100) PRIMARY KEY,
    DOCUMENT_ID VARCHAR(50),
    CHUNK_TEXT TEXT,
    CHUNK_INDEX INTEGER,
    EMBEDDING VECTOR(FLOAT, 768),
    METADATA VARIANT,
    FOREIGN KEY (DOCUMENT_ID) REFERENCES DOCUMENT_REGISTRY(DOCUMENT_ID)
);

-- 🔍 CREATE CORTEX SEARCH SERVICE
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE RETIREMENT_DOC_SEARCH
ON CHUNK_TEXT
ATTRIBUTES DOCUMENT_TYPE, PLAN_ID, DOCUMENT_NAME
WAREHOUSE = RETIREMENT_AI_WH
TARGET_LAG = '1 minute'
COMMENT = 'Semantic search across all retirement plan documents';

-- 📈 CREATE ANALYTICS VIEWS
-- ============================================================================
USE SCHEMA ANALYTICS;

-- Participant summary view for natural language queries
CREATE OR REPLACE VIEW PARTICIPANT_OVERVIEW AS
SELECT 
    p.PARTICIPANT_ID,
    p.FIRST_NAME || ' ' || p.LAST_NAME AS FULL_NAME,
    p.EMAIL,
    p.EMPLOYMENT_STATUS,
    p.ANNUAL_SALARY,
    p.ENROLLMENT_STATUS,
    ab.CURRENT_BALANCE,
    ab.VESTED_BALANCE,
    ab.YTD_EMPLOYEE_CONTRIB,
    ab.YTD_EMPLOYER_CONTRIB,
    rp.PLAN_NAME,
    rp.EMPLOYER_NAME,
    DATEDIFF('year', p.DATE_OF_BIRTH, CURRENT_DATE()) AS AGE,
    DATEDIFF('year', p.HIRE_DATE, CURRENT_DATE()) AS YEARS_OF_SERVICE
FROM PARTICIPANT_DATA.PARTICIPANTS p
LEFT JOIN PARTICIPANT_DATA.ACCOUNT_BALANCES ab ON p.PARTICIPANT_ID = ab.PARTICIPANT_ID
LEFT JOIN PARTICIPANT_DATA.RETIREMENT_PLANS rp ON p.PLAN_ID = rp.PLAN_ID;

-- Fund performance summary
CREATE OR REPLACE VIEW FUND_PERFORMANCE AS
SELECT 
    f.FUND_ID,
    f.FUND_NAME,
    f.FUND_TYPE,
    f.ASSET_CLASS,
    f.YTD_RETURN,
    f.EXPENSE_RATIO,
    f.RISK_CATEGORY,
    COUNT(ia.PARTICIPANT_ID) AS PARTICIPANT_COUNT,
    SUM(ab.CURRENT_BALANCE * ia.ALLOCATION_PCT / 100) AS TOTAL_ASSETS
FROM PARTICIPANT_DATA.INVESTMENT_FUNDS f
LEFT JOIN PARTICIPANT_DATA.INVESTMENT_ALLOCATIONS ia ON f.FUND_ID = ia.FUND_ID
LEFT JOIN PARTICIPANT_DATA.ACCOUNT_BALANCES ab ON ia.PARTICIPANT_ID = ab.PARTICIPANT_ID
GROUP BY f.FUND_ID, f.FUND_NAME, f.FUND_TYPE, f.ASSET_CLASS, f.YTD_RETURN, f.EXPENSE_RATIO, f.RISK_CATEGORY;

-- 🤖 CREATE CUSTOM AI FUNCTIONS
-- ============================================================================
USE SCHEMA CORTEX_FUNCTIONS;

-- Function to analyze participant questions
CREATE OR REPLACE FUNCTION ANALYZE_PARTICIPANT_QUESTION(question TEXT)
RETURNS TEXT
LANGUAGE SQL
AS
$$
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'llama3.1-8b',
    'You are a retirement plan AI assistant. Analyze this participant question and categorize it: ' || question ||
    '. Categories: BALANCE_INQUIRY, CONTRIBUTION_CHANGE, INVESTMENT_HELP, LOAN_REQUEST, DISTRIBUTION_QUESTION, BENEFICIARY_UPDATE, GENERAL_INFO. ' ||
    'Respond with just the category and a brief explanation.'
)
$$;

-- Function to generate participant summaries
CREATE OR REPLACE FUNCTION GENERATE_PARTICIPANT_SUMMARY(participant_id TEXT)
RETURNS TEXT
LANGUAGE SQL
AS
$$
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'llama3.1-8b',
    'Create a concise participant summary based on this data: ' ||
    (SELECT OBJECT_CONSTRUCT(*) FROM ANALYTICS.PARTICIPANT_OVERVIEW WHERE PARTICIPANT_ID = participant_id)::TEXT ||
    '. Include key metrics, contribution status, and any recommendations.'
)
$$;

-- 🎯 LOAD SAMPLE DATA
-- ============================================================================

-- Sample retirement plans
INSERT INTO PARTICIPANT_DATA.RETIREMENT_PLANS VALUES
('PLAN001', 'TechCorp 401(k) Plan', '401k', '12-3456789', 'TechCorp Industries', '2024-12-31', 'Immediate eligibility upon hire', '6-year graded vesting', 4.0, TRUE, 3.0),
('PLAN002', 'HealthPlus 403(b) Plan', '403b', '98-7654321', 'HealthPlus Medical Group', '2024-12-31', '1 year of service, 1000 hours', '3-year cliff vesting', 3.0, FALSE, 0.0),
('PLAN003', 'EduCare Pension Plan', 'Pension', '55-1234567', 'EduCare School District', '2024-06-30', 'Age 21, 1 year service', '5-year graded vesting', 0.0, FALSE, 0.0);

-- Sample investment funds
INSERT INTO PARTICIPANT_DATA.INVESTMENT_FUNDS VALUES
('FUND001', 'Large Cap Growth Fund', 'Mutual Fund', 0.0075, 0.1250, 'Moderate', 'US Large Cap', 'Diversified large-cap growth stocks'),
('FUND002', 'Bond Index Fund', 'Index Fund', 0.0025, 0.0420, 'Conservative', 'Fixed Income', 'Broad market bond index'),
('FUND003', 'International Equity Fund', 'Mutual Fund', 0.0095, 0.0890, 'Moderate-High', 'International', 'Developed and emerging market stocks'),
('FUND004', 'Target Date 2060 Fund', 'Target Date', 0.0065, 0.1100, 'Moderate', 'Mixed Asset', 'Age-appropriate asset allocation'),
('FUND005', 'Small Cap Value Fund', 'Mutual Fund', 0.0085, 0.1420, 'High', 'US Small Cap', 'Small-cap value opportunities'),
('FUND006', 'Money Market Fund', 'Stable Value', 0.0015, 0.0320, 'Very Conservative', 'Cash', 'Capital preservation with liquidity');

-- ✅ VERIFICATION QUERIES
-- ============================================================================

-- Verify setup
SELECT 'Database Created' AS status, COUNT(*) AS table_count 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA IN ('DOCUMENTS', 'PARTICIPANT_DATA', 'COMPLIANCE', 'ANALYTICS', 'CORTEX_FUNCTIONS');

SELECT 'Warehouse Active' AS status, CURRENT_WAREHOUSE() AS warehouse_name;

SELECT 'Schemas Ready' AS status, SCHEMA_NAME 
FROM INFORMATION_SCHEMA.SCHEMATA 
WHERE SCHEMA_NAME IN ('DOCUMENTS', 'PARTICIPANT_DATA', 'COMPLIANCE', 'ANALYTICS', 'CORTEX_FUNCTIONS');

-- 🎉 SUCCESS MESSAGE
SELECT '🎉 Retirement Plan AI Lab Setup Complete! 🎉' AS message,
       'Ready to test document AI, vector search, and natural language queries on retirement plan data' AS next_steps; 