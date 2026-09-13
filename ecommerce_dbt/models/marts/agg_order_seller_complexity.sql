SELECT
    CASE
        WHEN seller_count = 1 THEN 'Single Seller'
        WHEN seller_count > 1 THEN 'Multiple Sellers'
    END AS seller_complexity,

    COUNT(*) AS delivered_orders,

    AVG(total_payment_value) AS average_order_value,

    AVG(delivery_days) AS average_delivery_days,

    COUNT(*) FILTER (
        WHERE is_late_delivery = TRUE
    )::numeric
    /
    NULLIF(
        COUNT(*) FILTER (
            WHERE is_late_delivery IS NOT NULL
        ),
        0
    ) AS late_delivery_rate,

    AVG(review_score) FILTER (
        WHERE review_score IS NOT NULL
          AND review_creation_date >= order_delivered_customer_date::date
    ) AS average_review_score

FROM {{ ref('fct_orders') }} AS f

INNER JOIN {{ ref('dim_date') }} AS d
    ON f.order_purchase_date = d.date_day

WHERE
    f.order_status = 'delivered'
    AND f.seller_count IS NOT NULL
    AND d.is_reliable_analysis_period = TRUE

GROUP BY
    CASE
        WHEN seller_count = 1 THEN 'Single Seller'
        WHEN seller_count > 1 THEN 'Multiple Sellers'
    END