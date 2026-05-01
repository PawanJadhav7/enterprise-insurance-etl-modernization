-- Dimension Tables
-- Enterprise Insurance ETL Modernization Platform

CREATE TABLE IF NOT EXISTS dim_customer (
    customer_sk BIGINT,
    customer_id VARCHAR(100) NOT NULL,
    customer_hash_key VARCHAR(256),
    customer_segment VARCHAR(100),
    gender VARCHAR(20),
    age_band VARCHAR(50),
    state_code VARCHAR(10),
    zip3 VARCHAR(10),
    risk_segment VARCHAR(100),
    source_system VARCHAR(100),
    effective_start_date DATE NOT NULL,
    effective_end_date DATE NOT NULL,
    is_current BOOLEAN NOT NULL,
    record_hash VARCHAR(256) NOT NULL,
    batch_id VARCHAR(100),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS dim_policy (
    policy_sk BIGINT,
    policy_id VARCHAR(100) NOT NULL,
    customer_id VARCHAR(100),
    product_id VARCHAR(100),
    policy_number_token VARCHAR(256),
    policy_status VARCHAR(50),
    policy_issue_date DATE,
    policy_effective_date DATE,
    policy_termination_date DATE,
    premium_frequency VARCHAR(50),
    coverage_amount_band VARCHAR(50),
    underwriting_class VARCHAR(100),
    source_system VARCHAR(100),
    effective_start_date DATE NOT NULL,
    effective_end_date DATE NOT NULL,
    is_current BOOLEAN NOT NULL,
    record_hash VARCHAR(256) NOT NULL,
    batch_id VARCHAR(100),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS dim_product (
    product_sk BIGINT,
    product_id VARCHAR(100) NOT NULL,
    product_name VARCHAR(255),
    product_type VARCHAR(100),
    product_family VARCHAR(100),
    line_of_business VARCHAR(100),
    is_active BOOLEAN,
    source_system VARCHAR(100),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS dim_risk_tier (
    customer_id VARCHAR(100) NOT NULL,
    current_risk_tier VARCHAR(100),
    previous_risk_tier VARCHAR(100),
    risk_tier_change_date DATE,
    source_system VARCHAR(100),
    batch_id VARCHAR(100),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
