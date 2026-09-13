WITH customer_monthly_activity AS (

    SELECT DISTINCT
        f.customer_unique_id,
        DATE_TRUNC('month', f.order_purchase_date)::date AS activity_month

    FROM {{ ref('fct_orders') }} AS f

    INNER JOIN {{ ref('dim_date') }} AS d
        ON f.order_purchase_date = d.date_day

    WHERE
        f.order_status = 'delivered'
        AND d.is_reliable_analysis_period = TRUE

)

SELECT
    a.customer_unique_id,
    c.cohort_month,
    a.activity_month,

    (
        (EXTRACT(YEAR FROM a.activity_month) - EXTRACT(YEAR FROM c.cohort_month)) * 12
        +
        (EXTRACT(MONTH FROM a.activity_month) - EXTRACT(MONTH FROM c.cohort_month))
    )::integer AS cohort_month_number

FROM customer_monthly_activity AS a

INNER JOIN {{ ref('int_customer_cohorts') }} AS c
    ON a.customer_unique_id = c.customer_unique_id