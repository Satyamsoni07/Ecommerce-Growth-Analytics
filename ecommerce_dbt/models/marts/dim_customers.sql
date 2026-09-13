WITH ranked_customers AS (

    SELECT
        customer_unique_id,
        customer_city,
        customer_state,
        order_purchase_timestamp,

        ROW_NUMBER() OVER (
            PARTITION BY customer_unique_id
            ORDER BY order_purchase_timestamp DESC
        ) AS customer_rank

    FROM {{ ref('int_orders_enriched') }}

)

SELECT
    customer_unique_id,
    customer_city,
    customer_state

FROM ranked_customers

WHERE customer_rank = 1