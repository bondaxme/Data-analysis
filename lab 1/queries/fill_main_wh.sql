use stage;

insert into main_warehouse.dimcountry(country)
select distinct country
from stadiums;

insert into main_warehouse.dimcity(country_id, city)
select distinct dc.country_id, city
from stadiums
         join main_warehouse.dimcountry dc on dc.country = stadiums.country;

insert into main_warehouse.dimstadium(city_id, name, capacity)
select distinct city_id, name, capacity
from stadiums
         join main_warehouse.dimcity ds on ds.city = stadiums.city;

insert into main_warehouse.dimteams(country_id, team_id, team_name, home_stadium)
select distinct country_id, id, team_name, home_stadium
from teams
join main_warehouse.dimcountry dc on teams.country = dc.country;

insert into main_warehouse.dimseason(season)
select distinct season
from matches;

insert into main_warehouse.dimdate(year, month, day)
select distinct year(date_time), month(date_time), day(date_time)
from matches
union
select distinct year(date_of_birth), month(date_of_birth), day(date_of_birth)
from managers;

insert into main_warehouse.dimmanager(date_id, first_name, last_name, nationality, team)
select distinct date_id, first_name, last_name, nationality, team
from managers m
         join main_warehouse.dimdate dd
              on year(m.date_of_birth) = dd.year and month(m.date_of_birth) = dd.month and
                 day(date_of_birth) = dd.day;


insert into main_warehouse.factmatches(date_id, home_team_id, away_team_id, season_id, home_manager_id, away_manager_id,
                                       stadium_id,
                                       home_team_score, away_team_score, isPenalty, attendance)
select d.date_id,
       t.team_id,
       t2.team_id,
       s.season_id,
       m1.manager_id,
       m2.manager_id,
       st.stadium_id,
       home_team_score,
       away_team_score,
       penalty_shoot_out,
       attendance
from matches m
         join main_warehouse.dimdate d
              on year(m.date_time) = d.year and month(m.date_time) = d.month and day(m.date_time) = d.day
         join main_warehouse.dimteams t on m.home_team = t.team_name
         join main_warehouse.dimteams t2 on m.away_team = t2.team_name
         join main_warehouse.dimseason s on m.season = s.season
         join main_warehouse.dimstadium st on m.stadium = st.name
         join main_warehouse.dimmanager m1 on m.home_team = m1.team
         join main_warehouse.dimmanager m2 on m.away_team = m2.team;
