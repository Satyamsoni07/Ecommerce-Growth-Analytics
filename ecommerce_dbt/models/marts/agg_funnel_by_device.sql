SELECT
    device_type,

    COUNT(*) AS total_sessions,

    SUM(viewed_product) AS product_view_sessions,
    SUM(added_to_cart) AS add_to_cart_sessions,
    SUM(started_checkout) AS checkout_sessions,
    SUM(purchased) AS purchase_sessions,

    SUM(viewed_product)::numeric
        / NULLIF(COUNT(*), 0)
        AS session_to_view_rate,

    SUM(added_to_cart)::numeric
        / NULLIF(SUM(viewed_product), 0)
        AS view_to_cart_rate,

    SUM(started_checkout)::numeric
        / NULLIF(SUM(added_to_cart), 0)
        AS cart_to_checkout_rate,

    SUM(purchased)::numeric
        / NULLIF(SUM(started_checkout), 0)
        AS checkout_to_purchase_rate,

    SUM(purchased)::numeric
        / NULLIF(COUNT(*), 0)
        AS overall_conversion_rate

FROM {{ ref('int_session_funnel') }}

GROUP BY device_type