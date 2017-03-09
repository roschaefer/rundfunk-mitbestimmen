SELECT
  broadcast_id                                                           AS id,
  broadcasts.title                                                       AS title,
  (SELECT COUNT(*) FROM users) - COUNT(*)                                AS missing,
  COALESCE(SUM(CASE WHEN selections.response = 0 THEN 1 ELSE 0 END), 0)  AS neutrals,
  COALESCE(SUM(CASE WHEN selections.response = 1 THEN 1 ELSE 0 END), 0)  AS positives,
  COALESCE(SUM(amount),0)                                                AS total_amount
FROM selections
JOIN broadcasts ON selections.broadcast_id = broadcasts.id
GROUP BY selections.broadcast_id, broadcasts.title;

