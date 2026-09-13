SELECT
    COALESCE(
        i.product_category_name_english,
        i.product_category_name,
        'Unknown'
    ) AS product_category,

    COUNT(*) AS items_sold,
    COUNT(DISTINCT i.order_id) AS order_count,

    SUM(i.price) AS product_gmv,
    SUM(i.freight_value) AS freight_value,

    AVG(i.price) AS average_item_price,

    SUM(i.price)
        / NULLIF(SUM(SUM(i.price)) OVER (), 0)
        AS gmv_share

FROM {{ ref('fct_order_items') }} AS i

INNER JOIN {{ ref('fct_orders') }} AS o
    ON i.order_id = o.order_id

INNER JOIN {{ ref('dim_date') }} AS d
    ON o.order_purchase_date = d.date_day

WHERE
    o.order_status = 'delivered'
    AND d.is_reliable_analysis_period = TRUE

GROUP BY
    COALESCE(
        i.product_category_name_english,
        i.product_category_name,
        'Unknown'
    )