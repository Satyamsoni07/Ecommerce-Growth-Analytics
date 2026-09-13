SELECT
    DATE_TRUNC('month', f.order_purchase_date)::date AS month_start,

    COUNT(*) AS delivered_orders,
    COUNT(DISTINCT f.customer_unique_id) AS active_customers,

    SUM(f.product_value) AS product_gmv,
    SUM(f.freight_value) AS freight_value,
    SUM(f.total_payment_value) AS customer_payment_value,

    AVG(f.total_payment_value) AS average_order_value,
    AVG(f.review_score) AS average_review_score,

    COUNT(*) FILTER (
        WHERE f.is_late_delivery = TRUE
    )::numeric
    /
    NULLIF(
        COUNT(*) FILTER (
            WHERE f.is_late_delivery IS NOT NULL
        ),
        0
    ) AS late_delivery_rate

FROM {{ ref('fct_orders') }} AS f

INNER JOIN {{ ref('dim_date') }} AS d
    ON f.order_purchase_date = d.date_day

WHERE
    f.order_status = 'delivered'
    AND d.is_reliable_analysis_period = TRUE

GROUP BY
    DATE_TRUNC('month', f.order_purchase_date)::date