-- ============================================================================
-- 🏦 Load Realistic Sample Data for Retirement Plan AI Testing
-- ============================================================================
-- Execute this after setup/initial-setup.sql to populate with demo data
-- Creates realistic participant profiles, account data, and investment scenarios
-- ============================================================================

USE DATABASE RETIREMENT_PLAN_AI;
USE WAREHOUSE RETIREMENT_AI_WH;

-- 🧑‍💼 LOAD SAMPLE PARTICIPANTS
-- ============================================================================

-- Insert diverse participant demographics for realistic testing
INSERT INTO PARTICIPANT_DATA.PARTICIPANTS (
    PARTICIPANT_ID, SSN_LAST_4, FIRST_NAME, LAST_NAME, EMAIL, 
    DATE_OF_BIRTH, HIRE_DATE, EMPLOYMENT_STATUS, ANNUAL_SALARY, 
    PLAN_ID, ELIGIBILITY_DATE, ENROLLMENT_STATUS
) VALUES
-- TechCorp Employees (401k)
('PART_001', '1234', 'Sarah', 'Johnson', 'sarah.johnson@techcorp.com', '1985-03-15', '2020-01-15', 'Active', 95000, 'PLAN001', '2020-04-15', 'Active'),
('PART_002', '5678', 'Michael', 'Chen', 'michael.chen@techcorp.com', '1978-08-22', '2018-06-01', 'Active', 125000, 'PLAN001', '2018-06-01', 'Active'),
('PART_003', '9012', 'Jennifer', 'Williams', 'jennifer.williams@techcorp.com', '1992-11-10', '2022-03-01', 'Active', 72000, 'PLAN001', '2022-06-01', 'Active'),
('PART_004', '3456', 'David', 'Brown', 'david.brown@techcorp.com', '1965-04-18', '2010-09-15', 'Active', 145000, 'PLAN001', '2010-09-15', 'Active'),
('PART_005', '7890', 'Lisa', 'Garcia', 'lisa.garcia@techcorp.com', '1988-12-05', '2021-07-20', 'Active', 85000, 'PLAN001', '2021-10-20', 'Active'),
('PART_006', '2345', 'Robert', 'Miller', 'robert.miller@techcorp.com', '1970-07-30', '2015-02-10', 'Active', 110000, 'PLAN001', '2015-02-10', 'Active'),
('PART_007', '6789', 'Amanda', 'Davis', 'amanda.davis@techcorp.com', '1995-01-12', '2023-01-10', 'Active', 68000, 'PLAN001', '2023-04-10', 'Eligible'),
('PART_008', '0123', 'James', 'Wilson', 'james.wilson@techcorp.com', '1982-06-25', '2019-11-01', 'Active', 98000, 'PLAN001', '2020-02-01', 'Active'),
('PART_009', '4567', 'Maria', 'Rodriguez', 'maria.rodriguez@techcorp.com', '1975-09-14', '2017-04-15', 'Active', 115000, 'PLAN001', '2017-04-15', 'Active'),
('PART_010', '8901', 'Christopher', 'Taylor', 'chris.taylor@techcorp.com', '1990-02-28', '2021-12-01', 'Active', 78000, 'PLAN001', '2022-03-01', 'Active'),

-- HealthPlus Employees (403b)
('PART_011', '1122', 'Dr. Emily', 'Anderson', 'emily.anderson@healthplus.org', '1980-05-20', '2019-08-01', 'Active', 165000, 'PLAN002', '2020-08-01', 'Active'),
('PART_012', '3344', 'Nurse John', 'Thompson', 'john.thompson@healthplus.org', '1985-11-30', '2020-01-15', 'Active', 75000, 'PLAN002', '2021-01-15', 'Active'),
('PART_013', '5566', 'Dr. Patricia', 'White', 'patricia.white@healthplus.org', '1972-03-08', '2016-05-10', 'Active', 180000, 'PLAN002', '2017-05-10', 'Active'),
('PART_014', '7788', 'Mark', 'Johnson', 'mark.johnson@healthplus.org', '1987-12-22', '2021-09-01', 'Active', 82000, 'PLAN002', '2022-09-01', 'Active'),
('PART_015', '9900', 'Dr. Susan', 'Lee', 'susan.lee@healthplus.org', '1968-07-15', '2012-03-20', 'Active', 195000, 'PLAN002', '2013-03-20', 'Active'),

