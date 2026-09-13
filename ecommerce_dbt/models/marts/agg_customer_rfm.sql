SELECT
    customer_unique_id,

    (DATE '2018-09-01' - last_order_date) AS recency_days,

    delivered_order_count AS frequency,

    total_gmv AS monetary_value

FROM {{ ref('agg_customer_metrics') }}