WITH ranked_sellers AS (

    SELECT
        seller_id,
        product_gmv,
        gmv_share,

        ROW_NUMBER() OVER (
            ORDER BY product_gmv DESC
        ) AS seller_rank

    FROM {{ ref('agg_seller_performance') }}

)

SELECT
    COUNT(*) AS total_sellers,

    SUM(gmv_share) FILTER (
        WHERE seller_rank <= 1
    ) AS top_1_gmv_share,

    SUM(gmv_share) FILTER (
        WHERE seller_rank <= 5
    ) AS top_5_gmv_share,

    SUM(gmv_share) FILTER (
        WHERE seller_rank <= 10
    ) AS top_10_gmv_share,

    SUM(gmv_share) FILTER (
        WHERE seller_rank <= 20
    ) AS top_20_gmv_share,

    SUM(gmv_share * gmv_share) AS seller_hhi

FROM ranked_sellers