WITH experiment AS (

    SELECT
        experiment_id,

        MAX(
            CASE
                WHEN variant = 'control'
                THEN exposed_visitors
            END
        ) AS control_visitors,

        MAX(
            CASE
                WHEN variant = 'treatment'
                THEN exposed_visitors
            END
        ) AS treatment_visitors,

        MAX(
            CASE
                WHEN variant = 'control'
                THEN conversion_rate
            END
        ) AS control_conversion_rate,

        MAX(
            CASE
                WHEN variant = 'treatment'
                THEN conversion_rate
            END
        ) AS treatment_conversion_rate

    FROM {{ ref('agg_experiment_variant_performance') }}

    GROUP BY experiment_id
)

SELECT
    experiment_id,
    control_visitors,
    treatment_visitors,
    control_conversion_rate,
    treatment_conversion_rate,

    treatment_conversion_rate
        - control_conversion_rate
        AS absolute_uplift,

    (
        treatment_conversion_rate
        - control_conversion_rate
    )
        / NULLIF(control_conversion_rate, 0)
        AS relative_uplift

FROM experiment