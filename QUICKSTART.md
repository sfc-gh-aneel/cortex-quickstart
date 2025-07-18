# 🚀 5-Minute Quickstart Guide

Get your retirement plan AI system running in 5 minutes with realistic sample data!

## ✅ Prerequisites Checklist

- [ ] **Snowflake Trial Account** → [Get free trial](https://trial.snowflake.com)
- [ ] **ACCOUNTADMIN role** access
- [ ] **Snowflake Worksheet** open and ready

## 🏗️ Step 1: Initial Setup (2 minutes)

### Copy Configuration Template
```sql
-- 1. Copy and customize your configuration
-- Edit these values with your Snowflake details:

SET DATABASE_NAME = 'RETIREMENT_PLAN_AI';
SET SCHEMA_NAME = 'EXPERIMENTS';
SET WAREHOUSE_NAME = 'RETIREMENT_AI_WH';
SET WAREHOUSE_SIZE = 'MEDIUM';
```

### Run Core Setup
```sql
-- 2. Execute the main setup script
@setup/initial-setup.sql

-- 3. Load realistic sample data
@setup/load-sample-data.sql
```

**🎉 You now have**: 22 sample participants, 6 investment funds, 5 plan documents, and full AI capabilities!

## 🧪 Step 2: Test Each AI Feature (3 minutes)

### 📄 Text Extraction & Document AI
```sql
-- Test document processing
SELECT * FROM DOCUMENTS.PROCESSING_DASHBOARD;

-- Search your plan documents
SELECT CORTEX.SEARCH(
    'RETIREMENT_DOC_SEARCH',
    'What is the vesting schedule for employer matching?'
) AS search_results;
```

### 🔢 Vector Embeddings & Similarity
```sql
-- Test participant similarity
SELECT * FROM TABLE(FIND_SIMILAR_PARTICIPANTS('PART_001', 0.7, 5));

-- Test investment recommendations
SELECT * FROM TABLE(RECOMMEND_INVESTMENTS(
    'Conservative investor approaching retirement, seeking stable income', 5
));
```

### 💬 Natural Language Queries
```sql
-- Ask questions about your data in plain English
SELECT ASK_ABOUT_RETIREMENT_DATA(
    'How many participants are over 50 and what is their average account balance?'
) AS insights;

SELECT ASK_ABOUT_RETIREMENT_DATA(
    'Which investment funds have the best performance this year?'
) AS fund_analysis;
```

### 🔗 Unified Intelligence
```sql
-- Combine all data sources in one query
SELECT UNIFIED_RETIREMENT_QUERY(
    'Find high-balance participants approaching retirement and relevant guidance from our plan documents'
) AS comprehensive_analysis;
```

## 🎯 Step 3: Try Demo Scenarios

### Executive Dashboard Demo
```sql
-- CEO-level insights
SELECT ASK_ABOUT_RETIREMENT_DATA(
    'Give me an executive summary: total plan assets, participation rates, top performers, and risk areas'
) AS executive_summary;
```

### Compliance Review Demo
```sql
-- Compliance officer analysis
SELECT UNIFIED_RETIREMENT_QUERY(
    'Review participants over age 70 for RMD requirements and check our compliance documentation'
) AS compliance_review;
```

### Investment Committee Demo
```sql
-- Investment committee briefing
SELECT ASK_ABOUT_RETIREMENT_DATA(
    'Analyze fund performance, participant allocation trends, and identify any concentration risks'
) AS investment_briefing;
```

## 📊 What You Now Have

| ✅ Feature | 🎪 What You Can Demo | 💡 Business Value |
|------------|---------------------|-------------------|
| **Document AI** | Extract text from PDFs, search plan documents, analyze compliance reports | Turn documents into searchable knowledge |
| **Vector Search** | Semantic search across all content, find similar participants | Discover insights that exact matches miss |
| **Natural Language** | Ask questions in English, get SQL-powered answers | Democratize data access for all users |
| **Unified Interface** | Single API for documents + data, executive dashboards | Enterprise-scale AI with comprehensive coverage |

## 🎉 Success Verification

Run this to verify everything is working:

```sql
-- System health check
SELECT * FROM UNIFIED_SYSTEM_HEALTH;

-- Data summary
SELECT 
    'Total Participants' AS metric, 
    COUNT(*) AS value,
    'Ready for AI analysis' AS status
FROM ANALYTICS.PARTICIPANT_OVERVIEW
UNION ALL
SELECT 
    'Documents Processed' AS metric,
    COUNT(*) AS value,
    'Searchable via AI' AS status
FROM DOCUMENTS.DOCUMENT_REGISTRY WHERE PROCESSING_STATUS = 'CHUNKED'
UNION ALL
SELECT 
    'Vector Embeddings' AS metric,
    COUNT(*) AS value,
    'Powering semantic search' AS status
FROM DOCUMENTS.DOCUMENT_CHUNKS WHERE embedding IS NOT NULL;
```

**Expected Results**: 22 participants, 5+ documents, 15+ embeddings

## 🔥 Next Steps

1. **Demo to Stakeholders**: Use the executive scenarios above
2. **Add Your Data**: Upload real plan documents to the stages
3. **Customize Functions**: Modify queries for your specific needs
4. **Scale Up**: Move to larger warehouse for production workloads

## 🆘 Troubleshooting

**Problem**: Setup script fails
**Solution**: Ensure you have ACCOUNTADMIN role and warehouse is running

**Problem**: Document search returns no results  
**Solution**: Run `CALL PROCESS_ALL_PLAN_DOCUMENTS()` to ensure processing completed

**Problem**: Natural language queries give generic responses
**Solution**: The AI needs a few moments to learn your data - try again or restart warehouse

## 💡 Pro Tips for Demos

1. **Start with Document Search**: "Show me what our SPD says about vesting"
2. **Move to Data Analysis**: "Who are our highest savers and what can we learn?"
3. **End with Unified Queries**: "Combine participant data with plan documents for complete insights"
4. **Emphasize Speed**: "These complex analyses used to take hours - now they're instant"

---

**🏆 You're now ready to revolutionize retirement plan administration with AI!**

Each template directory has detailed README files for deeper customization and advanced features. 