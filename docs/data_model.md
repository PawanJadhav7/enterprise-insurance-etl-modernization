# Insurance Data Warehouse Model

## Overview

This document defines the dimensional data model for the Enterprise Insurance ETL Modernization Platform. The model is designed for a Manulife / John Hancock–style insurance and financial services environment.

The warehouse supports policy analytics, claims analytics, billing and premium reporting, Salesforce customer 360, advisor performance, annuity transactions, long-term care analytics, regulatory reporting, and AI-ready data products.

## Modeling Approach

The project uses a hybrid dimensional model:

- Star schema for core reporting marts
- Snowflake extensions where normalization improves governance or reuse
- SCD Type 1 for correction-based dimensions
- SCD Type 2 for historical tracking
- SCD Type 3 for limited current/previous comparison
- Fact tables at clearly defined business grains
- Surrogate keys for dimensional joins
- Business keys for source traceability
- Audit columns for lineage and reconciliation

## Core Subject Areas

| Subject Area | Purpose |
|---|---|
| Customer / Member | Customer profile, demographics, segmentation, risk classification |
| Policy | Policy lifecycle, status, coverage, product, riders |
| Claims | Claim intake, adjudication, denial, approval, payment |
| Billing | Premium due, premium collected, refunds, failed payments |
| Salesforce CRM | Accounts, contacts, cases, advisors, service interactions |
| Agent / Advisor | Producer performance, territory, commission |
| Annuity | Contributions, withdrawals, account values, surrender activity |
| Long-Term Care | Benefit utilization, eligibility, care episode tracking |

## Dimension Tables

### dim_customer

Tracks policyholder and customer profile attributes.

Grain: one row per customer version.

SCD Type: Type 2

Important attributes:

- customer_sk
- customer_id
- customer_hash_key
- customer_segment
- gender
- age_band
- state_code
- zip3
- risk_segment
- source_system
- effective_start_date
- effective_end_date
- is_current
- record_hash
- created_at
- updated_at

Sensitive fields such as full name, email, phone, SSN, and full address should not be exposed in the Gold analytics layer.

### dim_policy

Tracks policy attributes and historical policy changes.

Grain: one row per policy version.

SCD Type: Type 2

Important attributes:

- policy_sk
- policy_id
- customer_sk
- product_sk
- policy_number_token
- policy_status
- policy_issue_date
- policy_effective_date
- policy_termination_date
- premium_frequency
- coverage_amount_band
- underwriting_class
- effective_start_date
- effective_end_date
- is_current
- record_hash

### dim_product

Tracks insurance product metadata.

Grain: one row per product.

SCD Type: Type 1

Important attributes:

- product_sk
- product_id
- product_name
- product_type
- product_family
- line_of_business
- is_active
- created_at
- updated_at

### dim_agent

Tracks advisor, agent, and producer information.

Grain: one row per agent version.

SCD Type: Type 2

Important attributes:

- agent_sk
- agent_id
- agent_name_masked
- broker_dealer
- branch_code
- territory
- region
- agent_status
- effective_start_date
- effective_end_date
- is_current
- record_hash

### dim_claim_status

Tracks standardized claim status codes.

Grain: one row per claim status.

SCD Type: Type 1

Important attributes:

- claim_status_sk
- claim_status_code
- claim_status_description
- claim_status_group
- is_terminal_status

### dim_risk_tier

Tracks current and previous risk classification.

Grain: one row per customer.

SCD Type: Type 3

Important attributes:

- customer_id
- current_risk_tier
- previous_risk_tier
- risk_tier_change_date
- updated_at

### dim_date

Standard date dimension used across all facts.

Grain: one row per calendar date.

Important attributes:

- date_sk
- calendar_date
- year
- quarter
- month
- month_name
- week_of_year
- day_of_month
- day_of_week
- is_weekend
- fiscal_year
- fiscal_quarter

## Fact Tables

### fact_claim

Grain: one row per claim.

Measures:

- claim_amount
- approved_amount
- denied_amount
- paid_amount
- claim_cycle_days
- adjudication_days

Foreign keys:

- customer_sk
- policy_sk
- product_sk
- claim_status_sk
- submitted_date_sk
- paid_date_sk

### fact_claim_line

Grain: one row per claim service line.

Measures:

- line_charge_amount
- line_allowed_amount
- line_paid_amount
- line_denied_amount

Foreign keys:

- claim_id
- customer_sk
- policy_sk
- product_sk
- service_date_sk

### fact_policy_premium

Grain: one row per policy premium billing event.

Measures:

- premium_due_amount
- premium_paid_amount
- outstanding_amount
- days_past_due

Foreign keys:

- policy_sk
- customer_sk
- product_sk
- billing_date_sk
- payment_date_sk

### fact_payment

Grain: one row per payment transaction.

Measures:

- payment_amount
- refund_amount
- failed_payment_amount

Foreign keys:

- policy_sk
- customer_sk
- payment_date_sk

### fact_policy_snapshot

Grain: one row per policy per month.

Measures:

- active_policy_count
- lapsed_policy_count
- coverage_amount
- monthly_premium_amount

Foreign keys:

- policy_sk
- customer_sk
- product_sk
- snapshot_month_sk

### fact_agent_commission

Grain: one row per agent commission event.

Measures:

- commission_amount
- premium_volume
- policies_sold_count

Foreign keys:

- agent_sk
- policy_sk
- product_sk
- commission_date_sk

### fact_annuity_transaction

Grain: one row per annuity transaction.

Measures:

- contribution_amount
- withdrawal_amount
- surrender_amount
- account_value

Foreign keys:

- customer_sk
- policy_sk
- product_sk
- transaction_date_sk

### fact_ltc_benefit

Grain: one row per long-term care benefit event.

Measures:

- benefit_paid_amount
- benefit_days
- approved_benefit_amount
- remaining_benefit_amount

Foreign keys:

- customer_sk
- policy_sk
- provider_sk
- service_date_sk

## Star Schema View

```text
dim_customer       dim_policy       dim_product       dim_date
      \                |                |               /
       \               |                |              /
        --------------- fact_claim --------------------
                       |
                 dim_claim_status

```
