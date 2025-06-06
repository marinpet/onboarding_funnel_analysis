/*
    Schema overview for `bigquery-public-data.ga4_obfuscated_sample_ecommerce`:
        3.  Event-name histogram  – frequency of each event (10 % TABLESAMPLE)
*/
SELECT
    event_name,
    COUNT(*) AS approx_hits
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
TABLESAMPLE SYSTEM (10 PERCENT)
GROUP BY event_name
ORDER BY approx_hits DESC;