-- ============================================================================
-- 📄 Additional Sample Documents for Text Extraction Demo
-- ============================================================================
-- Run this after load-sample-data.sql to add more realistic PDF content
-- Creates diverse document types commonly found in retirement plan administration
-- ============================================================================

USE DATABASE RETIREMENT_PLAN_AI;
USE SCHEMA DOCUMENTS;

-- 📋 SUMMARY PLAN DESCRIPTIONS
-- ============================================================================

INSERT INTO DOCUMENT_REGISTRY (
    DOCUMENT_ID, DOCUMENT_NAME, DOCUMENT_TYPE, FILE_PATH, 
    PROCESSING_STATUS, EXTRACTED_TEXT, PLAN_ID
) VALUES 
(
    'DOC_SPD_HEALTHPLUS_001',
    'HealthPlus 403(b) Plan Summary Plan Description',
    'SPD',
    'spd/healthplus-403b-spd-2024.pdf',
    'EXTRACTED',
    'SUMMARY PLAN DESCRIPTION
HEALTHPLUS MEDICAL GROUP 403(b) RETIREMENT PLAN
Effective January 1, 2024

PLAN OVERVIEW
The HealthPlus Medical Group 403(b) Plan is designed to help eligible employees save for retirement through tax-advantaged contributions and employer matching.

ELIGIBILITY
You are eligible to participate if you:
• Are employed by HealthPlus Medical Group
• Have completed one year of service (1,000 hours minimum)
• Are at least 21 years old

CONTRIBUTIONS
Employee Elective Deferrals:
• Minimum: 1% of annual compensation
• Maximum: 100% of compensation up to IRS limits ($23,000 for 2024, $30,500 if age 50+)
• Roth deferrals available

Employer Matching:
• 50% match on first 6% of compensation contributed
• Requires 2 years of service for eligibility
• Immediate vesting for employee contributions
• 3-year cliff vesting for employer contributions

INVESTMENT OPTIONS
The Plan offers 12 professionally managed investment options:
• Target-date funds (2025, 2030, 2035, 2040, 2045, 2050, 2055, 2060, 2065)
• Large-cap equity funds
• International equity funds  
• Fixed-income funds
• Stable value fund

DISTRIBUTIONS
• In-service withdrawals allowed after age 59½
• Required minimum distributions begin at age 73
• Loans available up to $50,000 or 50% of vested balance
• Hardship withdrawals permitted under IRS guidelines

PLAN ADMINISTRATION
Plan Administrator: HealthPlus HR Department
Recordkeeper: National Retirement Services
Investment Advisor: Financial Planning Associates',
    'PLAN002'
),
(
    'DOC_SPD_EDUCARE_001', 
    'EduCare School District Pension Plan Summary',
    'SPD',
    'spd/educare-pension-spd-2024.pdf',
    'EXTRACTED',
    'SUMMARY PLAN DESCRIPTION
EDUCARE SCHOOL DISTRICT PENSION PLAN
Plan Year: July 1, 2023 - June 30, 2024

INTRODUCTION
The EduCare School District Pension Plan provides retirement benefits to eligible employees through a defined benefit pension formula and optional 403(b) savings plan.

PENSION PLAN BENEFITS
Pension Formula:
• 2.0% × Years of Service × Final Average Salary
• Final Average Salary = highest 3 consecutive years
• Maximum benefit: 80% of Final Average Salary

Vesting Schedule:
• 5-year graded vesting:
  - 3 years: 30% vested
  - 4 years: 60% vested  
  - 5 years: 100% vested

Retirement Eligibility:
• Normal retirement: Age 65 with 5 years of service
• Early retirement: Age 55 with 10 years of service (reduced benefits)
• Disability retirement: Any age with 10 years of service

SUPPLEMENTAL 403(b) PLAN
Employee Contributions:
• Voluntary deferrals up to IRS limits
• No employer matching for 403(b) component
• Roth and traditional options available

SURVIVOR BENEFITS
• 50% joint and survivor annuity (automatic for married participants)
• Optional 75% or 100% joint and survivor elections
• Pre-retirement death benefits equal to employee contributions plus interest

PLAN FUNDING
• Employee contributions: 7% of compensation (mandatory)
• District contributions: Actuarially determined annually
• Assets invested by State Pension Board',
    'PLAN003'
);

-- 📝 PARTICIPANT FORMS AND COMMUNICATIONS
-- ============================================================================

