use main_warehouse;

insert into dimseason (season)
select distinct season
from stage.matches m
where not exists(select season from dimseason ds where ds.season = m.season);

insert into dimdate (year, month, day)
select distinct year(m.date_time), month(m.date_time), day(m.date_time)
from stage.matches m
where not exists(select year(m.date_time), month(m.date_time), day(m.date_time)
                 from dimdate dd
                 where dd.year = year(m.date_time)
                   and dd.month = month(m.date_time)
                   and dd.day = day(m.date_time));

insert into dimmanager (first_name, last_name, nationality, date_of_birth, team)
select distinct first_name, last_name, nationality, date_of_birth, team
from stage.managers mn
where not exists(select dm.first_name, dm.last_name, dm.team
                 from dimmanager dm
                 where dm.first_name = mn.first_name
                   and dm.last_name = mn.last_name
                   and dm.team = mn.team);

insert into dimteams (team_name, country, home_stadium)
select distinct team_name, country, home_stadium
from stage.teams t
where not exists(select dt.team_name from dimteams dt where t.team_name = dt.team_name);

insert into dimcountry (country)
select distinct country
from stage.stadiums st
where not exists(select dc.country from dimcountry dc where dc.country = st.country);

insert into dimcity (country_id, city)
select distinct country_id, city
from stage.stadiums st
         join dimcountry dc on st.country = dc.country
where not exists(select dc.city from dimcity dc where dc.city = st.city);

insert into dimstadium (source_id, city_id, name, capacity, start_date, end_date)
select distinct null, dc.city_id, st.name, st.capacity, null, null
from stage.stadiums st
         join dimcity dc on st.city = dc.city
where not exists(select ds.name from dimstadium ds where st.name = ds.name);


insert into factmatches (date_id, home_team_id, away_team_id, season_id, home_manager_id, away_manager_id, stadium_id,
                         home_team_score, away_team_score, isPenalty, attendance)
select distinct d.date_id,
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
from stage.matches m
         join main_warehouse.dimdate d
              on year(m.date_time) = d.year and month(m.date_time) = d.month and day(m.date_time) = d.day
         join main_warehouse.dimteams t on m.home_team = t.team_name
         join main_warehouse.dimteams t2 on m.away_team = t2.team_name
         join main_warehouse.dimseason s on m.season = s.season
         join main_warehouse.dimstadium st on m.stadium = st.name
         join main_warehouse.dimmanager m1 on m.home_team = m1.team
         join main_warehouse.dimmanager m2 on m.away_team = m2.team
where not exists(select fm.date_id, fm.home_team_id, fm.away_team_id
                 from factmatches fm
                 where fm.date_id = d.date_id
                   and fm.home_team_id = t.team_id
                   and fm.away_team_id = t2.team_id);

