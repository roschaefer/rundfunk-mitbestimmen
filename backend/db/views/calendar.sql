SELECT aired::date as date, count(*) as aired_count, artist_id
FROM songs
Group by aired::date, artist_id
Order by aired_count desc
