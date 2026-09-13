SELECT
    TRIM(experiment_id) AS experiment_id,

    control_visitors::integer AS control_visitors,
    treatment_visitors::integer AS treatment_visitors,

    control_conversions::integer AS control_conversions,
    treatment_conversions::integer AS treatment_conversions,

    control_conversion_rate::numeric AS control_conversion_rate,
    treatment_conversion_rate::numeric AS treatment_conversion_rate,

    absolute_uplift::numeric AS absolute_uplift,
    relative_uplift::numeric AS relative_uplift,

    z_statistic::numeric AS z_statistic,
    p_value::numeric AS p_value,

    ci_lower::numeric AS ci_lower,
    ci_upper::numeric AS ci_upper,

    srm_chi2_statistic::numeric AS srm_chi2_statistic,
    srm_p_value::numeric AS srm_p_value,
    srm_detected::boolean AS srm_detected,

    is_statistically_significant::boolean
        AS is_statistically_significant,

    projected_checkout_visitors::integer
        AS projected_checkout_visitors,

    estimated_incremental_purchases::numeric
        AS estimated_incremental_purchases,

    incremental_purchases_ci_lower::numeric
        AS incremental_purchases_ci_lower,

    incremental_purchases_ci_upper::numeric
        AS incremental_purchases_ci_upper

FROM {{ source('raw', 'experiment_results') }}