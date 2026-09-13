SELECT
    TRIM(experiment_id) AS experiment_id,
    TRIM(visitor_id) AS visitor_id,
    TRIM(variant) AS variant,
    exposure_timestamp::timestamp AS exposure_timestamp,
    converted::integer AS converted

FROM {{ source('raw', 'experiment_checkout') }}