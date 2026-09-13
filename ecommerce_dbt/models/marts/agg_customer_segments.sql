SELECT
    customer_unique_id,
    recency_days,
    frequency,
    monetary_value,

    recency_score,
    frequency_score,
    monetary_score,

    CASE
        WHEN recency_score >= 4
             AND frequency_score >= 2
             AND monetary_score >= 4
            THEN 'Champions'

        WHEN frequency_score >= 2
             AND recency_score >= 3
            THEN 'Loyal Repeat Customers'

        WHEN recency_score >= 4
             AND frequency_score = 1
             AND monetary_score >= 4
            THEN 'High-Value Recent'

        WHEN recency_score >= 4
             AND frequency_score = 1
             AND monetary_score <= 3
            THEN 'Promising'

        WHEN recency_score <= 2
             AND monetary_score >= 4
            THEN 'At-Risk High Value'

        WHEN recency_score <= 2
             AND monetary_score <= 2
            THEN 'Hibernating'

        ELSE 'Regular Customers'
    END AS customer_segment

FROM {{ ref('agg_customer_rfm_scored') }}