-- EduCare School District (Pension + 403b)
('PART_016', '2468', 'Teacher Mary', 'Clark', 'mary.clark@educare.edu', '1976-04-12', '2018-08-15', 'Active', 58000, 'PLAN003', '2019-08-15', 'Active'),
('PART_017', '1357', 'Principal James', 'Hall', 'james.hall@educare.edu', '1970-10-05', '2015-07-01', 'Active', 85000, 'PLAN003', '2016-07-01', 'Active'),
('PART_018', '8642', 'Teacher Linda', 'Young', 'linda.young@educare.edu', '1983-01-18', '2020-08-20', 'Active', 52000, 'PLAN003', '2021-08-20', 'Active'),
('PART_019', '9753', 'Counselor Tom', 'King', 'tom.king@educare.edu', '1979-08-09', '2017-01-10', 'Active', 62000, 'PLAN003', '2018-01-10', 'Active'),
('PART_020', '1470', 'Teacher Anna', 'Wright', 'anna.wright@educare.edu', '1990-12-30', '2022-08-01', 'Active', 48000, 'PLAN003', '2023-08-01', 'Eligible');

-- 💰 LOAD ACCOUNT BALANCES AND CONTRIBUTIONS
-- ============================================================================

INSERT INTO PARTICIPANT_DATA.ACCOUNT_BALANCES (
    ACCOUNT_ID, PARTICIPANT_ID, PLAN_ID, EMPLOYEE_CONTRIB_PCT, EMPLOYER_MATCH_PCT,
    CURRENT_BALANCE, VESTED_BALANCE, YTD_EMPLOYEE_CONTRIB, YTD_EMPLOYER_CONTRIB
) VALUES
-- TechCorp 401k accounts
('ACC_001', 'PART_001', 'PLAN001', 8.00, 4.00, 125000, 125000, 7600, 3800),
('ACC_002', 'PART_002', 'PLAN001', 12.00, 4.00, 285000, 285000, 15000, 5000),
('ACC_003', 'PART_003', 'PLAN001', 6.00, 4.00, 35000, 35000, 4320, 2880),
('ACC_004', 'PART_004', 'PLAN001', 15.00, 4.00, 750000, 750000, 21750, 5800),
('ACC_005', 'PART_005', 'PLAN001', 10.00, 4.00, 95000, 95000, 8500, 3400),
('ACC_006', 'PART_006', 'PLAN001', 8.00, 4.00, 485000, 485000, 8800, 4400),
('ACC_007', 'PART_007', 'PLAN001', 0.00, 0.00, 0, 0, 0, 0),  -- Eligible but not enrolled
('ACC_008', 'PART_008', 'PLAN001', 7.00, 4.00, 135000, 135000, 6860, 3920),
('ACC_009', 'PART_009', 'PLAN001', 10.00, 4.00, 295000, 295000, 11500, 4600),
('ACC_010', 'PART_010', 'PLAN001', 5.00, 4.00, 65000, 65000, 3900, 3120),

-- HealthPlus 403b accounts
('ACC_011', 'PART_011', 'PLAN002', 12.00, 3.00, 325000, 325000, 19800, 4950),
('ACC_012', 'PART_012', 'PLAN002', 8.00, 3.00, 85000, 85000, 6000, 2250),
('ACC_013', 'PART_013', 'PLAN002', 15.00, 3.00, 565000, 565000, 27000, 5400),
('ACC_014', 'PART_014', 'PLAN002', 6.00, 3.00, 45000, 45000, 4920, 2460),
('ACC_015', 'PART_015', 'PLAN002', 18.00, 3.00, 895000, 895000, 35100, 5850),

