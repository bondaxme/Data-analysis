use main_warehouse;

drop procedure if exists slow_change_stadiums;

delimiter //
create procedure slow_change_stadiums(old_name varchar(50), new_name varchar(50))
begin
    declare old_id int default null;
    declare old_city_id int;
    declare old_capacity varchar(50);

    select stadium_id, city_id, capacity
    into old_id, old_city_id, old_capacity
    from dimstadium
    where name = old_name;
    if old_id is null then
        signal sqlstate '45000' set message_text = 'The old name of the stadium does not exist';
    else
        insert into dimstadium (source_id, city_id, name, capacity, start_date)
            value (old_id, old_city_id, new_name, old_capacity, current_date);

        update dimstadium
        set end_date = CURRENT_DATE
        where stadium_id = old_id;

        update dimteams
        set home_stadium = new_name
        where home_stadium = old_name;
    end if;
end //

delimiter ;

call slow_change_stadiums('Olimpiyskyi', 'Olimpiyskyi Ukraine');
call slow_change_stadiums('Olimpiyskyi Ukraine', 'Olimpiyskyi Kyiv');