INSERT INTO DOCUMENT_REGISTRY (
    DOCUMENT_ID, DOCUMENT_NAME, DOCUMENT_TYPE, FILE_PATH, 
    PROCESSING_STATUS, EXTRACTED_TEXT, PLAN_ID
) VALUES 
(
    'DOC_FORM_ENROLLMENT_001',
    'Retirement Plan Enrollment Form - TechCorp',
    'Enrollment_Form',
    'forms/techcorp-enrollment-form.pdf',
    'EXTRACTED',
    'TECHCORP 401(k) PLAN ENROLLMENT FORM

PARTICIPANT INFORMATION
Name: _________________________________ Employee ID: ___________
Social Security Number: XXX-XX-_____ Date of Birth: ___/___/_____
Email: _________________________________ Phone: ________________
Department: ____________________________ Hire Date: ___/___/_____

CONTRIBUTION ELECTION
I elect to contribute the following to my 401(k) account:

Pre-Tax Contributions: ____% or $_____ per pay period
Roth Contributions: ____% or $_____ per pay period
Total: ____% (minimum 1%, maximum varies by compensation level)

□ I elect to increase my contribution by 1% each year (auto-escalation)
□ I elect to receive employer matching (4% maximum)

INVESTMENT ALLOCATION
Select investment allocation for contributions:

□ Target Date Fund based on expected retirement year: 20___
□ Custom allocation (must total 100%):
   Large Cap Growth Fund: ____%
   Bond Index Fund: ____%
   International Equity Fund: ____%
   Small Cap Value Fund: ____%
   Money Market Fund: ____%

BENEFICIARY DESIGNATION
Primary Beneficiary: _______________________ Relationship: _________
Social Security Number: XXX-XX-_____ Percentage: ____%

Contingent Beneficiary: ____________________ Relationship: _________
Social Security Number: XXX-XX-_____ Percentage: ____%

ACKNOWLEDGMENTS
□ I have received and reviewed the Summary Plan Description
□ I understand my investment options and their associated risks
□ I understand that I can change my elections at any time

Participant Signature: _________________________ Date: __________',
    'PLAN001'
),
(
    'DOC_LOAN_APPLICATION_001',
    'Participant Loan Application Form',
    'Loan_Form', 
    'forms/loan-application-form.pdf',
    'EXTRACTED',
    'PARTICIPANT LOAN APPLICATION

PARTICIPANT INFORMATION
Name: _________________________________ Plan: TechCorp 401(k)
Employee ID: _______ SSN: XXX-XX-_____ Current Balance: $________

LOAN REQUEST DETAILS
Requested Loan Amount: $_________ (minimum $1,000)
Loan Purpose: 
□ Purchase of primary residence  □ Education expenses
□ Medical expenses  □ Prevention of eviction/foreclosure
□ General purpose (max $50,000 or 50% of vested balance)

REPAYMENT TERMS
Requested Loan Term: _____ years (maximum 5 years, 15 for home purchase)
Estimated Monthly Payment: $_____ (calculated by plan administrator)
Payroll Deduction Authorization: 
□ Yes, I authorize payroll deduction for loan repayment

REQUIRED DOCUMENTATION
For primary residence purchase:
□ Purchase agreement  □ HUD-1 settlement statement

For other purposes:
□ Supporting documentation attached

SPOUSAL CONSENT (if married)
I consent to this loan application and waive any rights to the loan amount.
Spouse Signature: _________________________ Date: __________
(Notarization required)

PARTICIPANT ACKNOWLEDGMENT
I understand that:
• This loan must be repaid within the specified term
• If I terminate employment, the loan becomes immediately due
• Failure to repay will result in a taxable distribution
• Interest charged will be the prime rate + 1%

Participant Signature: _________________________ Date: __________',
    'PLAN001'
),
(
    'DOC_QUARTERLY_STATEMENT_001',
    'Quarterly Account Statement - Q3 2024',
    'Account_Statement',
    'statements/quarterly-statement-q3-2024.pdf',
    'EXTRACTED',
    'QUARTERLY ACCOUNT STATEMENT
Third Quarter 2024 (July 1 - September 30, 2024)

ACCOUNT SUMMARY - Sarah Johnson (PART_001)
TechCorp 401(k) Plan - Account: ACC_001

ACCOUNT BALANCE
Beginning Balance (July 1, 2024): $118,500
Ending Balance (September 30, 2024): $125,000
Quarterly Change: +$6,500 (+5.48%)

CONTRIBUTION SUMMARY - Q3 2024
Employee Pre-Tax Contributions: $1,900
Employer Matching Contributions: $950
Total Contributions: $2,850

INVESTMENT PERFORMANCE - Q3 2024
Target Date 2060 Fund (50%): +6.2% return
Large Cap Growth Fund (30%): +7.1% return  
Bond Index Fund (20%): +1.8% return
Weighted Portfolio Return: +5.9%

CURRENT INVESTMENT ALLOCATION
Target Date 2060 Fund: $62,500 (50.0%)
Large Cap Growth Fund: $37,500 (30.0%)
Bond Index Fund: $25,000 (20.0%)

YEAR-TO-DATE SUMMARY
Total Contributions YTD: $8,550
Employee Contributions: $5,700
Employer Contributions: $2,850
Investment Gain/Loss YTD: +$12,450

PLAN LOAN INFORMATION
Current Loans: None
Available Loan Amount: $62,500 (50% of vested balance)

IMPORTANT NOTICES
• Your contribution rate is currently 8% - consider increasing to maximize employer match
• You are eligible for catch-up contributions beginning at age 50
• Review your beneficiary designations annually

For questions, contact TechCorp HR at hr@techcorp.com or 1-800-TECHCORP',
    'PLAN001'
);

