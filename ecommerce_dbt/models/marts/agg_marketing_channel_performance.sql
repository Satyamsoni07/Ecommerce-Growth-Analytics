SELECT
    acquisition_channel,

    SUM(impressions) AS impressions,
    SUM(ad_clicks) AS ad_clicks,
    SUM(spend) AS total_spend,

    SUM(ad_clicks)::numeric
        / NULLIF(SUM(impressions), 0)
        AS ctr,

    SUM(spend)
        / NULLIF(SUM(ad_clicks), 0)
        AS cpc,

    SUM(spend) * 1000
        / NULLIF(SUM(impressions), 0)
        AS cpm

FROM {{ ref('stg_marketing_spend') }}

GROUP BY acquisition_channel