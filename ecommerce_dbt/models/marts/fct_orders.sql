SELECT
    order_id,
    customer_id,
    customer_unique_id,

    order_status,

    order_purchase_timestamp,
    order_purchase_timestamp::date AS order_purchase_date,

    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,

    delivery_days,
    is_late_delivery,

    item_count,
    distinct_product_count,
    seller_count,

    product_value,
    freight_value,
    total_item_value,

    total_payment_value,
    payment_record_count,

    review_score,
    review_creation_date,
    review_answer_timestamp

FROM {{ ref('int_orders_enriched') }}