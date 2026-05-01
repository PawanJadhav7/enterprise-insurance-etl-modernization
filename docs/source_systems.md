# Source Systems

## Overview

This project integrates data from multiple insurance and financial services source systems. The source landscape is modeled after a Manulife / John Hancock–style enterprise environment.

The goal is to consolidate data from Salesforce, policy administration, claims, billing, annuity, long-term care, legacy files, and enterprise APIs into a governed insurance data warehouse and lakehouse platform.

## Source System Inventory

| Source System | Type | Data Provided | Integration Method |
|---|---|---|---|
| Salesforce CRM | SaaS CRM | Accounts, contacts, leads, advisors, service cases | Informatica IICS Salesforce Connector / REST API |
| Policy Administration System | Legacy / Relational | Policies, riders, coverage, beneficiaries, policy status | JDBC / CDC / Batch Extract |
| Claims Management System | Relational / Mainframe | Claim header, claim lines, claim status, adjudication, payments | JDBC / Files / API |
| Billing Platform | Relational / SaaS | Invoices, premiums, payments, refunds, failed payments | Batch Extract / API |
| Annuity Platform | Legacy / Relational | Contracts, contributions, withdrawals, surrender activity, account value | Batch Extract / File |
| Long-Term Care System | Relational / Files | Eligibility, benefit usage, care episodes, LTC claims | Batch Extract / File |
| MuleSoft APIs | Middleware | Enterprise API-based integrations | REST API |
| External Reference Data | Files / API | State codes, product mappings, risk tables, calendar data | CSV / API |
| Mainframe Extracts | Flat Files | Historical policy, claim, billing, and customer data | SFTP / Fixed-width files |

## Salesforce CRM

Salesforce provides customer, advisor, lead, and service interaction data.

### Key Objects

- Account
- Contact
- Lead
- Opportunity
- Case
- User
- Advisor / Producer custom objects

### Integration Pattern

```text
Salesforce API
   -> Informatica IICS Salesforce Connector
   -> Staging Tables
   -> Silver Customer and Advisor Tables
   -> Gold Customer and Advisor Dimensions
Policy Administration Database / Extract
   -> Informatica Source Qualifier
   -> Transformation and Validation
   -> Azure SQL / ADLS Staging
   -> Gold dim_policy and fact_policy_snapshot
   -> Claims Source
   -> Informatica / Azure Data Factory
   -> Bronze Claim Raw
   -> Silver Claim Clean
   -> Gold fact_claim and fact_claim_line
Policy Administration Database / Extract
   -> Informatica Source Qualifier
   -> Transformation and Validation
   -> Azure SQL / ADLS Staging
   -> Gold dim_policy and fact_policy_snapshot
Claims Source
   -> Informatica / Azure Data Factory
   -> Bronze Claim Raw
   -> Silver Claim Clean
   -> Gold fact_claim and fact_claim_line
Billing Source
   -> Informatica Mapping
   -> Payment Validation
   -> Gold fact_policy_premium and fact_payment
Annuity Extract
   -> Informatica
   -> Staging
   -> Silver Annuity Clean
   -> Gold fact_annuity_transaction
LTC Source
   -> Informatica / Files
   -> Silver LTC Clean
   -> Gold fact_ltc_benefit
MuleSoft API
   -> IICS REST Connector / ADF REST Connector
   -> Staging
   -> Silver Normalized Tables
   -> Gold Reporting Tables
source_count = target_insert_count + target_update_count + reject_count
