drop database if exists main_warehouse;
create database main_warehouse;

use main_warehouse;

drop table if exists dimStadium;
drop table if exists dimLocation;
drop table if exists dimManager;
drop table if exists dimSeason;
drop table if exists dimDate;
drop table if exists dimTeams;
drop table if exists factMatches;

create table dimCountry
(
    country_id int not null auto_increment,
    country    varchar(40),
    primary key (country_id)
);

create table dimCity
(
    city_id    int not null auto_increment,
    country_id int not null,
    city       varchar(40),
    primary key (city_id),
    foreign key (country_id) references dimCountry (country_id)
);

create table dimStadium
(
    stadium_id int not null auto_increment,
    source_id  int  default null,
    city_id    int not null,
    name       varchar(50),
    capacity   varchar(50),
    start_date date default null,
    end_date   date default null,
    primary key (stadium_id),
    foreign key (city_id) references dimCity (city_id)
);

create table dimDate
(
    date_id int not null auto_increment,
    year    int,
    month   int,
    day     int,
    primary key (date_id)
);

create table dimManager
(
    manager_id  int not null auto_increment,
    date_id     int not null,
    first_name  varchar(50),
    last_name   varchar(50),
    nationality varchar(40),
    team        varchar(40),
    primary key (manager_id),
    foreign key (date_id) references dimDate (date_id)
);

create table dimSeason
(
    season_id int not null auto_increment,
    season    varchar(9),
    primary key (season_id)
);

create table dimTeams
(
    team_id      int not null,
    country_id   int not null,
    team_name    varchar(50),
    home_stadium varchar(40),
    primary key (team_id),
    foreign key (country_id) references dimcountry (country_id)
);

create table factMatches
(
    match_id        int not null auto_increment,
    date_id         int,
    home_team_id    int,
    away_team_id    int,
    season_id       int,
    home_manager_id int,
    away_manager_id int,
    stadium_id      int,
    home_team_score int,
    away_team_score int,
    isPenalty       tinyint(1),
    attendance      int,
    primary key (match_id),
    foreign key (date_id) references dimDate (date_id),
    foreign key (home_team_id) references dimTeams (team_id),
    foreign key (away_team_id) references dimTeams (team_id),
    foreign key (season_id) references dimSeason (season_id),
    foreign key (home_manager_id) references dimManager (manager_id),
    foreign key (away_manager_id) references dimManager (manager_id),
    foreign key (stadium_id) references dimStadium (stadium_id)
);
