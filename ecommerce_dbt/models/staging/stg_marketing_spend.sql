SELECT
    spend_date::date AS spend_date,
    TRIM(acquisition_channel) AS acquisition_channel,
    impressions::integer AS impressions,
    ad_clicks::integer AS ad_clicks,
    spend::numeric AS spend

FROM {{ source('raw', 'marketing_spend') }}