-- EduCare pension accounts (lower balances typical of public sector)
('ACC_016', 'PART_016', 'PLAN003', 7.00, 0.00, 75000, 75000, 4060, 0),
('ACC_017', 'PART_017', 'PLAN003', 8.00, 0.00, 125000, 125000, 6800, 0),
('ACC_018', 'PART_018', 'PLAN003', 5.00, 0.00, 35000, 35000, 2600, 0),
('ACC_019', 'PART_019', 'PLAN003', 9.00, 0.00, 95000, 95000, 5580, 0),
('ACC_020', 'PART_020', 'PLAN003', 0.00, 0.00, 0, 0, 0, 0);  -- Not yet enrolled

-- 📊 LOAD INVESTMENT ALLOCATIONS
-- ============================================================================

-- Create realistic investment allocations for participants
INSERT INTO PARTICIPANT_DATA.INVESTMENT_ALLOCATIONS (
    ALLOCATION_ID, PARTICIPANT_ID, FUND_ID, ALLOCATION_PCT, EFFECTIVE_DATE
) VALUES
-- Sarah Johnson (PART_001) - Balanced allocation, age 39
('ALLOC_001_001', 'PART_001', 'FUND004', 50.00, '2023-01-01'),  -- Target Date 2060
('ALLOC_001_002', 'PART_001', 'FUND001', 30.00, '2023-01-01'),  -- Large Cap Growth
('ALLOC_001_003', 'PART_001', 'FUND002', 20.00, '2023-01-01'),  -- Bond Index

-- Michael Chen (PART_002) - Aggressive growth, high earner
('ALLOC_002_001', 'PART_002', 'FUND001', 40.00, '2023-01-01'),  -- Large Cap Growth
('ALLOC_002_002', 'PART_002', 'FUND005', 25.00, '2023-01-01'),  -- Small Cap Value
('ALLOC_002_003', 'PART_002', 'FUND003', 25.00, '2023-01-01'),  -- International
('ALLOC_002_004', 'PART_002', 'FUND002', 10.00, '2023-01-01'),  -- Bonds

-- Jennifer Williams (PART_003) - Young employee, target date focused
('ALLOC_003_001', 'PART_003', 'FUND004', 80.00, '2023-01-01'),  -- Target Date 2060
('ALLOC_003_002', 'PART_003', 'FUND001', 20.00, '2023-01-01'),  -- Large Cap Growth

-- David Brown (PART_004) - Near retirement, conservative shift
('ALLOC_004_001', 'PART_004', 'FUND002', 40.00, '2023-01-01'),  -- Bond Index
('ALLOC_004_002', 'PART_004', 'FUND001', 35.00, '2023-01-01'),  -- Large Cap Growth
('ALLOC_004_003', 'PART_004', 'FUND006', 15.00, '2023-01-01'),  -- Money Market
('ALLOC_004_004', 'PART_004', 'FUND003', 10.00, '2023-01-01'),  -- International

-- Dr. Emily Anderson (PART_011) - High earner, diversified
('ALLOC_011_001', 'PART_011', 'FUND001', 45.00, '2023-01-01'),  -- Large Cap Growth
('ALLOC_011_002', 'PART_011', 'FUND003', 25.00, '2023-01-01'),  -- International
('ALLOC_011_003', 'PART_011', 'FUND002', 20.00, '2023-01-01'),  -- Bond Index
('ALLOC_011_004', 'PART_011', 'FUND005', 10.00, '2023-01-01'),  -- Small Cap Value

-- Dr. Susan Lee (PART_015) - Pre-retirement, wealth preservation
('ALLOC_015_001', 'PART_015', 'FUND002', 50.00, '2023-01-01'),  -- Bond Index
('ALLOC_015_002', 'PART_015', 'FUND001', 30.00, '2023-01-01'),  -- Large Cap Growth
('ALLOC_015_003', 'PART_015', 'FUND006', 20.00, '2023-01-01');  -- Money Market

