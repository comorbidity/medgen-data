CREATE DATABASE IF NOT EXISTS medgen CHARACTER SET utf8 COLLATE utf8_unicode_ci;

use medgen;

-- http://www.jamediasolutions.com/blog/deterministic-no-sql-or-reads-sql-data-in-its-declaration.html
SET GLOBAL log_bin_trust_function_creators = 1;

-- MySQL application logging procedures 
-- use DATASET; 

create table if not exists README
(
   entity_topic  varchar(50)   default '',
   entity_type   varchar(50)   default '',
   entity_name   varchar(50)   default '',
   example       varchar(50)   default '',
   description   varchar(100)  default ''
)
ENGINE=InnoDB DEFAULT CHARSET=utf8; 

insert into README values
('logging', 'table',     'log',   'select * from log', 'application log'),
('logging', 'procedure', 'log',   'call log (tablename, message)', 'write to application log'),
('logging', 'procedure', 'head',  'call head',  'print head of log'),
('logging', 'procedure', 'tail',  'call tail',  'print tail of log'),
('logging', 'procedure', 'etime', 'call etime', 'print elapsed time between log events');

insert into README values
('dataset', 'procedure', 'DATASET',   'call DATASET(my_dataset)', 'stamp log messages with my_dataset'); 

insert into README values
('user_prefs', 'variable',  '@LOG_LINES',  'select 10 into @LOG_LINES', 'how many log rows do you want to see with (head|tail)'),
('user_prefs', 'variable',  '@LOG_LEVEL',  'select 1 into @LOG_LEVEL',            'turn on printing log to console'); 


drop procedure if exists README;
delimiter //
create procedure README()
begin
  select * from README;
end//
delimiter ;

-- drop procedure if exists README_ENTRY;
-- delimiter //
-- create procedure README()
-- begin
--   select * from README;
-- end//
-- delimiter ;


drop procedure if exists LOG_LINES;
delimiter //
create procedure LOG_LINES(numlines int)
begin
     select numlines into @LOG_LINES; 
end//
delimiter ;

drop procedure if exists user_prefs;
delimiter //
create procedure user_prefs()
begin

   if @DATASET is null then
     select DATASET from log order by idx desc limit 1 into @DATASET;
   end if;
   -- select @DATASET; 

   if @LOG_LINES is null then
     select 50 into @LOG_LINES; 
   end if;
   -- select @LOG_LINES; 

   if @LOG_LEVEL is null then
     select 1 into @LOG_LEVEL; 
   end if;
   -- select @LOG_LEVEL; 

end//
delimiter ;

drop table if exists log;
CREATE TABLE log
(
  event_time   timestamp    default now(),
  entity_name  varchar(100) NOT NULL,
  message      varchar(100) NULL,
  DATASET      varchar(30)  null
)
Engine InnoDB;

ALTER TABLE log add idx smallint UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY;

drop procedure if exists log;
delimiter //
create procedure log(log_entity_name varchar(100), log_message varchar(100))
begin
   call user_prefs; 
   insert into log
   (DATASET, entity_name,     message) select
   @DATASET, log_entity_name, log_message;

   if @LOG_LEVEL > 0 then
    select concat(DATASET, ',', entity_name, ',',message) as '' from log order by idx desc limit 1;
   end if;
end//
delimiter ;

call log('log', 'table created');
call log('log', 'procedure created');

drop procedure if exists DATASET;
delimiter //
create procedure DATASET(dataset varchar(30))
begin
     select dataset into @DATASET; 
     call LOG('DATASET',@DATASET); 
end//

delimiter ;

-- call log('log_select', 'http://forums.mysql.com/read.php?98,126379,133966#msg-133966');

drop function if exists log_select;

delimiter //
create function log_select(asc_or_desc varchar(4))
returns varchar(1000) 
	return concat('select log.* from (', 'select * from log order by idx ',asc_or_desc, ' LIMIT ', @LOG_LINES, ') as log order by idx asc');// 

delimiter ;


