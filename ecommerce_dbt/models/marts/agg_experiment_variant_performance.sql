SELECT
    experiment_id,
    variant,

    COUNT(*) AS exposed_visitors,
    SUM(converted) AS conversions,

    SUM(converted)::numeric
        / NULLIF(COUNT(*), 0)
        AS conversion_rate

FROM {{ ref('stg_experiment_checkout') }}

GROUP BY
    experiment_id,
    variant