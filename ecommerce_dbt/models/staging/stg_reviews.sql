SELECT
    review_id,
    order_id,

    review_score::integer
        AS review_score,

    NULLIF(TRIM(review_comment_title), '')
        AS review_comment_title,

    NULLIF(TRIM(review_comment_message), '')
        AS review_comment_message,

    review_creation_date::date
        AS review_creation_date,

    review_answer_timestamp::timestamp
        AS review_answer_timestamp

FROM {{ source('raw', 'reviews') }}