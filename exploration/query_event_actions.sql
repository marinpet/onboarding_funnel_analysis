SELECT
    hits.eventInfo.eventAction AS event_action,
    hits.eventCategory AS event_category,
    COUNT(*) AS count
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
UNNEST(hits) AS hits
WHERE
    _TABLE_SUFFIX BETWEEN '20170801' AND '20170810'
    AND hits.type = 'EVENT'
GROUP BY
    event_category,
    event_action

ORDER BY count DESC