-- 📊 COMPLIANCE AND REGULATORY DOCUMENTS  
-- ============================================================================

INSERT INTO DOCUMENT_REGISTRY (
    DOCUMENT_ID, DOCUMENT_NAME, DOCUMENT_TYPE, FILE_PATH, 
    PROCESSING_STATUS, EXTRACTED_TEXT, PLAN_ID
) VALUES 
(
    'DOC_AUDIT_REPORT_001',
    'Annual Plan Audit Report - 2023',
    'Audit_Report',
    'compliance/annual-audit-report-2023.pdf', 
    'EXTRACTED',
    'INDEPENDENT AUDITOR\'S REPORT
TECHCORP 401(k) RETIREMENT PLAN
Year Ended December 31, 2023

OPINION
We have audited the accompanying statements of net assets available for benefits of the TechCorp 401(k) Retirement Plan as of December 31, 2023 and 2022, and the related statement of changes in net assets available for benefits for the year ended December 31, 2023.

In our opinion, the financial statements present fairly, in all material respects, the net assets available for benefits of the Plan as of December 31, 2023 and 2022, and the changes in net assets available for benefits for the year ended December 31, 2023, in conformity with accounting principles generally accepted in the United States of America.

PLAN FINANCIAL HIGHLIGHTS
Total Plan Assets: $8,750,000
Total Participants: 185
Average Account Balance: $47,297

PARTICIPANT DATA
Active Participants: 165
Terminated Participants with Balances: 20
Participants Receiving Distributions: 0

CONTRIBUTIONS - 2023
Employee Elective Deferrals: $1,850,000
Employer Matching Contributions: $740,000
Total Contributions: $2,590,000

DISTRIBUTIONS - 2023
Benefits Paid to Participants: $325,000
Administrative Expenses: $42,000

INVESTMENT PERFORMANCE
Plan assets experienced a 12.8% return in 2023, outperforming the benchmark by 1.2%.

COMPLIANCE FINDINGS
• No material findings identified
• Plan operates in accordance with ERISA requirements
• All required discrimination testing passed
• Timely deposit of participant contributions confirmed

RECOMMENDATIONS
• Consider adding additional investment education resources
• Review investment menu annually for performance and fees
• Maintain current excellent recordkeeping practices

Certified Public Accountants
March 15, 2024',
    'PLAN001'
),
(
    'DOC_DOL_NOTICE_001',
    'Department of Labor Fee Disclosure Notice',
    'Regulatory_Notice',
    'compliance/dol-fee-disclosure-2024.pdf',
    'EXTRACTED',
    'ANNUAL PLAN FEE DISCLOSURE NOTICE
Required Under ERISA Section 404(a)(5)

TO: All TechCorp 401(k) Plan Participants
FROM: Plan Administrator
DATE: January 1, 2024

GENERAL PLAN INFORMATION
This notice describes the fees and expenses that may be charged to your individual account and information to help you understand the importance these fees and expenses play in your retirement planning.

PLAN ADMINISTRATION FEES
The following fees are charged to the plan and allocated among all participant accounts:

Recordkeeping Services: $45 per participant per year
Administrative Services: $25 per participant per year
Audit Fees: $15 per participant per year
Total Annual Administrative Fees: $85 per participant

INDIVIDUAL SERVICE FEES
The following fees may be charged to your individual account if you use these services:

Participant Loan Origination: $75 per loan
Participant Loan Maintenance: $25 per year per loan
Hardship Withdrawal Processing: $50 per request
Qualified Domestic Relations Order: $350 per order

INVESTMENT-RELATED FEES
Each investment option has its own fees and expenses. These are expressed as expense ratios:

Target Date Funds: 0.65% annually
Index Funds: 0.25% annually  
Actively Managed Funds: 0.75-1.25% annually

CUMULATIVE EFFECT EXAMPLE
Assume a participant has $25,000 in their account and contributes $2,000 annually with a 7% annual return:

With current fees (0.85% total): $192,000 after 20 years
With 0.5% higher fees (1.35% total): $177,000 after 20 years
Difference: $15,000 over 20 years

ADDITIONAL INFORMATION
• Fee information is also available on our participant website
• You may obtain additional fee information by contacting the Plan Administrator
• This notice will be provided annually and when material changes occur

For questions about these fees, contact hr@techcorp.com or call 1-800-TECHCORP.',
    'PLAN001'
),
(
    'DOC_INVESTMENT_POLICY_001',
    'Investment Policy Statement - TechCorp 401(k) Plan',
    'Investment_Policy',
    'policies/investment-policy-statement-2024.pdf',
    'EXTRACTED',
    'INVESTMENT POLICY STATEMENT
TECHCORP 401(k) RETIREMENT PLAN
Adopted: January 1, 2024

PURPOSE
This Investment Policy Statement (IPS) establishes the investment objectives, policies, and procedures for the TechCorp 401(k) Plan. This document serves to:
• Define roles and responsibilities of all parties involved
• Establish investment objectives and guidelines
• Provide criteria for selecting and monitoring investments

INVESTMENT COMMITTEE RESPONSIBILITIES
The Investment Committee shall:
• Monitor investment performance on a quarterly basis
• Review and approve all investment option changes
• Ensure compliance with ERISA fiduciary requirements
• Document all investment-related decisions

INVESTMENT OBJECTIVES
Primary Objectives:
• Provide participants with a diversified menu of investment options
• Include options appropriate for participants with varying risk tolerances
• Minimize investment-related expenses while maintaining quality
• Offer investment education and guidance resources

INVESTMENT SELECTION CRITERIA
Mutual Funds and Collective Investment Trusts must meet:
• Minimum 3-year track record
• Assets under management exceeding $100 million
• Expense ratios below 75th percentile of peer group
• Consistent investment style and philosophy

Target Date Funds:
• Must cover full range of participant retirement dates
• Utilize age-appropriate asset allocation glide path
• Annual expense ratio not to exceed 0.75%

PROHIBITED INVESTMENTS
The following investments are prohibited:
• Individual stocks or bonds
• Commodities or precious metals
• Real estate investment trusts (REITs) as standalone options
• Alternative investments (hedge funds, private equity)
• Any investment not registered under the Investment Company Act

PERFORMANCE MONITORING
Investment performance will be evaluated quarterly against:
• Appropriate market benchmarks
• Peer group comparisons  
• Long-term objectives (3 and 5-year periods)

Performance review triggers for potential replacement:
• Underperformance versus benchmark for 3 consecutive years
• Significant style drift from stated investment objective
• Material increase in expenses without corresponding value
• Loss of key investment personnel

INVESTMENT EDUCATION
The Plan will provide participants with:
• Annual investment education meetings
• Online investment guidance tools
• Target date fund default investment option
• Access to professional investment advice (optional fee-based service)

POLICY REVIEW
This IPS will be reviewed annually and updated as necessary to reflect:
• Changes in Plan demographics
• Market conditions
• Regulatory requirements
• Investment industry best practices

Investment Committee Chair: _____________________ Date: _________',
    'PLAN001'
);

