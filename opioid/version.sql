-- ##############################################
call log('version.sql', 'create table');

drop   table if exists version;
create table version
(
 curated    varchar(50)  NOT NULL,
 status     varchar(300) NOT NULL,
 stamp      timestamp    default CURRENT_TIMESTAMP
);

-- ##############################################
call log('version.sql', 'create procedure');

drop procedure if exists version;
delimiter //
create procedure version(curated varchar(50), status varchar(300))
begin
    insert into version (curated, status) select curated, status;
    select curated, status, stamp from version order by stamp desc limit 1;
end//
delimiter ;

-- ##############################################
call version('RESET', 'RESET');

-- ##############################################
call log('version.sql', 'done');

