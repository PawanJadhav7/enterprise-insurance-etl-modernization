---

# 3. Create `docs/scd_strategy.md`

```bash
cat > docs/scd_strategy.md << 'EOF'
# Slowly Changing Dimension Strategy

## Overview

This project implements Slowly Changing Dimension patterns for enterprise insurance data warehousing.

SCD logic is used to manage changes in customer, policy, product, agent, provider, and risk-tier data over time.

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

### Purpose

SCD Type 1 overwrites existing values when historical tracking is not required.

### Use Cases

- Product name correction
- Product family correction
- Claim status description correction
- Geography region mapping correction

### Example

If `product_name` changes from `Life Secure Plan` to `LifeSecure Plan`, the record is updated in place.

### Columns

```text
product_sk
product_id
product_name
product_type
product_family
line_of_business
is_active
created_at
updated_at
surrogate_key
business_key
attributes
effective_start_date
effective_end_date
is_current
record_hash
created_at
updated_at
batch_id
source_system
effective_start_date = change date
effective_end_date = 9999-12-31
is_current = true
effective_end_date = change date - 1
is_current = false
record_hash = hash(attribute_1, attribute_2, attribute_3)
customer_id
current_risk_tier
previous_risk_tier
risk_tier_change_date
updated_at
previous_risk_tier = current_risk_tier
current_risk_tier = incoming_risk_tier
risk_tier_change_date = current date
customer_id = C1001
state_code = MA
effective_start_date = 2024-01-01
effective_end_date = 2026-04-30
is_current = false
customer_id = C1001
state_code = NY
effective_start_date = 2026-05-01
effective_end_date = 9999-12-31
is_current = true
previous_risk_tier = Low
current_risk_tier = Medium
risk_tier_change_date = 2026-05-01
EOF
