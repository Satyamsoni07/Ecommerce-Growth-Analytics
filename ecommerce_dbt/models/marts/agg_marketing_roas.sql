WITH purchase_value_by_channel AS (

    SELECT
        acquisition_channel,
        COUNT(*) AS purchase_transactions,
        SUM(purchase_value) AS attributed_purchase_value,
        AVG(purchase_value) AS avg_purchase_value

    FROM {{ ref('int_website_purchases_enriched') }}

    WHERE acquisition_channel IN (
        'paid_search',
        'social',
        'email'
    )

    GROUP BY acquisition_channel

),

marketing AS (

    SELECT
        acquisition_channel,
        SUM(spend) AS total_spend

    FROM {{ ref('stg_marketing_spend') }}

    GROUP BY acquisition_channel

)

SELECT
    m.acquisition_channel,
    p.purchase_transactions,
    p.attributed_purchase_value,
    p.avg_purchase_value,
    m.total_spend,

    p.attributed_purchase_value
        / NULLIF(m.total_spend, 0)
        AS roas

FROM marketing AS m

LEFT JOIN purchase_value_by_channel AS p
    ON m.acquisition_channel = p.acquisition_channel