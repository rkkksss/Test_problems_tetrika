-- sqlite3 < main.sql

create table hits (host text, ip text, page text);
.separator "\t"
.import hits.txt hits
select ip from hits group by ip order by count(*) desc limit 5;
