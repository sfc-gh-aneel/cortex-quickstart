# 💬 Structured Data Processing for Retirement Plans

Ask questions about your retirement plan data in plain English and get instant SQL-powered insights with Snowflake Cortex!

## 🎯 What You'll Build

Transform complex retirement plan queries into natural conversations:
- **👥 Participant Analytics**: "How many participants are eligible but not enrolled?"
- **💰 Financial Insights**: "What's the average account balance by age group?"
- **📊 Fund Performance**: "Which funds have the highest returns this year?"
- **🎯 Compliance Monitoring**: "Show me participants who haven't updated beneficiaries"
- **📈 Trend Analysis**: "How have contribution rates changed over time?"

## 🚀 Quick Demo (90 Seconds!)

### 1. Ask About Participants

```sql
-- Natural language question about enrollment
USE DATABASE RETIREMENT_PLAN_AI;
USE SCHEMA CORTEX_FUNCTIONS;

SELECT ASK_ABOUT_RETIREMENT_DATA(
    'How many participants are over 50 years old and what is their average account balance?'
) AS insights;
```

### 2. Investment Analysis

```sql
-- Get fund recommendations
SELECT ASK_ABOUT_RETIREMENT_DATA(
    'What are the top 3 performing funds this year and how many participants are invested in them?'
) AS fund_analysis;
```

### 3. Compliance Insights

```sql
-- Check plan compliance metrics
SELECT ASK_ABOUT_RETIREMENT_DATA(
    'Show me participants with account balances over $100,000 who are eligible for catch-up contributions'
) AS compliance_check;
```

## 📁 What's Included

```
structured-data-processing/
├── 📄 README.md                    # This guide
├── 🔧 setup.sql                    # Natural language query setup
├── 💬 conversational-functions.sql # Chat-like interfaces
├── 📊 analytics-templates.sql      # Pre-built analysis queries
├── 🎯 semantic-model.sql           # Data model for natural language
├── 📈 dashboard-queries.sql        # Executive dashboard queries
├── 🔍 query-optimization.sql       # Performance tuning for large datasets
└── 📝 sample-conversations.md      # Example Q&A sessions
```

## 🏗️ Setup Instructions

### Step 1: Deploy Natural Language Interface

```sql
-- Execute this in your Snowflake worksheet
-- Creates conversational AI functions for retirement data
@structured-data-processing/setup.sql
```

### Step 2: Test Your First Questions

```sql
-- Try basic participant queries
SELECT * FROM TABLE(NATURAL_LANGUAGE_QUERY('How many active participants do we have?'));

-- Test investment analysis
SELECT * FROM TABLE(NATURAL_LANGUAGE_QUERY('What is the average expense ratio of our funds?'));
```

### Step 3: Build Custom Conversations

```sql
-- Start a multi-turn conversation
CALL START_CONVERSATION_SESSION('retirement_analysis_2024');

-- Ask follow-up questions
SELECT CONTINUE_CONVERSATION(
    'retirement_analysis_2024',
    'Now show me the same data but broken down by plan'
) AS follow_up_analysis;
```

## 🎪 Demo Scenarios

### Scenario 1: Executive Dashboard Questions
**Use Case**: C-suite wants quick insights without learning SQL

```sql
-- CEO asks about overall plan health
SELECT ASK_ABOUT_RETIREMENT_DATA(
    'Give me a summary of our retirement plan performance: total assets, participant count, average balance, and top concerns'
) AS executive_summary;

-- CFO wants cost analysis
SELECT ASK_ABOUT_RETIREMENT_DATA(
    'What are our total plan expenses this year and how do our fund fees compare to industry benchmarks?'
) AS cost_analysis;

-- HR Director checks engagement
SELECT ASK_ABOUT_RETIREMENT_DATA(
    'What percentage of eligible employees are participating and what is the average contribution rate?'
) AS engagement_metrics;
```

### Scenario 2: Plan Administrator Deep Dive
**Use Case**: Detailed operational analysis for plan management

```sql
-- Identify at-risk participants
SELECT ASK_ABOUT_RETIREMENT_DATA(
    'Find participants over 55 with less than $50,000 saved who are contributing less than 5%'
) AS at_risk_analysis;

-- Investment allocation analysis
SELECT ASK_ABOUT_RETIREMENT_DATA(
    'Show me the distribution of investments across risk categories and identify any concentration risks'
) AS allocation_analysis;

-- Compliance monitoring
SELECT ASK_ABOUT_RETIREMENT_DATA(
    'List participants who have made no changes to their allocations in over 2 years'
) AS stale_allocations;
```

