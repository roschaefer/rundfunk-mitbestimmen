SELECT
  id, title, impressions,
  (CAST(positives AS FLOAT)/CAST(NULLIF(impressions,0)   AS FLOAT))         AS approval,
  COALESCE((CAST(total     AS FLOAT)/CAST(NULLIF(positives,0) AS FLOAT)),0) AS average,
  total,
  impressions * average_amount_per_selection as expected_amount
FROM (
  SELECT
  broadcast_id                                                           AS id,
  broadcasts.title                                                       AS title,
  COUNT(*)                                                               AS impressions,
  COALESCE(SUM(CASE WHEN impressions.response = 1 THEN 1 ELSE 0 END), 0) AS positives,
  COALESCE(SUM(amount),0)                                                AS total
  FROM impressions
  JOIN broadcasts ON impressions.broadcast_id = broadcasts.id
  GROUP BY impressions.broadcast_id, broadcasts.title
) t LEFT JOIN (
  SELECT SUM(amount)/COUNT(*) AS average_amount_per_selection FROM impressions
) a ON true;
