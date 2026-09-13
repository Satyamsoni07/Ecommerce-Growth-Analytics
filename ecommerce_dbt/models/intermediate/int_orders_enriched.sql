SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,

    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    CASE
        WHEN o.order_delivered_customer_date IS NOT NULL
        THEN (
            o.order_delivered_customer_date::date
            - o.order_purchase_timestamp::date
        )
    END AS delivery_days,

    CASE
        WHEN o.order_delivered_customer_date IS NULL
            THEN NULL
        WHEN o.order_delivered_customer_date::date
             <= o.order_estimated_delivery_date::date
            THEN FALSE
        ELSE TRUE
    END AS is_late_delivery,

    c.customer_city,
    c.customer_state,

    i.item_count,
    i.distinct_product_count,
    i.seller_count,
    i.product_value,
    i.freight_value,
    i.total_item_value,

    p.total_payment_value,
    p.payment_record_count,

    r.review_score,
    r.review_creation_date,
    r.review_answer_timestamp

FROM {{ ref('stg_orders') }} AS o

LEFT JOIN {{ ref('stg_customers') }} AS c
    ON o.customer_id = c.customer_id

LEFT JOIN {{ ref('int_order_items_summary') }} AS i
    ON o.order_id = i.order_id

LEFT JOIN {{ ref('int_order_payments') }} AS p
    ON o.order_id = p.order_id

LEFT JOIN {{ ref('int_latest_order_review') }} AS r
    ON o.order_id = r.order_id