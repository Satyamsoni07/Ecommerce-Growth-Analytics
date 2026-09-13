SELECT
    p.transaction_id,
    p.session_id,
    p.visitor_id,
    p.purchase_timestamp,
    p.purchase_value,

    s.session_start,
    s.device_type,
    s.acquisition_channel

FROM {{ ref('stg_website_purchases') }} AS p

LEFT JOIN {{ ref('stg_website_sessions') }} AS s
    ON p.session_id = s.session_id