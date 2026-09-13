SELECT *

FROM {{ ref('agg_funnel_overview') }}

WHERE
    product_view_sessions > total_sessions
    OR add_to_cart_sessions > product_view_sessions
    OR checkout_sessions > add_to_cart_sessions
    OR purchase_sessions > checkout_sessions
    OR session_to_view_rate NOT BETWEEN 0 AND 1
    OR view_to_cart_rate NOT BETWEEN 0 AND 1
    OR cart_to_checkout_rate NOT BETWEEN 0 AND 1
    OR checkout_to_purchase_rate NOT BETWEEN 0 AND 1
    OR overall_conversion_rate NOT BETWEEN 0 AND 1