# Business Scenario

## Client Profile

This project represents a Manulife / John Hancock–style enterprise insurance and financial services organization.

The client operates across:

- Life insurance
- Long-term care insurance
- Annuities
- Claims management
- Billing and premium collection
- Advisor and broker distribution
- Salesforce-based customer servicing
- Regulatory and operational reporting

The organization has millions of policyholders and receives data from several legacy and modern enterprise systems.

## Current Business Problem

The company has data spread across multiple systems:

- Salesforce CRM contains customer, advisor, case, and service interaction data.
- Policy administration systems contain policy, rider, coverage, and beneficiary data.
- Claims systems contain claim intake, adjudication, denial, approval, and payment data.
- Billing systems contain premium invoices, payments, refunds, and failed payments.
- Annuity platforms contain contract, contribution, withdrawal, and surrender data.
- Long-term care systems contain eligibility, benefit usage, and care episode data.

Because these systems are fragmented, business teams face problems such as:

- Slow reporting cycles
- Manual spreadsheet-based reconciliation
- Inconsistent customer and policy definitions
- Delayed claims visibility
- Limited premium collection insights
- Difficulty tracking policy changes over time
- Weak auditability for regulatory reporting
- Risk of exposing sensitive PII/PHI data
- Limited readiness for AI and advanced analytics

## Business Objective

The objective is to design an enterprise-grade ETL modernization and insurance data warehouse platform that integrates data from Salesforce, policy, claims, billing, annuity, and long-term care systems.

The platform should support:

- Enterprise data integration
- Claims analytics
- Policy lifecycle reporting
- Premium collection analysis
- Customer 360 reporting
- Advisor and agent performance analytics
- Annuity transaction reporting
- Long-term care benefit utilization
- Regulatory reporting
- Data quality monitoring
- PII/PHI-safe analytics
- AI-ready curated datasets

## Proposed Solution

The proposed solution uses Informatica IICS / PowerCenter, Azure, Databricks, SQL, and Power BI.

High-level flow:

```text
Salesforce / Policy Admin / Claims / Billing / Annuity / LTC Systems
        |
        | Batch, API, JDBC, Files, CDC
        |
Informatica IICS / PowerCenter
        |
        | Validation, transformation, SCD logic, reconciliation
        |
Azure Data Lake Storage Gen2 / Azure SQL Staging
        |
Azure Databricks / Delta Lake
        |
Curated Insurance Data Warehouse
        |
Power BI / Regulatory Reports / AI-Ready Data Products

```