drop procedure if exists tail;

delimiter //
create procedure tail()
begin
	call user_prefs; 
	select log_select('desc') into @tail; 
	prepare stmt from @tail; 
	execute stmt;
end//
delimiter ;

call log('tail', 'procedure created');

drop procedure if exists head;
delimiter //
create procedure head()
begin
	call user_prefs; 
	select log_select('asc') into @tail; 
	prepare stmt from @tail; 
	execute stmt;
end//
delimiter ;

call log('head', 'procedure created');  


drop procedure if exists etime;
delimiter //
create procedure etime()
begin
  select l1.idx, l1.event_time as 'event_time(start)', l1.entity_name, l1.message, 
  	 	 l2.event_time as 'event_time(end)',
  UNIX_TIMESTAMP(l1.event_time)-UNIX_TIMESTAMP(l2.event_time) as etime
  from log l1, log l2
  where l1.idx = l2.idx+1
  order by l1.idx asc;
end//
delimiter ;

call log('etime', 'procedure created');

drop procedure if exists last_loaded;

delimiter //
create procedure last_loaded()
begin
	select event_time as ID from log
	where entity_name = 'load_database.sh' and message = 'done'
	order by idx desc limit 1;
end//
delimiter ; 

call log('last_loaded', 'procedure created');  


drop procedure if exists last_loaded_comparable;

delimiter //
create procedure last_loaded_comparable()
begin
	select cast(event_time as unsigned) as ID from log
	where entity_name = 'load_database.sh' and message = 'done'
	order by idx desc limit 1;
end//
delimiter ; 

call log('regex_replace', 'create function'); 

drop function if exists regex_replace;

delimiter //
CREATE FUNCTION  `regex_replace`(pattern VARCHAR(1000),replacement VARCHAR(1000),original VARCHAR(1000))

RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN 
 DECLARE temp VARCHAR(1000); 
 DECLARE ch VARCHAR(1); 
 DECLARE i INT;
 SET i = 1;
 SET temp = '';
 IF original REGEXP pattern THEN 
  loop_label: LOOP 
   IF i>CHAR_LENGTH(original) THEN
    LEAVE loop_label;  
   END IF;
   SET ch = SUBSTRING(original,i,1);
   IF NOT ch REGEXP pattern THEN
    SET temp = CONCAT(temp,ch);
   ELSE
    SET temp = CONCAT(temp,replacement);
   END IF;
   SET i=i+1;
  END LOOP;
 ELSE
  SET temp = original;
 END IF;
 RETURN temp;
end//

delimiter ; 

call log('regex_replace', 'function created'); 

call DATASET( DATABASE() ); 
insert into README values
('memory',   'procedure',  'mem',      'call mem', 'get schema +memory usage'),
('process',  'procedure',  'ps',       'call ps',  'show current sql process'),
('process',  'procedure',  'freq',     'call freq(tablename,colname)',  'show frequency of a term'); 

drop procedure if exists mem;
delimiter //
create procedure mem()
begin
  select
  table_schema,
  ENGINE,
  TABLE_NAME,
  TABLE_ROWS,
  concat( round( TABLE_ROWS / ( 1000 *1000 ) , 2 ) , '' )  million,
  concat( round( data_length / ( 1024 *1024 ) , 2 ) , 'M' )  data_MB,
  concat( round( index_length / ( 1024 *1024 ) , 2 ) , 'M' ) index_MB, 
  TABLE_COLLATION
  from
  information_schema.TABLES
  where
  TABLE_SCHEMA = DATABASE()
  order by
  table_schema, engine, table_name;
end//
delimiter ;

-- alias for "call mem" 
drop procedure if exists info;
delimiter //
create procedure info()
begin
  call mem; 
end//
delimiter ;

drop procedure if exists ps;
delimiter //
create procedure ps()
begin
  select * from information_schema.processlist
  where
  information_schema.processlist.DB=DATABASE() and 
  information_schema.processlist.INFO not like '%information_schema.processlist%';