### Scenario 3: Investment Committee Review
**Use Case**: Quarterly investment performance review

```sql
-- Fund performance evaluation
SELECT ASK_ABOUT_RETIREMENT_DATA(
    'Compare the performance of all funds against their benchmarks and identify underperformers'
) AS performance_review;

-- Asset flow analysis
SELECT ASK_ABOUT_RETIREMENT_DATA(
    'Which funds have seen the largest inflows and outflows this quarter?'
) AS flow_analysis;

-- Fee analysis
SELECT ASK_ABOUT_RETIREMENT_DATA(
    'Calculate the total fees paid by participants and identify opportunities for cost savings'
) AS fee_analysis;
```

### Scenario 4: Multi-Turn Conversation
**Use Case**: Deep-dive analysis with follow-up questions

```sql
-- Start with a broad question
SELECT START_ANALYSIS_CONVERSATION(
    'What are the characteristics of our highest-performing participants?'
) AS initial_analysis;

-- Follow up with more specific questions
SELECT CONTINUE_CONVERSATION(
    'Now show me how their investment choices differ from average participants'
) AS investment_comparison;

SELECT CONTINUE_CONVERSATION(
    'What contribution patterns led to their success?'
) AS contribution_patterns;

SELECT CONTINUE_CONVERSATION(
    'Create action items to help other participants achieve similar results'
) AS recommendations;
```

## 🎯 Customization Guide

### 1. Add Domain-Specific Terminology

```sql
-- Teach the AI retirement plan terminology
CREATE OR REPLACE FUNCTION ENHANCE_RETIREMENT_CONTEXT(user_question TEXT)
RETURNS TEXT
LANGUAGE SQL
AS
$$
SELECT 
    'Context: This is a question about retirement plan data. ' ||
    'Key terms: 401k, 403b, pension, vesting, matching, contribution, ' ||
    'distribution, rollover, beneficiary, ERISA, Form 5500. ' ||
    'User question: ' || user_question
$$;
```

### 2. Custom Business Rules

```sql
-- Add company-specific business logic
CREATE OR REPLACE FUNCTION APPLY_BUSINESS_RULES(query_result TEXT)
RETURNS TEXT
LANGUAGE SQL
AS
$$
SELECT query_result || 
    CASE 
        WHEN query_result LIKE '%high account balance%' THEN 
            ' Note: Participants with balances over $500,000 may need additional fiduciary guidance.'
        WHEN query_result LIKE '%low participation%' THEN
            ' Recommendation: Consider auto-enrollment or enhanced education programs.'
        WHEN query_result LIKE '%fund performance%' THEN
            ' Context: Performance should be evaluated over 3-5 year periods minimum.'
        ELSE ''
    END
$$;
```

### 3. Multi-Plan Support

```sql
-- Handle multiple retirement plans
CREATE OR REPLACE FUNCTION ASK_ABOUT_PLAN_DATA(
    question TEXT,
    plan_id VARCHAR DEFAULT NULL
)
RETURNS TEXT
LANGUAGE SQL
AS
$$
WITH plan_context AS (
    SELECT CASE 
        WHEN plan_id IS NOT NULL THEN 
            'Focus on data for plan: ' || (SELECT PLAN_NAME FROM PARTICIPANT_DATA.RETIREMENT_PLANS WHERE PLAN_ID = plan_id) || '. '
        ELSE 
            'Analyze data across all retirement plans. '
    END AS context
)
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'llama3.1-8b',
    context || 'Question: ' || question || 
    ' Use the RETIREMENT_PLAN_AI database to answer this question about retirement plan data.'
) FROM plan_context
$$;
```

## 🔥 Advanced Features

### 1. Intelligent Query Routing

