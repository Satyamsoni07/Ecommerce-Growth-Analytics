SELECT
    TRIM(transaction_id) AS transaction_id,
    TRIM(session_id) AS session_id,
    TRIM(visitor_id) AS visitor_id,
    purchase_timestamp::timestamp AS purchase_timestamp,
    purchase_value::numeric AS purchase_value

FROM {{ source('raw', 'website_purchases') }}