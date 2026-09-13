SELECT
    s.session_id,
    s.visitor_id,
    s.session_start,
    s.device_type,
    s.acquisition_channel,

    MAX(
        CASE
            WHEN e.event_type = 'product_view' THEN 1
            ELSE 0
        END
    ) AS viewed_product,

    MAX(
        CASE
            WHEN e.event_type = 'add_to_cart' THEN 1
            ELSE 0
        END
    ) AS added_to_cart,

    MAX(
        CASE
            WHEN e.event_type = 'checkout' THEN 1
            ELSE 0
        END
    ) AS started_checkout,

    MAX(
        CASE
            WHEN e.event_type = 'purchase' THEN 1
            ELSE 0
        END
    ) AS purchased

FROM {{ ref('stg_website_sessions') }} AS s

LEFT JOIN {{ ref('stg_website_events') }} AS e
    ON s.session_id = e.session_id

GROUP BY
    s.session_id,
    s.visitor_id,
    s.session_start,
    s.device_type,
    s.acquisition_channel