{{ config(
    materialized='table'
) }}

WITH events AS (

  SELECT
    user_id,
    session_id,
    LOWER(event_action) AS event_action,
    event_date
  FROM {{ ref('stg_events') }}

),

steps AS (

  SELECT
    user_id,

    MIN(CASE WHEN event_action = 'product click' THEN event_date END) AS step_1_view,
    MIN(CASE WHEN event_action = 'add to cart' THEN event_date END) AS step_2_add,
    MIN(CASE WHEN event_action = 'remove from cart' THEN event_date END) AS step_3_remove
  FROM events
  GROUP BY user_id

),

funnel_flags AS (
  SELECT
    user_id,

    -- Step flags
    step_1_view IS NOT NULL AS viewed_product,
    step_2_add IS NOT NULL AS added_to_cart,
    step_3_remove IS NOT NULL AS removed_from_cart,

    -- Anomaly flags
    step_3_remove IS NOT NULL AND step_2_add IS NULL AND step_1_view IS NULL AS removed_without_prior_steps,
    step_3_remove IS NOT NULL AND step_2_add IS NOT NULL AND step_1_view IS NULL AS added_removed_without_view,
    step_2_add IS NOT NULL AND step_1_view IS NULL AS added_without_view

  FROM steps
)

SELECT * FROM funnel_flags