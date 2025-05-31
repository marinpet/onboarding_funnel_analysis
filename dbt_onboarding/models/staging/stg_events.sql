{{
    config(
        materialized='view'
    )
}}

-- Extract user data
WITH source AS (
    SELECT
        fullVisitorID as user_id,
        visitId as session_id,
        visitStartTime,
        hits.type as hit_type,
        hits.eventInfo.eventCategory as event_category,
        hits.eventInfo.eventAction as event_action,
        hits.eventInfo.eventLabel as event_label,
        PARSE_DATE('%Y%m%d', date) as event_date,
    FROM 
    `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
    UNNEST(hits) as hits
    WHERE
        _TABLE_SUFFIX BETWEEN '20170801' AND '20170810'
        AND hits.type = 'EVENT'

)

SELECT * FROM source