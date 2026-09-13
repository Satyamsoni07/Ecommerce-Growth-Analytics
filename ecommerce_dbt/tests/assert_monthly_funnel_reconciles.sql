WITH monthly AS (

    SELECT
        SUM(total_sessions) AS total_sessions,
        SUM(purchase_sessions) AS purchase_sessions

    FROM {{ ref('agg_monthly_funnel') }}

),

overall AS (

    SELECT
        total_sessions,
        purchase_sessions

    FROM {{ ref('agg_funnel_overview') }}

)

SELECT
    m.total_sessions AS monthly_sessions,
    o.total_sessions AS overall_sessions,
    m.purchase_sessions AS monthly_purchases,
    o.purchase_sessions AS overall_purchases

FROM monthly AS m
CROSS JOIN overall AS o

WHERE
    m.total_sessions <> o.total_sessions
    OR m.purchase_sessions <> o.purchase_sessions