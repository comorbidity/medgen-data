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

drop procedure if exists utf8_general;
delimiter //
create procedure utf8_general( tablename varchar(100))
begin
	select concat('alter table ', tablename, ' convert to CHARSET utf8 collate utf8_general_ci') into @idx; 
	prepare stmt from @idx; execute stmt;
	
	call log(tablename, 'utf8_general_ci');
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
