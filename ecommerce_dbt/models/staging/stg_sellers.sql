SELECT
    seller_id,

    LPAD(seller_zip_code_prefix::text, 5, '0')
        AS seller_zip_code_prefix,

    TRIM(seller_city)
        AS seller_city,

    TRIM(seller_state)
        AS seller_state

FROM {{ source('raw', 'sellers') }}