-- 💰 INVESTMENT AND FUND DOCUMENTS
-- ============================================================================

INSERT INTO DOCUMENT_REGISTRY (
    DOCUMENT_ID, DOCUMENT_NAME, DOCUMENT_TYPE, FILE_PATH, 
    PROCESSING_STATUS, EXTRACTED_TEXT, PLAN_ID
) VALUES 
(
    'DOC_FUND_FACTSHEET_001',
    'Target Date 2060 Fund Fact Sheet',
    'Fund_Factsheet', 
    'investments/target-date-2060-factsheet.pdf',
    'EXTRACTED',
    'TARGET DATE 2060 FUND FACT SHEET
As of September 30, 2024

FUND OVERVIEW
The Target Date 2060 Fund is designed for investors who plan to retire around the year 2060. The fund automatically adjusts its asset allocation as it approaches the target date, becoming more conservative over time.

INVESTMENT OBJECTIVE
Seeks to provide capital appreciation and income consistent with a target retirement date of approximately 2060.

CURRENT ASSET ALLOCATION
Domestic Equity: 54%
International Equity: 36% 
Fixed Income: 8%
Short-term Investments: 2%

PERFORMANCE (as of 9/30/2024)
Year-to-Date: +11.0%
1 Year: +15.2%
3 Year (annualized): +8.7%
5 Year (annualized): +9.3%
Since Inception (annualized): +10.1%

BENCHMARK COMPARISON
The fund has outperformed its benchmark by an average of 0.8% annually over the past 5 years.

FUND DETAILS
Inception Date: January 1, 2015
Total Net Assets: $2.8 billion
Number of Holdings: 8 underlying funds
Expense Ratio: 0.65%
Minimum Investment: No minimum

TOP HOLDINGS (underlying funds)
Large-Cap Growth Index Fund: 28%
International Developed Markets Fund: 22%
Large-Cap Value Index Fund: 20%
Small-Cap Index Fund: 8%
Emerging Markets Fund: 8%
Intermediate-Term Bond Fund: 6%
Real Estate Index Fund: 4%
Short-Term Investment Fund: 4%

GLIDE PATH
The fund follows a strategic glide path that reduces equity exposure as participants approach retirement:
• Age 25-40: 90% equity / 10% fixed income
• Age 41-50: 80% equity / 20% fixed income
• Age 51-60: 70% equity / 30% fixed income
• Age 61-65: 50% equity / 50% fixed income
• Post-retirement: 30% equity / 70% fixed income

RISK CONSIDERATIONS
• Target date funds are subject to the risks of their underlying investments
• Principal value is not guaranteed at any time, including the target date
• Asset allocation becomes more conservative over time but may not be appropriate for all investors

This fund is appropriate for investors who:
• Plan to retire around 2060
• Prefer a hands-off investment approach
• Want professional asset allocation management
• Seek diversification across multiple asset classes',
    'PLAN001'
),
(
    'DOC_QUARTERLY_INVESTMENT_REVIEW_001',
    'Quarterly Investment Committee Review - Q3 2024',
    'Investment_Review',
    'investments/investment-committee-review-q3-2024.pdf',
    'EXTRACTED',
    'INVESTMENT COMMITTEE QUARTERLY REVIEW
Third Quarter 2024

MEETING DATE: October 15, 2024
ATTENDEES: Investment Committee Members, Plan Consultant, HR Director

EXECUTIVE SUMMARY
The TechCorp 401(k) Plan investment lineup performed well during Q3 2024, with all funds meeting or exceeding benchmark performance. Total plan assets grew to $8.95 million, representing a 6.2% increase from the previous quarter.

PLAN STATISTICS - Q3 2024
Total Participants: 189 (+4 from Q2)
Total Plan Assets: $8,950,000 (+6.2% from Q2)
Average Account Balance: $47,354
Participation Rate: 91% of eligible employees

INVESTMENT PERFORMANCE REVIEW

Target Date Funds:
• Target Date 2060: +6.2% (vs. benchmark +5.8%)
• Target Date 2050: +5.8% (vs. benchmark +5.5%)
• Target Date 2040: +5.1% (vs. benchmark +4.9%)
• All target date funds outperformed benchmarks

Individual Fund Options:
• Large Cap Growth Fund: +7.1% (vs. S&P 500 Growth +6.8%)
• Bond Index Fund: +1.8% (vs. Bloomberg Aggregate +1.6%)
• International Equity Fund: +5.9% (vs. MSCI EAFE +5.2%)
• Small Cap Value Fund: +8.2% (vs. Russell 2000 Value +7.5%)
• Money Market Fund: +1.3% (stable performance)

PARTICIPANT BEHAVIOR ANALYSIS
Asset Allocation Trends:
• 67% of participants utilize target date funds
• 23% use custom allocations
• 10% use single fund options

Contribution Patterns:
• Average contribution rate: 8.2% of salary
• 94% of participants receive full employer match
• Catch-up contribution utilization: 78% of eligible participants

FUND MONITORING REPORT
All funds continue to meet investment policy criteria:
✓ Performance within acceptable ranges
✓ Expense ratios below peer group medians
✓ No significant style drift identified
✓ All fund managers remain stable

RECOMMENDATIONS
1. Continue monitoring Small Cap Value Fund for potential style drift
2. Consider adding ESG investment options based on participant survey feedback
3. Increase investment education focus on international diversification
4. Review target date fund glide path for appropriateness

ACTION ITEMS
• HR to survey participants on ESG investment interest
• Consultant to provide ESG fund options for next meeting
• Schedule annual investment education sessions for Q4
• Review and update Investment Policy Statement

NEXT MEETING
Date: January 15, 2025
Focus: Year-end performance review and 2025 planning

Committee Chair Signature: _________________________ Date: _________',
    'PLAN001'
);

