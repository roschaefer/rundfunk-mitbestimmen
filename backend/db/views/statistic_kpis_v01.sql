SELECT
  id, title, impressions,
  (CAST(positives AS FLOAT)/CAST(NULLIF(impressions,0)   AS FLOAT))         AS approval,
  COALESCE((CAST(total     AS FLOAT)/CAST(NULLIF(positives,0) AS FLOAT)),0) AS average,
    total,
  impressions * average_amount_per_selection as expected_amount,
  validity
FROM (
  SELECT
  broadcast_id                                                           AS id,
  broadcasts.title                                                       AS title,
  COUNT(*)                                                               AS impressions,
  COALESCE(SUM(CASE WHEN history_impressions.response = 1 THEN 1 ELSE 0 END), 0) AS positives,
  COALESCE(SUM(amount),0)                                                AS total,
  history_impressions.validity                      AS validity 
  FROM "history"."impressions" history_impressions
  JOIN broadcasts ON history_impressions.broadcast_id = broadcasts.id
  GROUP BY history_impressions.broadcast_id, broadcasts.title, history_impressions.validity
) t LEFT JOIN (
  SELECT SUM(amount)/COUNT(*) AS average_amount_per_selection FROM "history"."impressions" history_impressions
) a ON true
UNION ALL
SELECT broadcasts.id AS id, broadcasts.title AS title, 0 AS impressions, NULL AS approval, NULL AS average, 0 AS total, 0 AS expected_amount, NULL as validity
FROM broadcasts
LEFT JOIN "history"."impressions" history_impressions ON broadcasts.id = history_impressions.broadcast_id
WHERE history_impressions.broadcast_id IS NULL;