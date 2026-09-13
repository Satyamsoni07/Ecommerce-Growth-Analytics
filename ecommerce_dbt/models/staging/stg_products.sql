SELECT
    product_id,

    NULLIF(TRIM(product_category_name), '')
        AS product_category_name,

    product_name_lenght::integer
        AS product_name_length,

    product_description_lenght::integer
        AS product_description_length,

    product_photos_qty::integer
        AS product_photos_qty,

    product_weight_g::integer
        AS product_weight_g,

    product_length_cm::integer
        AS product_length_cm,

    product_height_cm::integer
        AS product_height_cm,

    product_width_cm::integer
        AS product_width_cm

FROM {{ source('raw', 'products') }}