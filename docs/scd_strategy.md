# Slowly Changing Dimension Strategy

## Overview

This project implements Slowly Changing Dimension patterns for enterprise insurance data warehousing.

SCD logic manages changes in customer, policy, product, agent, provider, and risk-tier data over time.

## SCD Type Selection

| Dimension | SCD Type | Reason |
|---|---:|---|
| dim_customer | Type 2 | Track historical changes in customer attributes |
| dim_policy | Type 2 | Track historical policy changes |
| dim_agent | Type 2 | Track agent territory and branch changes |
| dim_product | Type 1 | Overwrite product corrections |
| dim_claim_status | Type 1 | Overwrite status description corrections |
| dim_geography | Type 1 | Overwrite region mapping corrections |
| dim_risk_tier | Type 3 | Track current and previous risk tier |
| dim_provider | Type 2 | Track provider network status changes |

## SCD Type 1

SCD Type 1 overwrites existing values when historical tracking is not required.

Use cases:

- Product name correction
- Product family correction
- Claim status description correction
- Geography region mapping correction

Example:

- Old value: Life Secure Plan
- New value: LifeSecure Plan
- Action: update the existing row in place

## SCD Type 2

SCD Type 2 preserves full history by creating a new row when tracked attributes change.

Use cases:

- Customer address change
- Customer risk segment change
- Policy status change
- Policy premium frequency change
- Agent territory change
- Provider network status change

Required columns:

- surrogate_key
- business_key
- effective_start_date
- effective_end_date
- is_current
- record_hash
- batch_id
- source_system
- created_at
- updated_at

Current record pattern:

- effective_start_date = change date
- effective_end_date = 9999-12-31
- is_current = true

Expired record pattern:

- effective_end_date = change date - 1
- is_current = false

## SCD Type 3

SCD Type 3 tracks limited history by storing current and previous values in the same row.

Use cases:

- Current and previous risk tier
- Current and previous policy status
- Current and previous advisor assignment

Example columns:

- customer_id
- current_risk_tier
- previous_risk_tier
- risk_tier_change_date
- updated_at

Change logic:

- previous_risk_tier = current_risk_tier
- current_risk_tier = incoming_risk_tier
- risk_tier_change_date = current date

## Insurance Example

Customer C1001 moves from Massachusetts to New York.

Old row:

- customer_id = C1001
- state_code = MA
- effective_start_date = 2024-01-01
- effective_end_date = 2026-04-30
- is_current = false

New row:

- customer_id = C1001
- state_code = NY
- effective_start_date = 2026-05-01
- effective_end_date = 9999-12-31
- is_current = true

## Interview Talking Point

For an insurance environment, SCD Type 2 is important for customer, policy, agent, and provider dimensions because historical context matters for claims, underwriting, regulatory reporting, and customer analytics. SCD Type 1 is useful for reference corrections, and SCD Type 3 is useful for simple current-versus-previous comparisons such as risk-tier movement.
