WITH cohort_activity AS (

    SELECT
        cohort_month,
        cohort_month_number,
        COUNT(DISTINCT customer_unique_id) AS retained_customers

    FROM {{ ref('int_customer_cohort_activity') }}

    GROUP BY
        cohort_month,
        cohort_month_number

),

cohort_sizes AS (

    SELECT
        cohort_month,
        retained_customers AS cohort_size

    FROM cohort_activity

    WHERE cohort_month_number = 0

),

analysis_bounds AS (

    SELECT
        DATE_TRUNC('month', MAX(date_day))::date AS analysis_end_month

    FROM {{ ref('dim_date') }}

    WHERE is_reliable_analysis_period = TRUE

),

cohort_grid AS (

    SELECT
        s.cohort_month,
        month_number AS cohort_month_number,
        s.cohort_size

    FROM cohort_sizes AS s

    CROSS JOIN analysis_bounds AS b

    CROSS JOIN LATERAL generate_series(
        0,
        (
            (
                EXTRACT(YEAR FROM b.analysis_end_month)
                - EXTRACT(YEAR FROM s.cohort_month)
            ) * 12
            +
            (
                EXTRACT(MONTH FROM b.analysis_end_month)
                - EXTRACT(MONTH FROM s.cohort_month)
            )
        )::integer
    ) AS month_number

)

SELECT
    g.cohort_month,
    g.cohort_month_number,
    g.cohort_size,

    COALESCE(a.retained_customers, 0) AS retained_customers,

    COALESCE(a.retained_customers, 0)::numeric
        / NULLIF(g.cohort_size, 0) AS retention_rate

FROM cohort_grid AS g

LEFT JOIN cohort_activity AS a
    ON g.cohort_month = a.cohort_month
    AND g.cohort_month_number = a.cohort_month_number