SELECT count(distinct(artist_id)) as distinct_artists, aired::date as date, station
FROM songs
Group by aired::date, station