end//
delimiter ;

drop procedure if exists backup;

delimiter //
create procedure backup( tablename varchar(100))
begin
	call log(tablename, 'backup');
	
	select concat('drop table if exists bak_', tablename) into @sql_bak; 
	prepare stmt from @sql_bak;  execute stmt; 
	
	select concat('alter table ', tablename, ' rename to ', 'bak_', tablename) into @sql_bak; 
	prepare stmt from @sql_bak;  execute stmt; 
end//
delimiter ;

drop procedure if exists drop_table;

delimiter //
create procedure drop_table( tablename varchar(100))
begin
	call log(tablename, 'drop_table');
	
	select concat('drop table if exists ', tablename) into @sql_bak; 
	prepare stmt from @sql_bak;  execute stmt; 	
end//
delimiter ;

drop procedure if exists create_like;

delimiter //
create procedure create_like( tablename varchar(100), template varchar(100))
begin
	call drop_table(tablename); 
	call log(tablename, 'create_like');
	call log(tablename, template);
		
	select concat('create table ', tablename, ' like ', template) into @sql_bak; 
	prepare stmt from @sql_bak;  execute stmt; 
end//
delimiter ;



drop procedure if exists total;

delimiter //
create procedure total( tablename varchar(100))
begin
	select concat('select count(*) into @total from ', tablename) into @sql_total; 
	prepare stmt1 from @sql_total;   execute stmt1; select tablename, @total; 
end//
delimiter ;

drop procedure if exists freq;  

delimiter //
create procedure freq( tablename varchar(100), colname varchar(100))
begin
	call total(tablename); 

	select concat('select ',  colname, ',' ,'count(*) as cnt, (count(*)/@total)*100 as prct', ' from ', tablename, ' group by ' , colname, ' order by cnt desc') into @sql_cnt; 
	select @sql_cnt; 	

	prepare stmt from @sql_cnt;   execute stmt;
end//
delimiter ;

drop procedure if exists freqtop;  

delimiter //
create procedure freqtop( tablename varchar(100), colname varchar(100), top int)
begin
	call total(tablename); 

	select concat('select ',  colname, ',' ,'count(*) as cnt, (count(*)/@total)*100 as prct', ' from ', tablename, ' group by ' , colname, ' order by cnt desc limit ', top) into @sql_cnt; 
	select @sql_cnt; 	

	prepare stmt from @sql_cnt;   execute stmt;
end//
delimiter ;

drop procedure if exists freqsab;

delimiter //
create procedure freqsab( tablename varchar(100))
begin
	call freq(tablename, 'SAB');
end//
delimiter ;

drop procedure if exists freqtty;

delimiter //
create procedure freqtty( tablename varchar(100))
begin
	call freq(tablename, 'TTY');
end//
delimiter ;

drop procedure if exists freqstr;

delimiter //
create procedure freqstr( tablename varchar(100))
begin
	call freqtop(tablename, 'STR', 100);
end//
delimiter ;

drop procedure if exists freqpref;

delimiter //
create procedure freqpref( tablename varchar(100))
begin
	call freqtop(tablename, 'PREF', 100);
end//
delimiter ;


drop procedure if exists freqtui;

delimiter //
create procedure freqtui( tablename varchar(100))
begin
	call total(tablename); 
	
	select concat('select S.TUI, S.STY, count(*) as cnt, (count(*)/@total)*100 as prct', ' from ', tablename, ' as T, MRSTY_freq as S where T.TUI=S.TUI group by S.TUI,S.STY order by cnt desc') into @sql_cnt; 
	select @sql_cnt; 	

	prepare stmt2 from @sql_cnt;   execute stmt2;
end//
delimiter ;

drop procedure if exists freqtui_where;

delimiter //
create procedure freqtui_where( tablename varchar(100), wheresql varchar(200))
begin
	select concat('drop temporary table if exists ', tablename, '_where') into @sql_uniq;
	prepare stmt from @sql_uniq; execute stmt;

	select concat('create temporary table ', tablename, '_where select * from ', tablename, ' where ', wheresql) into @sql_uniq;
	prepare stmt from @sql_uniq; execute stmt;

	select concat(tablename, '_where') into @temp;
	call freqtui(@temp); 
