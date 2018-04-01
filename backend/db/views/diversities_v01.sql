SELECT count(*) as airplays, station, artist_id
FROM songs
Where songs.aired >= '2017-01-01' and songs.aired < '2018-01-01'
Group by station, artist_id
Order by airplays desc;
