/*
    A low-cost BQ view that::
        -  keeps most of GA4 columns intact
        - extractts ga_session_id (hidden in event_params)
        - adds a readable timestamp and a partition key
    */

{{
    config(
        materialized='view',
        labels = {'layer': 'staging'}
    )
}}

WITH base AS (

    SELECT
      -- core GA4 fields
      TIMESTAMP_MICROS(event_timestamp)           AS event_ts,
      DATE(TIMESTAMP_MICROS(event_timestamp))     AS event_date,
      event_name,
      user_pseudo_id,
      platform,

      -- nested geography struct
      geo.country     AS country,
      geo.region      AS region,

      -- nested traffic_source struct
      traffic_source.name    AS traffic_name,
      traffic_source.medium  AS traffic_medium,
      traffic_source.source  AS traffic_source,

      -- pull session id out of event_params array
      (
        SELECT value.int_value
        FROM   UNNEST(event_params)
        WHERE  key = 'ga_session_id'
      ) AS ga_session_id,

      -- leave heavy arrays intact for later models
      event_params,
      user_properties,
      items

    FROM {{ source('ga4_sample', 'events_*') }}

    {{ date_where('_TABLE_SUFFIX') }}      -- macro cuts to 2-month window
)

SELECT *
FROM base