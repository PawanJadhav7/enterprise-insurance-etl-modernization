# Informatica Mapping Design

## Overview

This document defines Informatica IICS / PowerCenter mapping patterns for the Enterprise Insurance ETL Modernization Platform.

The mappings are designed to support enterprise insurance data integration from Salesforce, policy administration systems, claims systems, billing platforms, annuity systems, long-term care systems, and legacy files.

## Informatica Design Principles

The ETL design follows these principles:

- Reusable mapping logic
- Parameterized connections and file paths
- Incremental extraction where possible
- Source-to-target reconciliation
- Reject handling
- Audit logging
- SCD Type 1, Type 2, and Type 3 handling
- Pushdown optimization where appropriate
- Lookup cache optimization
- Modular session and workflow design
- Clear naming conventions

## Common Informatica Components

| Component | Usage |
|---|---|
| Source Qualifier | Extract relational source data |
| Salesforce Connector | Extract CRM objects such as Account, Contact, Case |
| Expression Transformation | Derive columns, standardize values, create hashes |
| Lookup Transformation | Find surrogate keys and reference data |
| Router Transformation | Split new, changed, rejected, and valid records |
| Filter Transformation | Remove invalid or inactive records |
| Joiner Transformation | Join heterogeneous sources |
| Aggregator Transformation | Summarize premiums, claims, commissions |
| Sorter Transformation | Sort data for performance or deduplication |
| Update Strategy | Insert/update logic for target tables |
| Sequence Generator | Generate surrogate keys |
| Stored Procedure | Execute database-side logic where appropriate |
| Target Definition | Load staging, dimension, fact, reject, and audit tables |

## Mapping 1: Salesforce Customer Load

### Purpose

Load Salesforce Account and Contact data into the enterprise customer dimension.

### Source

- Salesforce Account
- Salesforce Contact
- Salesforce Case optional

### Target

- staging.stg_salesforce_customer
- gold.dim_customer

### Mapping Flow

```text
Salesforce Account / Contact
    -> Salesforce Connector
    -> Expression: standardize name, email, phone, state, zip
    -> Expression: create customer natural key and record hash
    -> Lookup: existing dim_customer by customer_id
    -> Router:
          New Customer
          Changed Customer
          Unchanged Customer
          Rejected Customer
    -> Update Strategy:
          Insert new SCD2 record
          Expire old SCD2 record
    -> Target: dim_customer
    -> Target: reject_customer_records
```


### Incremental Logic

```text

LastModifiedDate > previous_successful_watermark

```

## Mapping 2: Policy Dimension Load

### Purpose

```text

Load policy data from the policy administration system into `dim_policy`.

```

### Mapping Flow

```text
LastModifiedDate > previous_successful_watermark
Policy Source
    -> Source Qualifier
    -> Expression: normalize policy status and premium frequency
    -> Lookup: dim_customer
    -> Lookup: dim_product
    -> Expression: create record_hash
    -> Lookup: current dim_policy
    -> Router:
          New Policy
          Changed Policy
          Unchanged Policy
          Rejected Policy
    -> Update Strategy
    -> Target: dim_policy
```

## Mapping 3: Product Dimension Load

### Purpose

```text
Load product reference data into `dim_product`.

```

### Mapping Flow

```text
Product Source
    -> Source Qualifier / File Source
    -> Expression: standardize product name and product family
    -> Lookup: existing dim_product
    -> Router:
          New Product
          Existing Product
    -> Update Strategy
    -> Target: dim_product
```

## Mapping 4: Claim Fact Load

### Purpose

```text

Load claim header data into `fact_claim`.

```

### Mapping Flow

```text
Claims Source
    -> Source Qualifier
    -> Expression: validate claim amount, dates, status
    -> Lookup: dim_customer
    -> Lookup: dim_policy
    -> Lookup: dim_product
    -> Lookup: dim_claim_status
    -> Router:
          Valid Claims
          Invalid Claims
    -> Expression: calculate claim_cycle_days
    -> Target: fact_claim
    -> Target: reject_claim_records
```

## Mapping 5: Premium Billing Load

### Purpose

```text

Load premium billing and payment records.

```

### Mapping Flow

```text
Billing Source
    -> Source Qualifier
    -> Expression: normalize payment status
    -> Lookup: dim_policy
    -> Lookup: dim_customer
    -> Aggregator: summarize payment amounts where required
    -> Router:
          Valid Payments
          Failed Payments
          Rejected Payments
    -> Target: fact_policy_premium
    -> Target: fact_payment
    -> Target: reject_payment_records
```

## Mapping 6: Risk Tier SCD Type 3 Load

### Purpose

```text

Track current and previous customer risk tier.

```

### Mapping Flow

```text
Risk Source
    -> Source Qualifier
    -> Expression: standardize risk tier
    -> Lookup: existing dim_risk_tier by customer_id
    -> Router:
          New Risk Record
          Risk Tier Changed
          No Change
    -> Update Strategy
    -> Target: dim_risk_tier

```

### Type 3 Logic

```text
previous_risk_tier = current_risk_tier
current_risk_tier = new_risk_tier
risk_tier_change_date = current date
```

## Parameterization Example

```text
$$ENV=DEV
$$BATCH_ID=20260501_001
$$SOURCE_SYSTEM=SALESFORCE
$$WATERMARK_START=2026-04-30 00:00:00
$$WATERMARK_END=2026-05-01 00:00:00
```

## Operational Monitoring Tables

```text
etl_batch_control
etl_step_control
etl_reject_records
etl_data_quality_results
```
## Interview Talking Point

This mapping design demonstrates enterprise Informatica ETL patterns including Salesforce extraction, lookup-based surrogate key resolution, Router-based reject handling, SCD Type 2 customer and policy processing, SCD Type 3 risk tier tracking, parameterized workflows, and batch-level reconciliation.