-- Fact Tables
-- Enterprise Insurance ETL Modernization Platform

CREATE TABLE IF NOT EXISTS fact_claim (
    claim_id VARCHAR(100) NOT NULL,
    customer_sk BIGINT,
    policy_sk BIGINT,
    product_sk BIGINT,
    claim_status VARCHAR(50),
    submitted_date DATE,
    approved_date DATE,
    denied_date DATE,
    paid_date DATE,
    claim_amount DECIMAL(18,2),
    approved_amount DECIMAL(18,2),
    denied_amount DECIMAL(18,2),
    paid_amount DECIMAL(18,2),
    claim_cycle_days INT,
    source_system VARCHAR(100),
    batch_id VARCHAR(100),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS fact_policy_premium (
    premium_event_id VARCHAR(100) NOT NULL,
    policy_sk BIGINT,
    customer_sk BIGINT,
    product_sk BIGINT,
    billing_date DATE,
    due_date DATE,
    payment_date DATE,
    premium_due_amount DECIMAL(18,2),
    premium_paid_amount DECIMAL(18,2),
    outstanding_amount DECIMAL(18,2),
    days_past_due INT,
    payment_status VARCHAR(50),
    source_system VARCHAR(100),
    batch_id VARCHAR(100),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS fact_payment (
    payment_id VARCHAR(100) NOT NULL,
    policy_sk BIGINT,
    customer_sk BIGINT,
    payment_date DATE,
    payment_amount DECIMAL(18,2),
    refund_amount DECIMAL(18,2),
    failed_payment_amount DECIMAL(18,2),
    payment_method VARCHAR(100),
    payment_status VARCHAR(50),
    source_system VARCHAR(100),
    batch_id VARCHAR(100),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
