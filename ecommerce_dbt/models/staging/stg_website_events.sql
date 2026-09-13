SELECT
    session_id,
    visitor_id,

    event_timestamp::timestamp AS event_timestamp,

    TRIM(event_type) AS event_type

FROM {{ source('raw', 'website_events') }}