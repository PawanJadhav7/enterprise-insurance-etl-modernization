-- SCD Type 1 Example: dim_product
-- Overwrite corrections where history is not required

MERGE INTO dim_product AS tgt
USING stg_product AS src
ON tgt.product_id = src.product_id

WHEN MATCHED THEN
    UPDATE SET
        tgt.product_name = src.product_name,
        tgt.product_type = src.product_type,
        tgt.product_family = src.product_family,
        tgt.line_of_business = src.line_of_business,
        tgt.is_active = src.is_active,
        tgt.source_system = src.source_system,
        tgt.updated_at = CURRENT_TIMESTAMP

WHEN NOT MATCHED THEN
    INSERT (
        product_id,
        product_name,
        product_type,
        product_family,
        line_of_business,
        is_active,
        source_system,
        created_at,
        updated_at
    )
    VALUES (
        src.product_id,
        src.product_name,
        src.product_type,
        src.product_family,
        src.line_of_business,
        src.is_active,
        src.source_system,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    );
