WITH funnel AS (

    SELECT *
    FROM {{ ref('agg_funnel_overview') }}

)

SELECT
    1 AS stage_order,
    'Session Start' AS from_stage,
    'Product View' AS to_stage,
    total_sessions AS starting_sessions,
    product_view_sessions AS converted_sessions,
    total_sessions - product_view_sessions AS dropped_sessions,
    session_to_view_rate AS conversion_rate,
    1 - session_to_view_rate AS dropoff_rate

FROM funnel

UNION ALL

SELECT
    2,
    'Product View',
    'Add to Cart',
    product_view_sessions,
    add_to_cart_sessions,
    product_view_sessions - add_to_cart_sessions,
    view_to_cart_rate,
    1 - view_to_cart_rate

FROM funnel

UNION ALL

SELECT
    3,
    'Add to Cart',
    'Checkout',
    add_to_cart_sessions,
    checkout_sessions,
    add_to_cart_sessions - checkout_sessions,
    cart_to_checkout_rate,
    1 - cart_to_checkout_rate

FROM funnel

UNION ALL

SELECT
    4,
    'Checkout',
    'Purchase',
    checkout_sessions,
    purchase_sessions,
    checkout_sessions - purchase_sessions,
    checkout_to_purchase_rate,
    1 - checkout_to_purchase_rate

FROM funnel