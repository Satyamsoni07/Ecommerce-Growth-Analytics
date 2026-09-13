SELECT
    customer_id,
    customer_unique_id,

    LPAD(customer_zip_code_prefix::text, 5, '0')
        AS customer_zip_code_prefix,

    TRIM(customer_city)
        AS customer_city,

    TRIM(customer_state)
        AS customer_state

FROM {{ source('raw', 'customers') }}