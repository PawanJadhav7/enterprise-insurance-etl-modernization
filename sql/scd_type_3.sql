-- SCD Type 3 Example: dim_risk_tier
-- Track current and previous customer risk tier

MERGE INTO dim_risk_tier AS tgt
USING stg_customer_risk AS src
ON tgt.customer_id = src.customer_id

WHEN MATCHED
AND tgt.current_risk_tier <> src.risk_tier
THEN UPDATE SET
    tgt.previous_risk_tier = tgt.current_risk_tier,
    tgt.current_risk_tier = src.risk_tier,
    tgt.risk_tier_change_date = CURRENT_DATE,
    tgt.source_system = src.source_system,
    tgt.batch_id = src.batch_id,
    tgt.updated_at = CURRENT_TIMESTAMP

WHEN NOT MATCHED THEN
    INSERT (
        customer_id,
        current_risk_tier,
        previous_risk_tier,
        risk_tier_change_date,
        source_system,
        batch_id,
        created_at,
        updated_at
    )
    VALUES (
        src.customer_id,
        src.risk_tier,
        NULL,
        CURRENT_DATE,
        src.source_system,
        src.batch_id,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    );
