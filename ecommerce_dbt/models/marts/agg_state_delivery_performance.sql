SELECT
    f.customer_state,

    COUNT(*) AS delivered_orders,

    AVG(f.delivery_days) AS average_delivery_days,

    COUNT(*) FILTER (
        WHERE f.is_late_delivery = TRUE
    ) AS late_orders,

    COUNT(*) FILTER (
        WHERE f.is_late_delivery = TRUE
    )::numeric
    /
    NULLIF(
        COUNT(*) FILTER (
            WHERE f.is_late_delivery IS NOT NULL
        ),
        0
    ) AS late_delivery_rate,

    AVG(f.review_score) FILTER (
        WHERE f.review_score IS NOT NULL
          AND f.review_creation_date >= f.order_delivered_customer_date::date
    ) AS average_review_score,

    COUNT(*) FILTER (
        WHERE f.review_score <= 2
          AND f.review_creation_date >= f.order_delivered_customer_date::date
    )::numeric
    /
    NULLIF(
        COUNT(*) FILTER (
            WHERE f.review_score IS NOT NULL
              AND f.review_creation_date >= f.order_delivered_customer_date::date
        ),
        0
    ) AS low_rating_rate

FROM {{ ref('int_orders_enriched') }} AS f

INNER JOIN {{ ref('dim_date') }} AS d
    ON f.order_purchase_timestamp::date = d.date_day

WHERE
    f.order_status = 'delivered'
    AND f.order_delivered_customer_date IS NOT NULL
    AND d.is_reliable_analysis_period = TRUE

GROUP BY
    f.customer_state