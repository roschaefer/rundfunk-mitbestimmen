SELECT count(*) as aired_count, aired::date as date, station, artist_id
FROM songs
Group by aired::date, station, artist_id
