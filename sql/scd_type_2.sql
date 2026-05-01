-- SCD Type 2 Example: dim_customer
-- Track historical changes using effective dates and hash comparison

-- Step 1: Expire changed current records

MERGE INTO dim_customer AS tgt
USING stg_customer AS src
ON tgt.customer_id = src.customer_id
AND tgt.is_current = TRUE

WHEN MATCHED
AND tgt.record_hash <> src.record_hash
THEN UPDATE SET
    tgt.effective_end_date = DATEADD(day, -1, CURRENT_DATE),
    tgt.is_current = FALSE,
    tgt.updated_at = CURRENT_TIMESTAMP;

-- Step 2: Insert new and changed current records

INSERT INTO dim_customer (
    customer_id,
    customer_hash_key,
    customer_segment,
    gender,
    age_band,
    state_code,
    zip3,
    risk_segment,
    source_system,
    effective_start_date,
    effective_end_date,
    is_current,
    record_hash,
    batch_id,
    created_at,
    updated_at
)
SELECT
    src.customer_id,
    src.customer_hash_key,
    src.customer_segment,
    src.gender,
    src.age_band,
    src.state_code,
    src.zip3,
    src.risk_segment,
    src.source_system,
    CURRENT_DATE AS effective_start_date,
    DATE '9999-12-31' AS effective_end_date,
    TRUE AS is_current,
    src.record_hash,
    src.batch_id,
    CURRENT_TIMESTAMP AS created_at,
    CURRENT_TIMESTAMP AS updated_at
FROM stg_customer src
LEFT JOIN dim_customer tgt
    ON src.customer_id = tgt.customer_id
    AND tgt.is_current = TRUE
WHERE tgt.customer_id IS NULL
   OR tgt.record_hash <> src.record_hash;

-- Quality check: one current record per customer

SELECT
    customer_id,
    COUNT(*) AS current_record_count
FROM dim_customer
WHERE is_current = TRUE
GROUP BY customer_id
HAVING COUNT(*) > 1;
