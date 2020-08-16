-- sqlite3 < main.sql

drop table if exists users ;
create table users(id text, role text);
.import --csv users.txt users

drop table if exists lessons;
create table lessons(id text, event_id text, subject text, scheduled_time date);
.import --csv lessons.txt lessons

drop table if exists participants;
create table participants(event_id text, user_id text);
.import --csv participants.txt participants

drop table if exists quality;
create table quality(lesson_id text, tech_quality integer);
.import --csv quality.txt quality
delete from quality where tech_quality = '';

drop table if exists lessons_physics;
create table lessons_physics(date date, event_id, lesson_id text);
insert into lessons_physics(date, event_id, lesson_id) select date(scheduled_time||"+03:00"), event_id, id from lessons where subject = "phys";

drop table if exists tutors;
create table tutors(tutor text, event_id text);
insert into tutors(tutor, event_id) select users.id, participants.event_id from participants join users on participants.user_id = users.id where users.role = "tutor";

drop table if exists lessons_with_tutors;
create table lessons_with_tutors(date date, tutor text, lesson_id text);
insert into lessons_with_tutors(date, tutor, lesson_id) select lessons_physics.date, tutors.tutor, lessons_physics.lesson_id from tutors join lessons_physics on lessons_physics.event_id = tutors.event_id;

drop table if exists scores;
create table scores(date date, tutor text, score integer);
insert into scores(date, tutor, score) select lessons_with_tutors.date, lessons_with_tutors.tutor, quality.tech_quality from lessons_with_tutors join quality on quality.lesson_id = lessons_with_tutors.lesson_id;

drop table if exists avg_scores;
create table avg_scores(date date, tutor text, average real);
insert into avg_scores(date, tutor, average) select date, tutor, avg(score) from scores group by date, tutor;

drop table if exists min_scores;
create table min_scores(date date, min_avg real);
insert into min_scores(date, min_avg) select date, min(average) from avg_scores group by date;

select avg_scores.date, avg_scores.tutor, avg_scores.average from avg_scores join min_scores on avg_scores.average = min_scores.min_avg and avg_scores.date = min_scores.date group by avg_scores.date;
