SELECT stations.id as id, stations.name as name, stations.medium_id as medium_id, COUNT(*) as broadcasts_count, SUM(t.total/t.stations_count) as total, SUM(t.expected_amount/t.stations_count) as expected_amount
FROM (
  SELECT statistic_broadcasts.id as broadcast_id, statistic_broadcasts.total as total, statistic_broadcasts.expected_amount as expected_amount, COUNT(*) AS stations_count
  FROM statistic_broadcasts
  JOIN schedules ON statistic_broadcasts.id = schedules.broadcast_id
  GROUP BY statistic_broadcasts.id, statistic_broadcasts.total, statistic_broadcasts.expected_amount
) as t
JOIN schedules ON t.broadcast_id = schedules.broadcast_id
JOIN stations on schedules.station_id = stations.id
GROUP BY stations.id, stations.name, stations.medium_id
UNION ALL
SELECT stations.id AS id, stations.name AS name, stations.medium_id AS medium_id, 0 as broadcasts_count, 0 as total, 0 as expected_amount
FROM stations
LEFT JOIN schedules on stations.id = schedules.station_id
WHERE schedules.broadcast_id IS NULL;