```sql
-- Route questions to the most appropriate analysis function
CREATE OR REPLACE FUNCTION SMART_RETIREMENT_QUERY(user_question TEXT)
RETURNS VARIANT
LANGUAGE SQL
AS
$$
WITH question_analysis AS (
    SELECT SNOWFLAKE.CORTEX.COMPLETE(
        'llama3.1-8b',
        'Analyze this retirement plan question and categorize it: ' || user_question ||
        '. Categories: PARTICIPANT_DEMOGRAPHICS, ACCOUNT_BALANCES, INVESTMENT_PERFORMANCE, ' ||
        'CONTRIBUTION_ANALYSIS, COMPLIANCE_CHECK, FUND_ANALYSIS, GENERAL_SUMMARY. ' ||
        'Respond with just the category.'
    ) AS category
)
SELECT CASE category
    WHEN 'PARTICIPANT_DEMOGRAPHICS' THEN ANALYZE_PARTICIPANT_DEMOGRAPHICS(user_question)
    WHEN 'ACCOUNT_BALANCES' THEN ANALYZE_ACCOUNT_BALANCES(user_question)
    WHEN 'INVESTMENT_PERFORMANCE' THEN ANALYZE_INVESTMENT_PERFORMANCE(user_question)
    WHEN 'CONTRIBUTION_ANALYSIS' THEN ANALYZE_CONTRIBUTIONS(user_question)
    WHEN 'COMPLIANCE_CHECK' THEN RUN_COMPLIANCE_CHECK(user_question)
    WHEN 'FUND_ANALYSIS' THEN ANALYZE_FUND_PERFORMANCE(user_question)
    ELSE GENERAL_RETIREMENT_ANALYSIS(user_question)
END AS analysis_result
FROM question_analysis
$$;
```

### 2. Conversational Memory

```sql
-- Remember context across questions
CREATE TABLE IF NOT EXISTS CONVERSATION_HISTORY (
    SESSION_ID VARCHAR(50),
    TURN_NUMBER INTEGER,
    USER_QUESTION TEXT,
    AI_RESPONSE TEXT,
    CONTEXT_DATA VARIANT,
    TIMESTAMP TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE FUNCTION CONVERSATIONAL_QUERY(
    session_id VARCHAR,
    user_question TEXT
)
RETURNS TEXT
LANGUAGE SQL
AS
$$
WITH conversation_context AS (
    SELECT STRING_AGG(
        'Q: ' || USER_QUESTION || ' A: ' || AI_RESPONSE, 
        '\n'
    ) AS history
    FROM CONVERSATION_HISTORY 
    WHERE SESSION_ID = session_id
    ORDER BY TURN_NUMBER
)
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'llama3.1-8b',
    'Previous conversation: ' || COALESCE(history, 'None') || 
    '\nCurrent question: ' || user_question ||
    '\nAnswer the current question using context from the retirement plan database.'
) FROM conversation_context
$$;
```

### 3. Automated Insights Generation

```sql
-- Generate proactive insights
CREATE OR REPLACE PROCEDURE GENERATE_DAILY_INSIGHTS()
RETURNS TABLE (
    insight_category VARCHAR,
    insight_text TEXT,
    urgency_level VARCHAR,
    recommended_action TEXT
)
LANGUAGE SQL
AS
$$
-- Analyze trends and generate automated insights
WITH participation_trends AS (
    SELECT 
        'Participation Rate' AS category,
        'Participation rate ' || 
        CASE WHEN current_rate > previous_rate THEN 'increased' ELSE 'decreased' END ||
        ' by ' || ABS(current_rate - previous_rate) || '% this month' AS insight,
        CASE WHEN ABS(current_rate - previous_rate) > 5 THEN 'High' ELSE 'Medium' END AS urgency
    FROM (
        SELECT 
            COUNT(CASE WHEN ENROLLMENT_STATUS = 'Active' THEN 1 END) * 100.0 / COUNT(*) AS current_rate,
            75.0 AS previous_rate  -- Would come from historical analysis
        FROM ANALYTICS.PARTICIPANT_OVERVIEW
    )
),
balance_alerts AS (
    SELECT 
        'Account Balances' AS category,
        COUNT(*) || ' participants have balances below $10,000 and may need additional support' AS insight,
        'High' AS urgency
    FROM ANALYTICS.PARTICIPANT_OVERVIEW
    WHERE CURRENT_BALANCE < 10000 AND AGE > 40
)
-- Combine all insights
SELECT category, insight, urgency, 'Review and take action' AS action FROM participation_trends
UNION ALL
SELECT category, insight, urgency, 'Outreach campaign recommended' AS action FROM balance_alerts
$$;
```

