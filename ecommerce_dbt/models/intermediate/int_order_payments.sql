SELECT
    order_id,
    SUM(payment_value) AS total_payment_value,
    COUNT(*) AS payment_record_count

FROM {{ ref('stg_payments') }}

GROUP BY order_id