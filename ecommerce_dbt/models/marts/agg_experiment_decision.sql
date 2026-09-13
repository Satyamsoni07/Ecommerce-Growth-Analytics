SELECT
    experiment_id,

    control_visitors,
    treatment_visitors,

    control_conversions,
    treatment_conversions,

    control_conversion_rate,
    treatment_conversion_rate,

    absolute_uplift,
    relative_uplift,

    z_statistic,
    p_value,

    ci_lower,
    ci_upper,

    srm_chi2_statistic,
    srm_p_value,
    srm_detected,

    is_statistically_significant,

    projected_checkout_visitors,
    estimated_incremental_purchases,
    incremental_purchases_ci_lower,
    incremental_purchases_ci_upper,

    CASE
        WHEN srm_detected = TRUE
            THEN 'Investigate Experiment'

        WHEN is_statistically_significant = FALSE
            THEN 'No Significant Effect'

        WHEN absolute_uplift > 0
            THEN 'Recommend Treatment'

        ELSE 'Recommend Control'
    END AS experiment_decision

FROM {{ ref('stg_experiment_results') }}