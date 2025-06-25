{{
    config(
        materialized = 'view',
        labels = {'layer': 'mart'}
    )
}}

WITH steps AS (
    SELECT '1 View item' AS step, ga_session_id
    FROM {{ ref('fact_conversion_funnel')}}
    WHERE has_viewed_item

    UNION ALL
    SELECT '2 Add to cart' AS step, ga_session_id
    FROM {{ ref('fact_conversion_funnel')}}
    WHERE has_added_to_cart

    UNION ALL
    SELECT '3 Checkout' AS step, ga_session_id
    FROM {{ ref('fact_conversion_funnel')}}
    WHERE has_begun_checkout

    UNION ALL
    SELECT '4 Purchase', ga_session_id
    FROM {{ ref('fact_conversion_funnel')}}
    WHERE has_purchased
)

SELECT
    step,
    COUNT(DISTINCT ga_session_id) AS sessions
FROM steps
GROUP BY step
ORDER BY step
