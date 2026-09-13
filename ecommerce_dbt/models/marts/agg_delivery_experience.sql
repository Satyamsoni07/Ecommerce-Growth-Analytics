SELECT
    CASE
        WHEN f.is_late_delivery = TRUE THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,

    COUNT(*) AS reviewed_orders,

    AVG(f.review_score) AS average_review_score,

    COUNT(*) FILTER (
        WHERE f.review_score <= 2
    ) AS low_rating_orders,

    COUNT(*) FILTER (
        WHERE f.review_score <= 2
    )::numeric
    / NULLIF(COUNT(*), 0) AS low_rating_rate,

    AVG(f.delivery_days) AS average_delivery_days

FROM {{ ref('fct_orders') }} AS f

INNER JOIN {{ ref('dim_date') }} AS d
    ON f.order_purchase_date = d.date_day

WHERE
    f.order_status = 'delivered'
    AND d.is_reliable_analysis_period = TRUE
    AND f.review_score IS NOT NULL
    AND f.order_delivered_customer_date IS NOT NULL
    AND f.review_creation_date IS NOT NULL

    AND f.review_creation_date
        >= f.order_delivered_customer_date::date

GROUP BY
    CASE
        WHEN f.is_late_delivery = TRUE THEN 'Late'
        ELSE 'On Time'
    END