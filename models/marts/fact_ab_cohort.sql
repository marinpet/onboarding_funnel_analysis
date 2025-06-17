{{ config(
    materialized = 'table',
    labels       = {'layer': 'mart'}
) }}

WITH user_flags AS (
  SELECT
    user_pseudo_id,
    MOD(ABS(FARM_FINGERPRINT(user_pseudo_id)), 2) = 0 AS is_control,
    MOD(ABS(FARM_FINGERPRINT(user_pseudo_id)), 2) = 1 AS is_treatment
  FROM {{ ref('stg_events') }}
  GROUP BY user_pseudo_id
),

session_agg AS (
  SELECT
    user_pseudo_id,
    COUNT(*)                       AS sessions,
    COUNTIF(has_purchased)         AS purchases
  FROM {{ ref('fact_conversion_funnel') }}
  GROUP BY user_pseudo_id
),

revenue_agg AS (
  SELECT
    user_pseudo_id,
    SUM(revenue_total) AS revenue
  FROM {{ ref('int_sessions') }}
  GROUP BY user_pseudo_id
)

SELECT
  u.user_pseudo_id,
  u.is_control,
  u.is_treatment,
  s.sessions,
  s.purchases,
  r.revenue
FROM user_flags  u
JOIN session_agg s USING (user_pseudo_id)
JOIN revenue_agg r USING (user_pseudo_id)
