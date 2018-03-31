SELECT count(*) as aired_count, aired::date as date, artist_id
FROM songs
Group by aired::date, artist_id
