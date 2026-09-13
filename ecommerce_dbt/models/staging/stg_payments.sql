SELECT
    order_id,

    payment_sequential::integer
        AS payment_sequential,

    NULLIF(TRIM(payment_type), '')
        AS payment_type,

    payment_installments::integer
        AS payment_installments,

    payment_value::numeric(12, 2)
        AS payment_value

FROM {{ source('raw', 'payments') }}