-- 📈 CREATE REALISTIC PERFORMANCE DATA
-- ============================================================================

-- Update fund performance with realistic 2024 returns
UPDATE PARTICIPANT_DATA.INVESTMENT_FUNDS 
SET YTD_RETURN = CASE FUND_ID
    WHEN 'FUND001' THEN 0.1250  -- Large Cap Growth: 12.5%
    WHEN 'FUND002' THEN 0.0420  -- Bond Index: 4.2%
    WHEN 'FUND003' THEN 0.0890  -- International: 8.9%
    WHEN 'FUND004' THEN 0.1100  -- Target Date 2060: 11.0%
    WHEN 'FUND005' THEN 0.1420  -- Small Cap Value: 14.2%
    WHEN 'FUND006' THEN 0.0320  -- Money Market: 3.2%
    ELSE YTD_RETURN
END;

-- 🎯 CREATE SAMPLE COMPLIANCE SCENARIOS
-- ============================================================================

-- Insert some compliance-worthy scenarios for testing
-- High balance participants (might need additional fiduciary oversight)
UPDATE PARTICIPANT_DATA.ACCOUNT_BALANCES 
SET CURRENT_BALANCE = 450000, VESTED_BALANCE = 450000 
WHERE ACCOUNT_ID IN ('ACC_004', 'ACC_013', 'ACC_015');

-- Participants approaching RMD age (72)
-- Dr. Susan Lee is 56, so let's create a scenario where she's approaching 70
UPDATE PARTICIPANT_DATA.PARTICIPANTS 
SET DATE_OF_BIRTH = '1954-07-15'  -- Makes her 70 years old
WHERE PARTICIPANT_ID = 'PART_015';

-- Create catch-up contribution scenarios (participants over 50)
INSERT INTO PARTICIPANT_DATA.PARTICIPANTS (
    PARTICIPANT_ID, SSN_LAST_4, FIRST_NAME, LAST_NAME, EMAIL, 
    DATE_OF_BIRTH, HIRE_DATE, EMPLOYMENT_STATUS, ANNUAL_SALARY, 
    PLAN_ID, ELIGIBILITY_DATE, ENROLLMENT_STATUS
) VALUES
('PART_021', '5555', 'Robert', 'Senior', 'robert.senior@techcorp.com', '1971-06-15', '2005-01-01', 'Active', 135000, 'PLAN001', '2005-01-01', 'Active'),
('PART_022', '6666', 'Margaret', 'Veteran', 'margaret.veteran@healthplus.org', '1969-03-20', '2000-08-15', 'Active', 125000, 'PLAN002', '2001-08-15', 'Active');

-- Add corresponding account data for catch-up eligible participants
INSERT INTO PARTICIPANT_DATA.ACCOUNT_BALANCES (
    ACCOUNT_ID, PARTICIPANT_ID, PLAN_ID, EMPLOYEE_CONTRIB_PCT, EMPLOYER_MATCH_PCT,
    CURRENT_BALANCE, VESTED_BALANCE, YTD_EMPLOYEE_CONTRIB, YTD_EMPLOYER_CONTRIB
) VALUES
('ACC_021', 'PART_021', 'PLAN001', 15.00, 4.00, 485000, 485000, 20250, 5400),  -- Maxing out with catch-up
('ACC_022', 'PART_022', 'PLAN002', 18.00, 3.00, 625000, 625000, 22500, 3750);  -- High saver

-- 📝 ADD REALISTIC DOCUMENT SCENARIOS
-- ============================================================================

