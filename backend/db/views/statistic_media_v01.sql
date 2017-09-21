SELECT media.id, COUNT(*) as broadcasts_count, SUM(total) AS total, SUM(expected_amount) AS expected_amount
FROM media
JOIN broadcasts on media.id = broadcasts.medium_id
JOIN statistic_broadcasts ON broadcasts.id = statistic_broadcasts.id
GROUP BY media.id
UNION ALL
SELECT media.id, 0 AS broadcasts_count, 0 AS total, 0 AS expected_amount 
FROM media
LEFT JOIN broadcasts ON media.id = broadcasts.medium_id
WHERE broadcasts.medium_id IS NULL;

