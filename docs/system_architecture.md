# System Architecture

## Architecture Overview

This project uses a hybrid enterprise ETL and cloud lakehouse architecture designed for a Manulife / John Hancock–style insurance environment.

The architecture combines Informatica IICS / PowerCenter, Azure cloud services, Databricks, Delta Lake, SQL-based data warehousing, Salesforce integration, and governed analytics.

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
/adls/insurance/bronze/
/adls/insurance/silver/
/adls/insurance/gold/
/adls/insurance/rejects/
/adls/insurance/audit/
/adls/insurance/checkpoints/
Source Systems
   -> Informatica IICS / PowerCenter
   -> ADLS Gen2 / Azure SQL Staging
   -> Databricks Bronze
   -> Databricks Silver
   -> Databricks Gold
   -> Power BI / SQL Warehouse
Claim Status Events / Payment Events
   -> MuleSoft APIs / Event Hubs
   -> Databricks Structured Streaming
   -> Bronze Event Tables
   -> Silver Clean Events
   -> Gold Fact Claim Status Event
   -> Operational Dashboard / Alerting
---

## 3. Update `docs/source_systems.md`

```bash
cat > docs/source_systems.md << 'EOF'
# Source Systems

## Overview

This project integrates data from multiple insurance and financial services source systems. The source landscape is modeled after a Manulife / John Hancock–style enterprise environment.

## Source System Inventory

| Source System | Type | Data Provided | Integration Method |
|---|---|---|---|
| Salesforce CRM | SaaS CRM | Accounts, contacts, leads, advisors, cases | IICS Salesforce Connector / API |
| Policy Administration System | Legacy / Relational | Policies, riders, coverage, status, beneficiaries | JDBC / CDC / Batch Extract |
| Claims Management System | Relational / Mainframe | Claim header, claim lines, status, adjudication | JDBC / Files / API |
| Billing Platform | Relational / SaaS | Invoices, premiums, payments, refunds | Batch Extract / API |
| Annuity Platform | Legacy / Relational | Contracts, contributions, withdrawals, account value | Batch Extract / File |
| Long-Term Care System | Relational / Files | Eligibility, benefits, care episodes, claims | Batch Extract / File |
| MuleSoft APIs | Middleware | Enterprise API-based integrations | REST API |
| External Reference Data | Files / API | State codes, product mappings, risk tables | CSV / API |
| Mainframe Extracts | Flat Files | Historical policy and claim extracts | SFTP / Fixed-width files |

## Salesforce CRM

Salesforce provides customer and advisor interaction data.

Key objects:

- Account
- Contact
- Lead
- Opportunity
- Case
- User
- Advisor / Producer custom objects

Integration pattern:

```text
Salesforce API
   -> Informatica IICS Salesforce Connector
   -> Staging
   -> Silver customer/advisor tables
   -> Gold customer and advisor dimensions
Policy Admin DB / Extract
   -> Informatica Source Qualifier
   -> Transformation and validation
   -> ADLS / Azure SQL Staging
   -> Gold dim_policy and fact_policy_snapshot
Claims DB / Files
   -> Informatica / ADF
   -> Bronze claim raw
   -> Silver claim clean
   -> Gold fact_claim and fact_claim_line
Billing Source
   -> Informatica Mapping
   -> Payment validation
   -> Gold fact_policy_premium and fact_payment
Annuity Extract
   -> Informatica
   -> Staging
   -> Gold fact_annuity_transaction
LTC Source
   -> Informatica / Files
   -> Silver LTC clean
   -> Gold fact_ltc_benefit
MuleSoft API
   -> IICS REST Connector / ADF REST connector
   -> Staging
   -> Silver normalized tables
---

## 4. Update `docs/tech_stack.md`