end//
delimiter ;



drop procedure if exists freqdist;  
delimiter //
create procedure freqdist( tablename varchar(100), colname varchar(100), coldistinct varchar(100))
begin
	select concat('select ',  colname, ',' ,'count(distinct ', coldistinct,' ) as cnt', ' from ', tablename, ' group by ' , colname, ' order by cnt desc') into @sql_cnt; 
	select @sql_cnt; 	

	prepare stmt from @sql_cnt;   execute stmt;
end//
delimiter ;

drop procedure if exists uniq;
delimiter //
create procedure uniq(tablename varchar(100) )
begin
	call log(tablename, 'uniq');
	call utf8_unicode(tablename); 

	call total(tablename);

	select concat('drop table if exists ', tablename, '_uniq') into @sql_uniq;
	prepare stmt from @sql_uniq; execute stmt;

	select concat('create table ', tablename, '_uniq like ', tablename) into @sql_uniq;
	prepare stmt from @sql_uniq; execute stmt;

	select concat('insert into ', tablename, '_uniq select distinct * from ', tablename) into @sql_uniq;
	prepare stmt from @sql_uniq; execute stmt;

	select concat('drop table ', tablename) into @sql_uniq;
	prepare stmt from @sql_uniq; execute stmt;

	select concat('alter table ', tablename, '_uniq rename to ', tablename) into @sql_uniq;
	prepare stmt from @sql_uniq; execute stmt;

	call total(tablename);
end//
delimiter ;


drop procedure if exists create_index;
delimiter //
create procedure create_index( tablename varchar(100), indexcols varchar(100) )
begin
	call log( concat(tablename,':', indexcols), 'index begin');

	select concat('alter table ', tablename, ' add  index (', indexcols, ')') into @idx; 
	prepare stmt from @idx; execute stmt;

	select concat('show index from ', tablename) into @show; 
	prepare stmt from @show; execute stmt;
	
	call log( concat(tablename,':', indexcols), 'index done');
end//
delimiter ;

drop procedure if exists utf8_unicode;
delimiter //
create procedure utf8_unicode( tablename varchar(100))
begin
	select concat('alter table ', tablename, ' convert to CHARSET utf8 collate utf8_unicode_ci') into @idx; 
	prepare stmt from @idx; execute stmt;
	
	call log(tablename, 'utf8_unicode_ci');
end//
delimiter ;

drop procedure if exists less20; 
delimiter // 
create procedure less20(tablename varchar(100)) 
begin 
      select concat('select * from ', tablename, ' limit 20') into @stmt; 
      prepare stmt from @stmt; 
      execute stmt; 
end//
delimiter ; 


drop procedure if exists trimstr;
delimiter //
create procedure trimstr( tablename varchar(100), shorter int, longer int)
begin
	call log(tablename, 'xxx');
	call total(tablename);

	select concat('drop table if exists xxx_', tablename) into @sql_xxx;
	prepare stmt from @sql_xxx; execute stmt;

	select concat('create table xxx_', tablename, ' like ', tablename) into @sql_xxx;
	prepare stmt from @sql_xxx; execute stmt;

	select concat('insert into xxx_', tablename, ' select distinct * from ', tablename, ' where length(STR)<', shorter, ' OR length(STR) > ', longer, ' order by length(STR), STR' ) into @sql_xxx;
	prepare stmt from @sql_xxx; execute stmt;

	select concat('delete from ', tablename, ' where length(STR)<', shorter, ' OR length(STR) > ', longer) into @sql_xxx;
	prepare stmt from @sql_xxx; execute stmt;

	call total(tablename);

	select concat('select * from xxx_', tablename, ' limit 50') into @sql_xxx;
	prepare stmt from @sql_xxx; execute stmt;
	
end//
delimiter ;
