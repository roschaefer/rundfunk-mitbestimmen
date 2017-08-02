SELECT
  id, title, votes,
  (CAST(positives AS FLOAT)/CAST(NULLIF(votes,0)   AS FLOAT))           AS approval,
  COALESCE((CAST(total     AS FLOAT)/CAST(NULLIF(positives,0) AS FLOAT)),0) AS average,
  total,
  votes * average_amount_per_selection as expected_amount
FROM (
  SELECT
  broadcast_id                                                           AS id,
  broadcasts.title                                                       AS title,
  COUNT(*)                                                               AS votes,
  COALESCE(SUM(CASE WHEN selections.response = 1 THEN 1 ELSE 0 END), 0)  AS positives,
  COALESCE(SUM(amount),0)                                                AS total
  FROM selections
  JOIN broadcasts ON selections.broadcast_id = broadcasts.id
  GROUP BY selections.broadcast_id, broadcasts.title
) t LEFT JOIN (
  SELECT SUM(amount)/COUNT(*) AS average_amount_per_selection FROM selections
) a ON true;
