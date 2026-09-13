SELECT
    f.customer_unique_id,

    MIN(f.order_purchase_date) AS first_order_date,
    MAX(f.order_purchase_date) AS last_order_date,

    COUNT(*) AS delivered_order_count,

    SUM(f.product_value) AS total_gmv,
    SUM(f.total_payment_value) AS total_payment_value,

    AVG(f.total_payment_value) AS average_order_value,
    AVG(f.review_score) AS average_review_score,

    COUNT(*) FILTER (
        WHERE f.is_late_delivery = TRUE
    ) AS late_delivery_count,

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
    f.customer_unique_id