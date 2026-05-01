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
