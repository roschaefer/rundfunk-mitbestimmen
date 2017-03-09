SELECT
  broadcast_id AS id,
  title,
  (SELECT COUNT(*) FROM users) - COUNT(*) AS missing,
  COUNT(selections.response = 1)          AS positives,
  COUNT(selections.response = 0)          AS neutrals,
  SUM(amount)                             AS total_amount
FROM selections
JOIN broadcasts ON selections.broadcast_id = broadcasts.id
GROUP BY selections.broadcast_id, broadcasts.title;

