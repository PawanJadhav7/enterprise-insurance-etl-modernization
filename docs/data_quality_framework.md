# Data Quality Framework

## Overview

This document defines the data quality framework for the Enterprise Insurance ETL Modernization Platform.

The framework is designed for a Manulife / John Hancock–style regulated insurance environment where data quality, reconciliation, auditability, and operational reliability are critical.

## Data Quality Objectives

The data quality framework ensures that data is:

- Complete
- Accurate
- Consistent
- Valid
- Timely
- Deduplicated
- Reconciled
- Traceable
- Secure for downstream reporting and analytics

## Key Data Quality Principles

### 1. Validate Early

Data should be validated as soon as it enters the platform.

Examples:

- Required fields
- Valid dates
- Valid amounts
- Valid status codes
- Valid source system identifiers

### 2. Reject Bad Records

Invalid records should not silently flow into curated reporting tables.

Invalid records should be routed to reject tables with:

- Batch ID
- Source system
- Record identifier
- Reject reason
- Raw payload
- Created timestamp

### 3. Reconcile Every Batch

Every ETL batch should reconcile source and target counts.

Basic reconciliation formula:

```text
source_count = target_insert_count + target_update_count + reject_count
```

## Data Quality Flow

```text
Source Data
   -> Ingestion
   -> Staging / Bronze
   -> Data Quality Validation
   -> Valid Records
   -> Silver / Gold Tables
```

```text
Invalid Records
   -> Reject Table
   -> Error Review
   -> Correction / Reprocessing
```
