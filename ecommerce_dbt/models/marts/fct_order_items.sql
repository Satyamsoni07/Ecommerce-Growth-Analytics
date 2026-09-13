SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,

    shipping_limit_date,

    price,
    freight_value,

    product_category_name,
    product_category_name_english,

    seller_city,
    seller_state

FROM {{ ref('int_order_items_enriched') }}