-- Add more sample documents to test document AI capabilities
INSERT INTO DOCUMENTS.DOCUMENT_REGISTRY (
    DOCUMENT_ID, DOCUMENT_NAME, DOCUMENT_TYPE, FILE_PATH, 
    PROCESSING_STATUS, EXTRACTED_TEXT, PLAN_ID
) VALUES 
(
    'DOC_AMENDMENT_001',
    'Plan Amendment 2024-01 - Auto-Enrollment Enhancement',
    'Plan_Amendment',
    'amendments/amendment-2024-01-auto-enrollment.pdf',
    'EXTRACTED',
    'PLAN AMENDMENT 2024-01 - AUTO-ENROLLMENT ENHANCEMENT
    
Effective Date: January 1, 2024

This amendment modifies the TechCorp 401(k) Plan to enhance the automatic enrollment feature:

1. AUTOMATIC ENROLLMENT PERCENTAGE: The default contribution rate for automatically enrolled participants is increased from 3% to 4% of eligible compensation.

2. AUTOMATIC ESCALATION: New participants will be automatically enrolled in the annual contribution increase feature, which will increase their contribution rate by 1% each year until reaching 10% of eligible compensation.

3. ELIGIBLE EMPLOYEES: All newly hired employees who are at least 18 years old will be automatically enrolled 30 days after their date of hire.

4. OPT-OUT PROVISIONS: Participants may opt out of automatic enrollment or modify their contribution rate at any time by completing the appropriate election form or accessing the participant website.

This amendment is intended to help participants build adequate retirement savings through higher initial contribution rates and automatic escalation.',
    'PLAN001'
),
(
    'DOC_NOTICE_001',
    'Annual Notice - Safe Harbor Match 2024',
    'Participant_Communication',
    'notices/safe-harbor-notice-2024.pdf',
    'EXTRACTED',
    'ANNUAL SAFE HARBOR NOTICE - 2024

Dear TechCorp 401(k) Plan Participants,

We are pleased to inform you that TechCorp will continue to provide Safe Harbor matching contributions for the 2024 plan year.

SAFE HARBOR MATCHING FORMULA:
• 100% match on the first 4% of compensation you contribute
• Immediate 100% vesting of all employer matching contributions
• No discrimination testing requirements

CONTRIBUTION LIMITS FOR 2024:
• Employee deferrals: $23,000 ($30,500 if age 50 or older)
• Total contributions (employee + employer): $69,000 ($76,500 if age 50 or older)

To maximize your employer match, contribute at least 4% of your eligible compensation. Remember, these matching contributions are "free money" toward your retirement!

Questions? Contact HR at hr@techcorp.com or call 1-800-TECHCORP.

Sincerely,
TechCorp Human Resources',
    'PLAN001'
),
(
    'DOC_COMPLIANCE_001',
    'Form 5500 Preparation Checklist - Plan Year 2023',
    'Compliance',
    'compliance/form-5500-checklist-2023.pdf',
    'EXTRACTED',
    'FORM 5500 PREPARATION CHECKLIST - PLAN YEAR 2023

Filing Deadline: July 31, 2024 (with extension)

REQUIRED DOCUMENTATION:
□ Plan census data as of December 31, 2023
□ Financial statements audited by independent CPA
□ Investment performance reports for all plan options
□ Summary of material modifications distributed to participants
□ Proof of fidelity bond coverage ($1,000,000 minimum)
□ Schedule of plan assets and liabilities
□ Summary of loans outstanding to participants
□ Documentation of any plan amendments during 2023

TESTING REQUIREMENTS COMPLETED:
□ ADP/ACP testing (if applicable)
□ Top Heavy testing
□ Coverage testing under IRC Section 410(b)
□ Minimum participation requirements verification

PARTICIPANT COMMUNICATIONS:
□ Summary Annual Report distributed within 9 months of plan year end
□ Annual fee disclosure notice provided
□ Investment performance benchmarking completed

Contact: retirement.compliance@techcorp.com for questions.',
    'PLAN001'
);

-- 🔧 GENERATE EMBEDDINGS FOR NEW DATA
-- ============================================================================

-- Process all newly inserted documents
CALL CHUNK_PLAN_DOCUMENT('DOC_AMENDMENT_001', 'Plan Amendment 2024-01 - Auto-Enrollment Enhancement');
CALL CHUNK_PLAN_DOCUMENT('DOC_NOTICE_001', 'Annual Notice - Safe Harbor Match 2024');
CALL CHUNK_PLAN_DOCUMENT('DOC_COMPLIANCE_001', 'Form 5500 Preparation Checklist - Plan Year 2023');

