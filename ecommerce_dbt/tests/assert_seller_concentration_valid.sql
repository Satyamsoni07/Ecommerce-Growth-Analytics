SELECT
    total_sellers,
    top_1_gmv_share,
    top_5_gmv_share,
    top_10_gmv_share,
    top_20_gmv_share,
    seller_hhi

FROM {{ ref('agg_seller_concentration') }}

WHERE
    total_sellers <= 0
    OR top_1_gmv_share < 0
    OR top_20_gmv_share > 1
    OR top_1_gmv_share > top_5_gmv_share
    OR top_5_gmv_share > top_10_gmv_share
    OR top_10_gmv_share > top_20_gmv_share
    OR seller_hhi < 0
    OR seller_hhi > 1