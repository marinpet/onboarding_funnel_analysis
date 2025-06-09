/*
    One row per GA4 session, with Boolean step-flags indicating whether the user completed each step in the onboarding funnel, 
    and time to next-step metrics (in seconds).
*/

{{
    config(
        materialized = 'table',
        partition_by = {'field': 'session_start_date', 'data_type': 'date'},
        cluster_by = ['has_purchased'],
        labels = {'layer': 'mart'}
    )
}}

WITH events AS (
    -- include only relevant fields and events --
    SELECT
        user_pseudo_id,
        ga_session_id,
        event_ts,
        event_name
    FROM {{ ref('stg_events')}}
    WHERE 
        event_name IN ('view_item', 'add_to_cart', 'begin_checkout', 'purchase')
),

steps AS (
    SELECT
        user_pseudo_id,
        ga_session_id,

        -- first occurrence timestamps 
        MIN(IF(event_name = 'view_item', event_ts, NULL)) AS t_view,
        MIN(IF(event_name = 'add_to_cart', event_ts, NULL)) AS t_cart,
        MIN(IF(event_name = 'begin_checkout', event_ts, NULL)) AS t_checkout,
        MIN(IF(event_name = 'purchase', event_ts, NULL)) AS t_purchase
    FROM events
    GROUP BY 1, 2
),

sessions AS (
    SELECT *
    FROM {{ ref('int_sessions') }}
    
)

SELECT
    s.*,

    -- step flags
    t_view IS NOT NULL AS has_viewed_item,
    t_cart IS NOT NULL AS has_added_to_cart,
    t_checkout IS NOT NULL AS has_begun_checkout,
    t_purchase IS NOT NULL AS has_purchased,

    -- timings (null if step or next step missing)
    TIMESTAMP_DIFF(t_cart, t_view, SECOND) AS secs_view_to_cart,
    TIMESTAMP_DIFF(t_checkout, t_cart, SECOND) AS secs_cart_to_checkout,
    TIMESTAMP_DIFF(t_purchase, t_checkout, SECOND) AS secs_checkout_to_purchase

FROM sessions AS s
LEFT JOIN steps AS f
    USING (user_pseudo_id, ga_session_id)