SELECT
    session_id,
    visitor_id,

    session_start::timestamp AS session_start,

    TRIM(device_type) AS device_type,
    TRIM(acquisition_channel) AS acquisition_channel

FROM {{ source('raw', 'website_sessions') }}