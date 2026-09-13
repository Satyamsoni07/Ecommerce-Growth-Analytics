WITH monthly AS (

    SELECT
        acquisition_channel,
        SUM(purchase_transactions) AS purchase_transactions,
        SUM(attributed_purchase_value) AS attributed_purchase_value,
        SUM(total_spend) AS total_spend

    FROM {{ ref('agg_monthly_marketing_roas') }}

    GROUP BY acquisition_channel

),

overall AS (

    SELECT
        acquisition_channel,
        purchase_transactions,
        attributed_purchase_value,
        total_spend

    FROM {{ ref('agg_marketing_roas') }}

)

SELECT
    m.acquisition_channel

FROM monthly AS m

INNER JOIN overall AS o
    ON m.acquisition_channel = o.acquisition_channel

WHERE
    m.purchase_transactions <> o.purchase_transactions
    OR ABS(m.attributed_purchase_value - o.attributed_purchase_value) > 0.01
    OR ABS(m.total_spend - o.total_spend) > 0.01