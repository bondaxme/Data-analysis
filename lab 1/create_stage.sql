drop database if exists ad;
create database ad;

use ad;

drop table if exists matches;
drop table if exists stadiums;
drop table if exists teams;

create table matches
(
    id int not null,
    season varchar(9) not null,
    date_time datetime not null,
    home_team varchar(50) not null,
    away_team varchar(50) not null,
    stadium varchar(50) not null,
    home_team_score int not null,
    away_team_score int not null,
    penalty_shoot_out tinyint(1) not null,
    attendance int not null,
    primary key (id)
);

create table stadiums
(
    id int not null,
    name varchar(50) not null,
    city varchar(50) not null,
    country varchar(50) not null,
    capacity int,
    primary key (id)
);

create table teams
(
    id int not null,
    team_name varchar(50),
    country varchar(50),
    home_stadium varchar(50),
    primary key (id)
);