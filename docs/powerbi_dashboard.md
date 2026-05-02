# Power BI Dashboard Specification

## Overview

This document defines the Power BI dashboard design for the Enterprise Insurance ETL Modernization Platform.

The dashboard is designed for a Manulife / John Hancock–style insurance environment and supports executive reporting, claims analytics, policy analytics, billing performance, advisor performance, annuity analytics, and long-term care reporting.

## Dashboard Objectives

The dashboard should help business teams monitor:

- Policy growth and lapse trends
- Claims volume and claim cycle time
- Premium collection performance
- Outstanding balances and failed payments
- Advisor and agent performance
- Annuity contributions and withdrawals
- Long-term care benefit utilization
- Data quality and reconciliation status

## Dashboard Pages

Recommended Power BI pages:

| Page | Purpose |
|---|---|
| Executive Overview | High-level insurance KPIs |
| Claims Analytics | Claim volume, status, approval, denial, and payment trends |
| Policy Analytics | Active policies, lapse rate, renewal rate, product mix |
| Billing and Premiums | Premium due, premium paid, outstanding balance, failed payments |
| Advisor Performance | Premium volume, policy sales, commissions, persistency |
| Annuity Analytics | Contributions, withdrawals, surrender activity, account value |
| Long-Term Care Analytics | Benefit usage, care episode cost, eligibility trends |
| Data Quality Monitor | Batch status, reject counts, reconciliation results |

## Executive Overview

### KPIs

| KPI | Description |
|---|---|
| Active Policies | Count of active policies |
| Total Premium Collected | Sum of premium paid |
| Claim Approval Rate | Approved claims divided by total claims |
| Claim Denial Rate | Denied claims divided by total claims |
| Average Claim Cycle Time | Average days from claim submission to payment |
| Policy Lapse Rate | Lapsed policies divided by total policies |
| Premium Collection Rate | Premium paid divided by premium due |
| Loss Ratio | Claims paid divided by premium earned |

### Visuals

- KPI cards
- Premium trend line chart
- Claim status donut chart
- Policy status bar chart
- State-level policy distribution map
- Monthly claim volume trend

## Claims Analytics Page

### Business Questions

- How many claims were submitted, approved, denied, and paid?
- What is the average claim cycle time?
- Which products have the highest claim volume?
- Which claims are delayed?
- Which regions have higher denial rates?

### Visuals

- Claim count by status
- Average claim cycle time by product
- Claims paid trend by month
- Claim denial reason breakdown
- Claim amount distribution
- Delayed claims table

## Policy Analytics Page

### Business Questions

- How many active policies exist by product?
- Which policies are lapsed or terminated?
- What is the renewal rate?
- Which products have the highest policy growth?
- Which customer segments have higher lapse risk?

### Visuals

- Active policies by product
- Policy lapse trend
- Policy status breakdown
- Product mix chart
- Customer segment policy distribution
- Monthly policy snapshot trend

## Billing and Premiums Page

### Business Questions

- What is the premium collection rate?
- How much premium is outstanding?
- Which policies are past due?
- Which payment methods have higher failure rates?
- What is the trend of premium payments?

### Visuals

- Premium due vs premium paid
- Outstanding balance by product
- Failed payment trend
- Days past due aging table
- Payment method breakdown
- Premium collection rate by month

## Advisor Performance Page

### Business Questions

- Which advisors generate the highest premium volume?
- Which advisors have the strongest persistency?
- What commissions were paid?
- Which regions are driving sales?

### Visuals

- Advisor leaderboard
- Premium volume by advisor
- Commission trend
- Policies sold by region
- Persistency rate by advisor
- New policy sales trend

## Annuity Analytics Page

### Business Questions

- What are total contributions and withdrawals?
- Which products have high surrender activity?
- What is the account value trend?
- Which customer segments are withdrawing funds?

### Visuals

- Contributions vs withdrawals
- Surrender trend
- Account value by product
- Transaction type breakdown
- Monthly annuity activity

## Long-Term Care Analytics Page

### Business Questions

- What is total benefit utilization?
- Which care episodes have high cost?
- What is the eligibility trend?
- Which regions have higher LTC claim activity?

### Visuals

- Benefit paid trend
- Benefit utilization by region
- Care episode cost distribution
- Eligibility status breakdown
- LTC claim volume by month

## Data Quality Monitor Page

### KPIs

| KPI | Description |
|---|---|
| Successful Batches | Count of successful ETL batches |
| Failed Batches | Count of failed ETL batches |
| Reject Count | Number of rejected records |
| Reconciliation Failures | Count of failed source-to-target checks |
| Data Quality Rule Failures | Count of failed validation rules |

### Visuals

- Batch status table
- Reject count by source system
- Reconciliation result trend
- Data quality rule failures
- Failed records by severity

## Recommended Filters

Global filters:

- Date
- Product
- Region
- State
- Source system
- Line of business
- Policy status
- Claim status
- Advisor
- Customer segment

## Data Sources

Power BI should consume curated Gold tables:

- gold.fact_claim
- gold.fact_policy_premium
- gold.fact_payment
- gold.fact_policy_snapshot
- gold.fact_agent_commission
- gold.fact_annuity_transaction
- gold.fact_ltc_benefit
- gold.dim_customer
- gold.dim_policy
- gold.dim_product
- gold.dim_agent
- gold.dim_claim_status
- gold.dim_date

## Security Design

Power BI access should follow least privilege.

Recommended controls:

- Row-level security by region or business unit
- Restricted access to sensitive dashboards
- No raw PII/PHI fields in Power BI model
- Use masked or tokenized identifiers
- Certified datasets for business reporting
- Audit access to sensitive reports

## Interview Talking Point

The Power BI layer should not directly consume raw source data. It should consume curated Gold facts and dimensions that are reconciled, governed, and PII/PHI-safe. For a Manulife / John Hancock–style environment, dashboards should support executive KPIs, claims operations, premium collection, policy analytics, advisor performance, regulatory reporting, and data quality monitoring.