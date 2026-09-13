WITH date_bounds AS (

    SELECT
        MIN(order_purchase_timestamp)::date AS min_date,
        MAX(order_purchase_timestamp)::date AS max_date

    FROM {{ ref('int_orders_enriched') }}

),

date_spine AS (

    SELECT
        generate_series(
            min_date,
            max_date,
            interval '1 day'
        )::date AS date_day

    FROM date_bounds

)

SELECT
    date_day,

    EXTRACT(YEAR FROM date_day)::integer AS year,
    EXTRACT(QUARTER FROM date_day)::integer AS quarter,
    EXTRACT(MONTH FROM date_day)::integer AS month_number,

    TO_CHAR(date_day, 'Month') AS month_name,
    TO_CHAR(date_day, 'YYYY-MM') AS year_month,

    EXTRACT(ISODOW FROM date_day)::integer AS day_of_week_number,
    TO_CHAR(date_day, 'Day') AS day_of_week_name,

    CASE
        WHEN EXTRACT(ISODOW FROM date_day) IN (6, 7)
        THEN TRUE
        ELSE FALSE
    END AS is_weekend,

    CASE
        WHEN date_day BETWEEN DATE '2017-01-01' AND DATE '2018-08-31'
        THEN TRUE
        ELSE FALSE
    END AS is_reliable_analysis_period

FROM date_spine