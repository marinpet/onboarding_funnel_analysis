{{
    config(materialized='table')
}}

WITH funnel AS (
    SELECT *
    FROM {{ ref('mart_onboarding_funnel') }}
),

summary AS (
    SELECT
        COUNT(*) AS total_users,

        COUNTIF(viewed_product) AS step1_viewed,
        COUNTIF(added_to_cart) AS step2_added,
        COUNTIF(removed_from_cart) AS step3_removed,

        COUNTIF(removed_without_prior_steps) AS removed_without_prior,
        COUNTIF(added_removed_without_view) AS added_removed_without_view,
        COUNTIF(added_without_view) AS added_without_view
    FROM funnel
)

SELECT * FROM summary
