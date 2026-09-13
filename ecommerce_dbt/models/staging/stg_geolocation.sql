SELECT
    LPAD(geolocation_zip_code_prefix::text, 5, '0')
        AS geolocation_zip_code_prefix,

    geolocation_lat,
    geolocation_lng,

    TRIM(geolocation_city)
        AS geolocation_city,

    TRIM(geolocation_state)
        AS geolocation_state

FROM {{ source('raw', 'geolocation') }}