## 📊 Success Metrics

Track the effectiveness of your natural language interface:

```sql
-- Query success analytics
WITH query_metrics AS (
    SELECT 
        DATE_TRUNC('day', TIMESTAMP) AS query_date,
        COUNT(*) AS total_queries,
        COUNT(CASE WHEN AI_RESPONSE NOT LIKE '%error%' AND AI_RESPONSE NOT LIKE '%unable%' THEN 1 END) AS successful_queries,
        AVG(LENGTH(AI_RESPONSE)) AS avg_response_length,
        COUNT(DISTINCT SESSION_ID) AS unique_sessions
    FROM CONVERSATION_HISTORY
    WHERE TIMESTAMP >= CURRENT_DATE() - 30
    GROUP BY query_date
)
SELECT 
    query_date,
    total_queries,
    successful_queries,
    ROUND(successful_queries * 100.0 / total_queries, 2) AS success_rate_pct,
    avg_response_length,
    unique_sessions
FROM query_metrics
ORDER BY query_date DESC;

-- Most popular question types
SELECT 
    CASE 
        WHEN USER_QUESTION LIKE '%how many%' THEN 'Count Queries'
        WHEN USER_QUESTION LIKE '%average%' OR USER_QUESTION LIKE '%mean%' THEN 'Average Calculations'
        WHEN USER_QUESTION LIKE '%performance%' OR USER_QUESTION LIKE '%return%' THEN 'Performance Analysis'
        WHEN USER_QUESTION LIKE '%fund%' OR USER_QUESTION LIKE '%investment%' THEN 'Investment Queries'
        WHEN USER_QUESTION LIKE '%participant%' THEN 'Participant Analysis'
        ELSE 'Other'
    END AS question_type,
    COUNT(*) AS frequency
FROM CONVERSATION_HISTORY
WHERE TIMESTAMP >= CURRENT_DATE() - 7
GROUP BY question_type
ORDER BY frequency DESC;
```

## 🚨 Troubleshooting

### Common Issues

**Problem**: AI gives generic responses instead of specific data
**Solution**: 
```sql
-- Improve context with specific schema information
CREATE OR REPLACE FUNCTION ENHANCED_RETIREMENT_QUERY(question TEXT)
RETURNS TEXT
LANGUAGE SQL
AS
$$
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'llama3.1-8b',
    'You are a retirement plan data analyst. Available tables: ' ||
    'PARTICIPANTS (demographics, employment), ACCOUNT_BALANCES (financial data), ' ||
    'INVESTMENT_FUNDS (fund information), RETIREMENT_PLANS (plan details). ' ||
    'Question: ' || question || 
    ' Provide specific analysis with numbers from the database.'
)
$$;
```

**Problem**: Slow response times for complex queries
**Solution**: 
```sql
-- Pre-aggregate common metrics
CREATE MATERIALIZED VIEW RETIREMENT_METRICS_SUMMARY AS
SELECT 
    COUNT(*) AS total_participants,
    AVG(CURRENT_BALANCE) AS avg_balance,
    SUM(CURRENT_BALANCE) AS total_assets,
    COUNT(CASE WHEN ENROLLMENT_STATUS = 'Active' THEN 1 END) AS active_participants
FROM ANALYTICS.PARTICIPANT_OVERVIEW;

-- Use summary for faster responses
CREATE OR REPLACE FUNCTION QUICK_SUMMARY_QUERY(question TEXT)
RETURNS TEXT
LANGUAGE SQL
AS
$$
SELECT 'Based on current data: ' || total_participants || ' total participants, ' ||
       'average balance $' || ROUND(avg_balance, 0) || ', ' ||
       active_participants || ' actively contributing.'
FROM RETIREMENT_METRICS_SUMMARY
$$;
```

## 🎉 Next Steps

1. **Add Vector Search**: Combine with document insights → `../vector-search-retrieval/`
2. **Build Orchestration**: Unified queries across all data → `../orchestration/`
3. **Deploy MCP Integration**: Advanced AI workflows → `../mcp-server-integration/`

---

**🏆 Pro Tip**: Start with simple counting and averaging questions to build confidence, then gradually introduce more complex analytical queries. The "wow factor" comes when executives realize they can get answers in seconds that used to take hours of SQL work! 