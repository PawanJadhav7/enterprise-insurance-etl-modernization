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
```text
Salesforce CRM
...
Power BI / Databricks SQL / Regulatory Reports / AI-Ready Data Products
```