-- 🔧 PROCESS ALL NEW DOCUMENTS
-- ============================================================================

-- Create chunks for all new documents
CALL CHUNK_PLAN_DOCUMENT('DOC_SPD_HEALTHPLUS_001', 'HealthPlus 403(b) Plan Summary Plan Description');
CALL CHUNK_PLAN_DOCUMENT('DOC_SPD_EDUCARE_001', 'EduCare School District Pension Plan Summary');
CALL CHUNK_PLAN_DOCUMENT('DOC_FORM_ENROLLMENT_001', 'Retirement Plan Enrollment Form - TechCorp');
CALL CHUNK_PLAN_DOCUMENT('DOC_LOAN_APPLICATION_001', 'Participant Loan Application Form');
CALL CHUNK_PLAN_DOCUMENT('DOC_QUARTERLY_STATEMENT_001', 'Quarterly Account Statement - Q3 2024');
CALL CHUNK_PLAN_DOCUMENT('DOC_AUDIT_REPORT_001', 'Annual Plan Audit Report - 2023');
CALL CHUNK_PLAN_DOCUMENT('DOC_DOL_NOTICE_001', 'Department of Labor Fee Disclosure Notice');
CALL CHUNK_PLAN_DOCUMENT('DOC_INVESTMENT_POLICY_001', 'Investment Policy Statement - TechCorp 401(k) Plan');
CALL CHUNK_PLAN_DOCUMENT('DOC_FUND_FACTSHEET_001', 'Target Date 2060 Fund Fact Sheet');
CALL CHUNK_PLAN_DOCUMENT('DOC_QUARTERLY_INVESTMENT_REVIEW_001', 'Quarterly Investment Committee Review - Q3 2024');

