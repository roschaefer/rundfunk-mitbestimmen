SELECT
  id, title, reviews,
  (CAST(positives AS FLOAT)/CAST(NULLIF(reviews,0)   AS FLOAT)) AS approval,
  (CAST(total     AS FLOAT)/CAST(NULLIF(positives,0) AS FLOAT)) AS average,
  total
FROM
(
  SELECT
  broadcast_id                                                           AS id,
  broadcasts.title                                                       AS title,
  COUNT(*)                                                               AS reviews,
  COALESCE(SUM(CASE WHEN selections.response = 1 THEN 1 ELSE 0 END), 0)  AS positives,
  COALESCE(SUM(amount),0)                                                AS total
  FROM selections
  JOIN broadcasts ON selections.broadcast_id = broadcasts.id
  GROUP BY selections.broadcast_id, broadcasts.title
) t;
