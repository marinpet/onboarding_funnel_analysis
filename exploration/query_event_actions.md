# Event Action Exploration

**Query:** [query_event_actions.sql](./query_event_actions.sql)

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

## Results Summary (Top Event Actions)

The observed event actions between 2017-08-01 and 2017-08-10:

|   Event Category   | Event Action     | Count |
|--------------------|------------------|-------|
| Enhanced Ecommerce | Quickview Click  | 1265  |
| Enhanced Ecommerce | Add to Cart      | 494   |
| Enhanced Ecommerce | Product Click    | 411   |
| Enhanced Ecommerce | Remove from Cart | 75    |
| null               | null             | 29    |
| Contact Us         | Onsite Click     | 18    |
| Enhanced Ecommerce | Promotion Click  | 2     |

## Observations

- Most activity falls under "Enhanced Ecommerce"
- The actions represent typical e-commerce interactions:
  - **Step 1**: Product Click
  - **Step 2**: Add to Cart
  - **Step 3:** Remove from Cart (proxy for interaction completion here, although not ideal)

## Funnel Proposal

Onboarding funnel simulatio as follows:

1. **Step 1 - Product Viewed** -> event_action = "Product Click"
2. **Step 2 - Product Added to Cart** -> event_action = "Add to Cart"
3. **Step 3 - Further Engagement** -> event_action = "Remove from Cart"



