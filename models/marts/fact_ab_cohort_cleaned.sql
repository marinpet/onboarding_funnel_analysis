{{
    config(
        materialized = 'table',
        labels       = {'layer': 'mart'}
    )
}}

WITH base AS (

  SELECT
    user_pseudo_id,
    is_control,
    is_treatment,
    sessions,
    purchases,

    -- no-purchase rows: NULL → 0
    COALESCE(revenue, 0) AS revenue

  FROM {{ ref('fact_ab_cohort') }}

)   

SELECT *
FROM base
-- drop 'bought something but revenue null'
WHERE NOT (purchases > 0 AND revenue IS NULL)