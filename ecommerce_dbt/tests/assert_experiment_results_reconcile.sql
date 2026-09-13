SELECT
    d.experiment_id

FROM {{ ref('agg_experiment_summary') }} AS d

INNER JOIN {{ ref('stg_experiment_results') }} AS p
    ON d.experiment_id = p.experiment_id

WHERE
    d.control_visitors <> p.control_visitors

    OR d.treatment_visitors <> p.treatment_visitors

    OR ABS(
        d.control_conversion_rate
        - p.control_conversion_rate
    ) > 0.000001

    OR ABS(
        d.treatment_conversion_rate
        - p.treatment_conversion_rate
    ) > 0.000001

    OR ABS(
        d.absolute_uplift
        - p.absolute_uplift
    ) > 0.000001

    OR ABS(
        d.relative_uplift
        - p.relative_uplift
    ) > 0.000001