/*
    Schema overview of `bigquery-public-data.ga4_obfuscated_sample_ecommerce`

  1.  Shard inventory       – one row per daily table with row-count & size
*/

SELECT
  table_id AS shard,
  row_count,
  ROUND(size_bytes / 1e6, 1) AS size_mb,
  creation_time
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.__TABLES__`
ORDER BY shard
