WITH monthly_purchase_value AS (

    SELECT
        DATE_TRUNC('month', purchase_timestamp)::date AS month,
        acquisition_channel,
        COUNT(*) AS purchase_transactions,
        SUM(purchase_value) AS attributed_purchase_value

    FROM {{ ref('int_website_purchases_enriched') }}

    WHERE acquisition_channel IN (
        'paid_search',
        'social',
        'email'
    )

    GROUP BY
        DATE_TRUNC('month', purchase_timestamp)::date,
        acquisition_channel

),

monthly_marketing AS (

    SELECT
        DATE_TRUNC('month', spend_date)::date AS month,
        acquisition_channel,
        SUM(spend) AS total_spend

    FROM {{ ref('stg_marketing_spend') }}

    GROUP BY
        DATE_TRUNC('month', spend_date)::date,
        acquisition_channel

)

SELECT
    m.month,
    m.acquisition_channel,
    p.purchase_transactions,
    p.attributed_purchase_value,
    m.total_spend,

    p.attributed_purchase_value
        / NULLIF(m.total_spend, 0)
        AS roas

FROM monthly_marketing AS m

LEFT JOIN monthly_purchase_value AS p
    ON m.month = p.month
    AND m.acquisition_channel = p.acquisition_channel