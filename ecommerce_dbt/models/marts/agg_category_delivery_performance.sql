SELECT
    COALESCE(
        i.product_category_name_english,
        i.product_category_name,
        'Unknown'
    ) AS product_category,

    COUNT(DISTINCT o.order_id) AS delivered_orders,

    COUNT(DISTINCT o.order_id) FILTER (
        WHERE o.is_late_delivery = TRUE
    ) AS late_orders,

    COUNT(DISTINCT o.order_id) FILTER (
        WHERE o.is_late_delivery = TRUE
    )::numeric
    /
    NULLIF(
        COUNT(DISTINCT o.order_id) FILTER (
            WHERE o.is_late_delivery IS NOT NULL
        ),
        0
    ) AS late_delivery_rate,

    AVG(o.delivery_days) AS average_delivery_days,

    AVG(o.review_score) FILTER (
        WHERE o.review_score IS NOT NULL
          AND o.review_creation_date >= o.order_delivered_customer_date::date
    ) AS average_review_score

FROM {{ ref('fct_order_items') }} AS i

INNER JOIN {{ ref('fct_orders') }} AS o
    ON i.order_id = o.order_id

INNER JOIN {{ ref('dim_date') }} AS d
    ON o.order_purchase_date = d.date_day

WHERE
    o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
    AND d.is_reliable_analysis_period = TRUE

GROUP BY
    COALESCE(
        i.product_category_name_english,
        i.product_category_name,
        'Unknown'
    )