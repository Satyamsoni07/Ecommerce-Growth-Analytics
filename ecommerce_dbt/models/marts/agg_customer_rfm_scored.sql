WITH rfm_percentiles AS (

    SELECT
        customer_unique_id,
        recency_days,
        frequency,
        monetary_value,

        PERCENT_RANK() OVER (
            ORDER BY recency_days DESC
        ) AS recency_percentile,

        PERCENT_RANK() OVER (
            ORDER BY monetary_value ASC
        ) AS monetary_percentile

    FROM {{ ref('agg_customer_rfm') }}

)

SELECT
    customer_unique_id,
    recency_days,
    frequency,
    monetary_value,

    recency_percentile,
    monetary_percentile,

    CASE
        WHEN recency_percentile < 0.20 THEN 1
        WHEN recency_percentile < 0.40 THEN 2
        WHEN recency_percentile < 0.60 THEN 3
        WHEN recency_percentile < 0.80 THEN 4
        ELSE 5
    END AS recency_score,

    CASE
        WHEN frequency = 1 THEN 1
        WHEN frequency = 2 THEN 2
        WHEN frequency = 3 THEN 3
        WHEN frequency BETWEEN 4 AND 5 THEN 4
        ELSE 5
    END AS frequency_score,

    CASE
        WHEN monetary_percentile < 0.20 THEN 1
        WHEN monetary_percentile < 0.40 THEN 2
        WHEN monetary_percentile < 0.60 THEN 3
        WHEN monetary_percentile < 0.80 THEN 4
        ELSE 5
    END AS monetary_score

FROM rfm_percentiles