```bash
cat > docs/tech_stack.md << 'EOF'
# Technology Stack

## Core ETL and Data Integration

| Technology | Purpose |
|---|---|
| Informatica IICS / PowerCenter | Enterprise ETL design, mappings, workflows, Salesforce and legacy system integration |
| SQL | Data transformation, validation, SCD logic, reconciliation, performance tuning |
| Python | Synthetic data generation, validation scripts, and automation utilities |
| PySpark | Large-scale data transformation in Databricks |
| MuleSoft APIs | Middleware and API-based enterprise integration pattern |

## Azure Cloud Platform

| Azure Service | Purpose |
|---|---|
| Azure Data Lake Storage Gen2 | Raw, cleansed, and curated data lake storage |
| Azure Data Factory | Batch ingestion and orchestration |
| Azure Databricks | Distributed ELT processing, Delta Lake workloads, and advanced transformations |
| Azure SQL Database | Staging, control tables, metadata, and relational serving |
| Azure Event Hubs | Near real-time event ingestion for claims and payment events |
| Azure Key Vault | Secrets and credential management |
| Microsoft Purview | Data catalog, lineage, classification, and governance |
| Azure Monitor / Log Analytics | Pipeline monitoring, logging, alerting, and operational visibility |

## Databricks and Lakehouse

| Component | Purpose |
|---|---|
| Delta Lake | ACID transactions, schema enforcement, scalable storage, and time travel |
| Databricks Workflows | Job orchestration |
| Databricks SQL | Analytical querying and BI serving |
| Unity Catalog | Governance, access control, lineage, and table permissions |
| Auto Loader | Incremental file ingestion from ADLS Gen2 |
| Structured Streaming | Near real-time claim status and payment event processing |

## Data Warehouse and Modeling

| Concept | Purpose |
|---|---|
| Star Schema | Curated reporting model for facts and dimensions |
| Snowflake Schema | Normalized dimension extensions where required |
| SCD Type 1 | Overwrite corrections such as product description updates |
| SCD Type 2 | Full history tracking for customer, policy, agent, and provider changes |
| SCD Type 3 | Current and previous value tracking for selected attributes such as risk tier |
| Fact Tables | Claims, payments, premiums, commissions, underwriting decisions, annuity transactions |
| Dimension Tables | Customer, policy, product, agent, provider, geography, date, claim status |

## Source Systems

| Source | Purpose |
|---|---|
| Salesforce CRM | Customer, advisor, lead, case, and account integration |
| Policy Administration System | Policy, coverage, rider, beneficiary, and premium data |
| Claims Management System | Claim header, claim line, status, adjudication, and payment data |
| Billing System | Invoices, premium payments, refunds, and failed payments |
| Annuity Platform | Contracts, contributions, withdrawals, account value, and surrender activity |
| Long-Term Care System | Benefit usage, eligibility, care episodes, and claim activity |
| MuleSoft APIs | Middleware and API-based enterprise integration |
| Mainframe / Flat Files | Legacy source extracts and historical data migration |

## Data Quality and Governance

| Capability | Purpose |
|---|---|
| Batch Control Tables | Track batch ID, source count, target count, reject count, and load status |
| Reject Tables | Capture invalid records and error reasons |
| Data Quality Rules | Validate nulls, duplicates, dates, amounts, domains, and referential integrity |
| PII/PHI Masking | Protect sensitive customer, claim, financial, and health-related data |
| Role-Based Access Control | Restrict access by data domain and user role |
| Audit Logging | Support compliance, troubleshooting, and operational transparency |
| Metadata Management | Capture source-to-target mappings, table ownership, and lineage |

## DevOps and CI/CD

| Tool | Purpose |
|---|---|
| GitHub | Source control and portfolio visibility |
| GitHub Actions | CI validation, testing, and automated checks |
| Azure DevOps | Enterprise alternative for release pipelines, approval gates, and deployments |
| Databricks Asset Bundles | Optional deployment framework for Databricks jobs and notebooks |
| pytest | Python unit testing |
| sqlfluff | SQL linting and formatting |

## Reporting and Analytics

| Tool | Purpose |
|---|---|
| Power BI | Executive dashboards and operational reporting |
| Databricks SQL Dashboards | Lakehouse-native analytics |
| SQL Reports | Data reconciliation, audit, and regulatory extracts |
| Excel / CSV Exports | Business reconciliation and operational review |

## Business KPIs

| KPI Area | Examples |
|---|---|
| Claims | Claim approval rate, denial rate, claim cycle time, paid amount |
| Policy | Active policies, lapse rate, renewal rate, premium collection |
| Financial | Loss ratio, expense ratio, combined ratio, receivables |
| Agent / Advisor | Policies sold, commission paid, premium volume, persistency |
| Customer | Customer 360, service case resolution, risk segmentation |
| Annuity | Contributions, withdrawals, surrender rate, account value |
| Long-Term Care | Benefit utilization, eligibility trends, care episode cost |
