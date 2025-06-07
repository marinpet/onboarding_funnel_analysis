/*
    Visit-level summary built from stg_events
*/

{{ 
    config(
        materilized = 'table',
        partition_by = {'field': 'session_start_date', 'data_type': 'date'},
        labels = {'label' : 'intermediate'}
    )
}}

WITH hits AS (  
    SELECT
        user_pseudo_id,
        ga_session_id,
        event_ts,
        event_name,
        traffic_name,
        traffic_medium,
        traffic_source,
        platform,
        country,
        -- revenue is nested per-item; sum (price * quantity) for each item
        (SELECT SUM(it.price * it.quantity)
        FROM UNNEST(items) it) AS revenue
        FROM {{ ref('stg_events') }}
)

SELECT
    user_pseudo_id,
    ga_session_id,

    MIN(event_ts) AS session_start_ts,
    MAX(event_ts) AS session_end_ts,
    DATE(MIN(event_ts)) AS session_start_date,

    ANY_VALUE(traffic_medium) AS traffic_medium,
    ANY_VALUE(traffic_source) AS traffic_source,
    ANY_VALUE(traffic_name) AS traffic_name,
    ANY_VALUE(platform) AS platform,
    ANY_VALUE(country) AS country,

    COUNT(*) AS events_total,
    COUNTIF(event_name = 'page_view') AS pageviews,
    COUNTIF(event_name = 'purchase') AS purchases,
    SUM(revenue) AS revenue_total

FROM hits
GROUP BY
    user_pseudo_id,
    ga_session_id