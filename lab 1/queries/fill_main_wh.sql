use stage;


insert into main_warehouse.dimteams(team_id, team_name, country, home_stadium)
select distinct id, team_name, country, home_stadium
from teams;

insert into main_warehouse.dimseason(season)
select distinct season
from matches;

insert into main_warehouse.dimdate(year, month, day)
select distinct year(date_time), month(date_time), day(date_time)
from matches;

insert into main_warehouse.dimmanager(first_name, last_name, nationality, date_of_birth)
select distinct first_name, last_name, nationality, date_of_birth
from managers;

insert into main_warehouse.dimcountry(country)
select distinct country
from stadiums;

insert into main_warehouse.dimcity(country_id, city)
select distinct dc.country_id, city
from stadiums
         join main_warehouse.dimcountry dc on dc.country like stadiums.country;

insert into main_warehouse.dimstadium(city_id, name, capacity)
select distinct city_id, name, capacity
from stadiums
         join main_warehouse.dimcity ds on ds.city like stadiums.city;

insert into main_warehouse.factmatches(date_id, home_team_id, away_team_id, season_id, manager_id, stadium_id,
                                       home_team_score, away_team_score, isPenalty, attendance)
select d.date_id,
       t.team_id as home_team_id,
       t2.team_id as away_team_id,
       s.season_id,
       m2.manager_id,
       st.stadium_id,
       home_team_score,
       away_team_score,
       penalty_shoot_out,
       attendance
from matches m
         join main_warehouse.dimdate d
              on year(m.date_time) = d.year and month(m.date_time) = d.month and day(m.date_time) = d.day
         join main_warehouse.dimteams t on m.home_team like t.team_name
         join main_warehouse.dimteams t2 on m.away_team like t2.team_name
         join main_warehouse.dimseason s on m.season like s.season
         join main_warehouse.dimmanager m2
              on stage.managers.first_name like m2.first_name and stage.managers.last_name like m2.last_name
         join main_warehouse.dimstadium st on m.stadium like st.name;
