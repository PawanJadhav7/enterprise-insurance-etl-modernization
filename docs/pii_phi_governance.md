# PII / PHI Governance

## Overview

This document defines the PII and PHI governance approach for the Enterprise Insurance ETL Modernization Platform.

The project is modeled for a Manulife / John Hancock–style regulated insurance and financial services environment where customer, policy, claims, billing, annuity, and long-term care data must be handled securely.

The goal is to protect sensitive data while still enabling analytics, reporting, regulatory review, and AI-ready data products.

## Sensitive Data Categories

| Category | Examples |
|---|---|
| PII | Name, email, phone, address, SSN, date of birth |
| PHI | Diagnosis-related fields, medical indicators, long-term care claim details |
| Financial Data | Premium payments, refunds, account values, annuity transactions |
| Policy Data | Policy number, coverage amount, beneficiary details |
| Claims Data | Claim amount, claim status, denial reason, payment details |
| Salesforce Data | Customer cases, service notes, advisor relationships |

## Governance Objectives

The governance framework should ensure:

- Sensitive data is identified and classified.
- Raw PII/PHI access is restricted.
- Gold analytics tables expose only business-safe attributes.
- Secrets and credentials are not stored in code.
- Data lineage is traceable from source to target.
- Access is controlled by user role and business need.
- Data quality and reconciliation are auditable.
- AI-ready datasets do not expose raw sensitive information.

## Data Classification

Recommended classification levels:

| Classification | Description | Example |
|---|---|---|
| Public | Safe for general sharing | Product category |
| Internal | Internal business use only | Aggregated KPI data |
| Confidential | Sensitive business data | Agent performance, premium revenue |
| Restricted | PII, PHI, financial, or regulated data | SSN, DOB, claim notes, medical indicators |

## Layer-Based Protection

### Bronze Layer

Bronze contains raw or near-raw source data.

Controls:

- Restricted access
- No direct business reporting
- Audit logging
- Encryption at rest
- Source metadata capture
- Limited access to engineering and compliance-approved users

### Silver Layer

Silver contains cleansed and standardized data.

Controls:

- PII hashing
- Tokenization
- Data quality validation
- Duplicate detection
- Sensitive column tagging
- PHI segregation where required

### Gold Layer

Gold contains curated business-ready data.

Controls:

- Masked customer identifiers
- Age bands instead of full date of birth
- ZIP3 or state instead of full address
- Tokenized policy numbers
- Aggregated measures for reporting
- Role-based access to restricted data marts

## PII / PHI Handling Patterns

| Sensitive Field | Recommended Handling |
|---|---|
| Full Name | Mask or hash |
| Email | Hash |
| Phone | Hash or mask |
| SSN | Tokenize or exclude from analytics |
| Date of Birth | Convert to age band |
| Full Address | Convert to state or ZIP3 |
| Policy Number | Tokenize |
| Claim Notes | Restrict and redact |
| Diagnosis Details | Restrict or classify as PHI |
| Beneficiary Details | Restrict and mask |

## Example Safe Analytics Transformation

Raw source data may contain:

```text
customer_name = John Smith
email = john.smith@email.com
date_of_birth = 1978-04-15
address = 123 Main Street, Boston, MA
policy_number = POL123456
```

Gold Analytics table should expose

```text
customer_sk = 987654
email_hash = hashed_value
age_band = 45-54
state_code = MA
zip3 = 021
policy_number_token = tokenized_value
```
