WITH delivered_orders AS (

    SELECT
        f.customer_unique_id,
        f.order_purchase_date

    FROM {{ ref('fct_orders') }} AS f

    INNER JOIN {{ ref('dim_date') }} AS d
        ON f.order_purchase_date = d.date_day

    WHERE
        f.order_status = 'delivered'
        AND d.is_reliable_analysis_period = TRUE

)

SELECT
    customer_unique_id,

    MIN(order_purchase_date) AS first_order_date,

    DATE_TRUNC(
        'month',
        MIN(order_purchase_date)
    )::date AS cohort_month

FROM delivered_orders

GROUP BY customer_unique_id