/*
    Schema overview for `bigquery-public-data.ga4_obfuscated_sample_ecommerce`

        2.  Column dictionary     – distinct column names & data types
*/

SELECT DISTINCT
  column_name,
  data_type
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name LIKE 'events_%'
ORDER BY column_name