SELECT
    cohort_month,
    cohort_month_number,
    cohort_size,
    retained_customers,
    retention_rate

FROM {{ ref('agg_cohort_retention') }}

WHERE
    retention_rate < 0
    OR retention_rate > 1
    OR retained_customers > cohort_size
    OR (
        cohort_month_number = 0
        AND retention_rate <> 1
    )