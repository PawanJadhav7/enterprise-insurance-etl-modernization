# System Architecture

## Architecture Overview

This project uses a hybrid enterprise ETL and cloud lakehouse architecture designed for a Manulife / John Hancock–style insurance environment.

The architecture combines Informatica IICS / PowerCenter, Azure cloud services, Databricks, Delta Lake, SQL-based data warehousing, Salesforce integration, data governance, and Power BI reporting.

## High-Level Architecture

```text
Salesforce CRM
Policy Administration System
Claims Management System
Billing Platform
Annuity System
Long-Term Care System
MuleSoft APIs
Flat Files / SFTP / Mainframe Extracts
        |
        | Batch, API, JDBC, CDC, File Extracts
        |
Informatica IICS / PowerCenter
        |
        | Data validation, transformation, SCD logic, workflow orchestration
        |
Azure Data Lake Storage Gen2 / Azure SQL Staging
        |
        | Raw and staged enterprise data
        |
Azure Databricks / Delta Lake
        |
        | Bronze -> Silver -> Gold processing
        |
Curated Insurance Data Warehouse
        |
        | Star schema, facts, dimensions, data marts
        |
Power BI / Databricks SQL / Regulatory Reports / AI-Ready Data Products
```

## Architecture Layers

### 1. Source Layer

The source layer includes enterprise systems used across insurance operations:

- Salesforce CRM
- Policy administration systems
- Claims management systems
- Billing and premium systems
- Annuity platforms
- Long-term care systems
- MuleSoft APIs
- Mainframe extracts
- SFTP files
- SQL Server / Oracle databases

### 2. Integration Layer

The integration layer uses Informatica IICS / PowerCenter for enterprise ETL workflows.

Responsibilities:

- Source extraction
- Salesforce integration
- API and file ingestion
- Data validation
- Lookup handling
- Transformation logic
- SCD processing
- Workflow scheduling
- Reject handling
- Audit logging
- Source-to-target reconciliation

### 3. Cloud Landing Layer

Azure Data Lake Storage Gen2 is used as the cloud landing and storage layer.

Recommended folder structure:

```text
/adls/insurance/bronze/
/adls/insurance/silver/
/adls/insurance/gold/
/adls/insurance/rejects/
/adls/insurance/audit/
/adls/insurance/checkpoints/
```