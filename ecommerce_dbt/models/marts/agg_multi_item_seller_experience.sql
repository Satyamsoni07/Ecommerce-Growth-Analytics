SELECT
    CASE
        WHEN f.seller_count = 1 THEN 'Single Seller'
        WHEN f.seller_count > 1 THEN 'Multiple Sellers'
    END AS seller_complexity,

    COUNT(*) AS delivered_orders,

    COUNT(*) FILTER (
        WHERE f.review_score IS NOT NULL
          AND f.review_creation_date >= f.order_delivered_customer_date::date
    ) AS valid_reviewed_orders,

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

FROM {{ ref('fct_orders') }} AS f

INNER JOIN {{ ref('dim_date') }} AS d
    ON f.order_purchase_date = d.date_day

WHERE
    f.order_status = 'delivered'
    AND f.item_count > 1
    AND f.seller_count IS NOT NULL
    AND f.order_delivered_customer_date IS NOT NULL
    AND d.is_reliable_analysis_period = TRUE

GROUP BY
    CASE
        WHEN f.seller_count = 1 THEN 'Single Seller'
        WHEN f.seller_count > 1 THEN 'Multiple Sellers'
    END