-- Generate embeddings for all participants (including new ones)
CALL GENERATE_ALL_PARTICIPANT_EMBEDDINGS();
CALL GENERATE_ALL_FUND_EMBEDDINGS();

-- ✅ VERIFICATION QUERIES
-- ============================================================================

-- Verify data loading
SELECT 'Participants Loaded' AS data_type, COUNT(*) AS record_count FROM PARTICIPANT_DATA.PARTICIPANTS
UNION ALL
SELECT 'Account Balances Loaded' AS data_type, COUNT(*) AS record_count FROM PARTICIPANT_DATA.ACCOUNT_BALANCES
UNION ALL
SELECT 'Investment Allocations Loaded' AS data_type, COUNT(*) AS record_count FROM PARTICIPANT_DATA.INVESTMENT_ALLOCATIONS
UNION ALL
SELECT 'Documents Loaded' AS data_type, COUNT(*) AS record_count FROM DOCUMENTS.DOCUMENT_REGISTRY
UNION ALL
SELECT 'Document Chunks Created' AS data_type, COUNT(*) AS record_count FROM DOCUMENTS.DOCUMENT_CHUNKS;

-- Show some interesting demographics
SELECT 
    'Age Distribution' AS metric,
    CASE 
        WHEN DATEDIFF('year', DATE_OF_BIRTH, CURRENT_DATE()) < 30 THEN 'Under 30'
        WHEN DATEDIFF('year', DATE_OF_BIRTH, CURRENT_DATE()) < 40 THEN '30-39'
        WHEN DATEDIFF('year', DATE_OF_BIRTH, CURRENT_DATE()) < 50 THEN '40-49'
        WHEN DATEDIFF('year', DATE_OF_BIRTH, CURRENT_DATE()) < 60 THEN '50-59'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS participant_count,
    AVG(ANNUAL_SALARY) AS avg_salary
FROM PARTICIPANT_DATA.PARTICIPANTS 
GROUP BY age_group
ORDER BY age_group;

-- Show participation rates by plan
SELECT 
    rp.PLAN_NAME,
    rp.PLAN_TYPE,
    COUNT(*) AS eligible_participants,
    SUM(CASE WHEN p.ENROLLMENT_STATUS = 'Active' THEN 1 ELSE 0 END) AS active_participants,
    ROUND(SUM(CASE WHEN p.ENROLLMENT_STATUS = 'Active' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS participation_rate_pct
FROM PARTICIPANT_DATA.PARTICIPANTS p
JOIN PARTICIPANT_DATA.RETIREMENT_PLANS rp ON p.PLAN_ID = rp.PLAN_ID
GROUP BY rp.PLAN_NAME, rp.PLAN_TYPE;

-- Show account balance distribution
SELECT 
    'Account Balance Distribution' AS metric,
    CASE 
        WHEN ab.CURRENT_BALANCE = 0 THEN 'No Balance'
        WHEN ab.CURRENT_BALANCE < 25000 THEN 'Under $25K'
        WHEN ab.CURRENT_BALANCE < 100000 THEN '$25K - $100K'
        WHEN ab.CURRENT_BALANCE < 250000 THEN '$100K - $250K'
        WHEN ab.CURRENT_BALANCE < 500000 THEN '$250K - $500K'
        ELSE 'Over $500K'
    END AS balance_range,
    COUNT(*) AS participant_count,
    SUM(ab.CURRENT_BALANCE) AS total_assets
FROM PARTICIPANT_DATA.ACCOUNT_BALANCES ab
GROUP BY balance_range
ORDER BY MIN(ab.CURRENT_BALANCE);

-- 🎉 SUCCESS MESSAGE
-- ============================================================================

SELECT '🎉 Sample Data Loading Complete!' as status,
       'Realistic retirement plan data ready for AI testing and demos' as message,
       'Ready to test: Document AI, Vector Search, Structured Queries, and Unified Interface' as next_steps; 