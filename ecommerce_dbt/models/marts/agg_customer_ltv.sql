SELECT
    customer_unique_id,

    first_order_date,
    last_order_date,

    delivered_order_count,

    total_gmv AS lifetime_gmv,
    total_payment_value AS lifetime_payment_value,

    average_order_value,

    (last_order_date - first_order_date) AS customer_lifespan_days,

    CASE
        WHEN delivered_order_count > 1 THEN TRUE
        ELSE FALSE
    END AS is_repeat_customer

FROM {{ ref('agg_customer_metrics') }}