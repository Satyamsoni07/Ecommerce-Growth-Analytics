WITH monthly_funnel AS (

    SELECT
        DATE_TRUNC('month', session_start)::date AS month,
        acquisition_channel,
        COUNT(*) AS website_sessions,
        SUM(purchased) AS purchase_sessions

    FROM {{ ref('int_session_funnel') }}

    WHERE acquisition_channel IN (
        'paid_search',
        'social',
        'email'
    )

    GROUP BY
        DATE_TRUNC('month', session_start)::date,
        acquisition_channel

),

monthly_marketing AS (

    SELECT
        DATE_TRUNC('month', spend_date)::date AS month,
        acquisition_channel,
        SUM(impressions) AS impressions,
        SUM(ad_clicks) AS ad_clicks,
        SUM(spend) AS total_spend

    FROM {{ ref('stg_marketing_spend') }}

    GROUP BY
        DATE_TRUNC('month', spend_date)::date,
        acquisition_channel

)

SELECT
    m.month,
    m.acquisition_channel,
    m.impressions,
    m.ad_clicks,
    f.website_sessions,
    f.purchase_sessions,
    m.total_spend,

    m.total_spend
        / NULLIF(f.website_sessions, 0)
        AS cost_per_session,

    m.total_spend
        / NULLIF(f.purchase_sessions, 0)
        AS cost_per_purchase

FROM monthly_marketing AS m

LEFT JOIN monthly_funnel AS f
    ON m.month = f.month
    AND m.acquisition_channel = f.acquisition_channel