-- ✅ VERIFICATION
-- ============================================================================

SELECT 'Additional Documents Loaded' AS status, COUNT(*) AS new_documents 
FROM DOCUMENT_REGISTRY 
WHERE DOCUMENT_ID LIKE 'DOC_SPD_HEALTHPLUS%' 
   OR DOCUMENT_ID LIKE 'DOC_SPD_EDUCARE%'
   OR DOCUMENT_ID LIKE 'DOC_FORM_%'
   OR DOCUMENT_ID LIKE 'DOC_LOAN_%'
   OR DOCUMENT_ID LIKE 'DOC_QUARTERLY_%'
   OR DOCUMENT_ID LIKE 'DOC_AUDIT_%'
   OR DOCUMENT_ID LIKE 'DOC_DOL_%'
   OR DOCUMENT_ID LIKE 'DOC_INVESTMENT_%'
   OR DOCUMENT_ID LIKE 'DOC_FUND_%';

-- Show document type distribution
SELECT 
    DOCUMENT_TYPE,
    COUNT(*) AS document_count,
    STRING_AGG(DOCUMENT_NAME, '; ') AS sample_documents
FROM DOCUMENT_REGISTRY
GROUP BY DOCUMENT_TYPE
ORDER BY document_count DESC;

-- Test document search capabilities
SELECT 'Document Search Test' AS test_name,
       'Searching for vesting information across all documents' AS description;

SELECT CORTEX.SEARCH(
    'RETIREMENT_DOC_SEARCH',
    'vesting schedule requirements eligibility',
    {'limit': 3}
) AS search_results;

-- 🎉 SUCCESS MESSAGE
-- ============================================================================

SELECT '🎉 Additional Sample Documents Loaded!' as status,
       '10 new documents added covering SPDs, forms, compliance, and investment materials' as message,
       'Ready for comprehensive document AI testing and demos' as next_steps; 