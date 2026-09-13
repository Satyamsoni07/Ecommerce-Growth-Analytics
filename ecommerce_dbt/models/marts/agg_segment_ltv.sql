SELECT
    s.customer_segment,

    COUNT(*) AS customer_count,

    AVG(l.lifetime_gmv) AS average_lifetime_gmv,
    AVG(l.lifetime_payment_value) AS average_lifetime_payment_value,

    AVG(l.customer_lifespan_days) AS average_lifespan_days,

    COUNT(*) FILTER (
        WHERE l.is_repeat_customer = TRUE
    ) AS repeat_customer_count

FROM {{ ref('agg_customer_ltv') }} AS l

INNER JOIN {{ ref('agg_customer_segments') }} AS s
    ON l.customer_unique_id = s.customer_unique_id

GROUP BY
    s.customer_segment