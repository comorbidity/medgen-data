call log('curated', 'begin');
-- ##############################################
call log('curated', 'create table.'); 

drop table if exists curated;
create table curated
(
 RXCUI varchar(8)	NOT NULL,
 STR   TEXT 	NULL
)
;    

call log('curated', 'curated.bsv');

load data local infile 'curated.bsv' 
into table curated
fields terminated by '|'
optionally enclosed by '"' 
ESCAPED BY '' 
lines terminated by '\n' 
ignore 1 lines;

show warnings; 

call create_index('curated','RXCUI');
call create_index('curated','STR(255)'); 

-- -- ##############################################
-- call log('RXNSTY_curated', 'refresh'); 

-- drop table if exists RXNSTY_curated;

-- create table RXNSTY_curated
-- select distinct S.* from RXNSTY as S, curated where S.RXCUI = curated.RXCUI;

-- call create_index('RXNSTY_curated','RXCUI');
-- call create_index('RXNSTY_curated','TUI'); 

-- ##############################################
call log('RXNREL_curated', 'refresh'); 

drop table if exists RXNREL_curated;

create table RXNREL_curated
select distinct R.* from RXNREL as R, curated 
where R.RXCUI1 = curated.RXCUI; 

call create_index('RXNREL_curated','RXCUI1');
call create_index('RXNREL_curated','RXCUI2');
call create_index('RXNREL_curated','REL');
call create_index('RXNREL_curated','RELA');

-- ##############################################
call log('RXNCONSO_curated', 'refresh'); 

drop table if exists RXNCONSO_curated;

create table RXNCONSO_curated
select distinct C.* from RXNCONSO as C, curated 
where C.RXCUI = curated.RXCUI;

call create_index('RXNSTY_curated','RXCUI');
call create_index('RXNSTY_curated','TUI'); 

-- ##############################################
call log('RXNCONSO_curated_rela', 'refresh'); 

drop table if exists RXNCONSO_curated_rela;

create table RXNCONSO_curated_rela
select distinct C.*, R.RXCUI1, R.RXCUI2, R.REL, R.RELA
from RXNCONSO as C, RXNREL_curated as R
where (C.RXCUI = R.RXCUI1) or (C.RXCUI = R.RXCUI2);

call create_index('RXNCONSO_curated_rela','RXCUI');
call create_index('RXNCONSO_curated_rela','RXCUI1'); 
call create_index('RXNCONSO_curated_rela','RXCUI2');
call create_index('RXNCONSO_curated_rela','TTY');
call create_index('RXNCONSO_curated_rela','REL');
call create_index('RXNCONSO_curated_rela','RELA'); 


-- ##############################################
call log('expand1', 'refresh'); 

drop table if exists expand1;

create table expand1
select distinct RXCUI,RXCUI1,RXCUI2,SAB,TTY,REL,RELA,STR from RXNCONSO_curated_rela
where RXCUI=RXCUI2 and RXCUI2 not in (select distinct RXCUI from RXNCONSO_curated); 

call create_index('expand1','RXCUI');
call create_index('expand1','RXCUI1');
call create_index('expand1','RXCUI2'); 
call create_index('expand1','REL');
call create_index('expand1','RELA');
call create_index('expand1','TTY'); 

-- ##############################################
call log('expand1_cui', 'refresh'); 

drop table if exists expand1_cui;
create table expand1_cui
select distinct RXCUI from expand1 order by RXCUI ;

call create_index('expand1_cui','RXCUI');

-- ##############################################
call log('expand1_cui_str', 'refresh'); 

drop table if exists expand1_cui_str;
create table expand1_cui_str
select distinct RXCUI,STR from expand1 order by RXCUI, STR ;

call create_index('expand1_cui_str','RXCUI');

-- ##############################################
call log('expand1_cui_rela_str', 'refresh'); 

drop table if exists expand1_cui_rela_str;
create table expand1_cui_rela_str
select distinct RXCUI,RELA,STR from expand1 order by RXCUI, RELA, STR ;

call create_index('expand1_cui_rela_str','RXCUI');
call create_index('expand1_cui_rela_str','RELA');

-- ##############################################
call log('expand1_cui_rela_cui', 'refresh'); 

drop table if exists expand1_cui_rela_cui;
create table expand1_cui_rela_cui
select distinct RXCUI,RXCUI1,RELA,RXCUI2 from expand1 order by RXCUI,RXCUI1,RELA,RXCUI2 ;

call create_index('expand1_cui_rela_cui','RXCUI');
call create_index('expand1_cui_rela_cui','RELA');

-- ##############################################
call log('expand1_tradename', 'refresh'); 

drop table if exists expand1_tradename;
create table expand1_tradename
select distinct RXCUI,RELA, STR from expand1 where RELA in ('has_tradename', 'tradename_of') order by RXCUI,RELA, STR ;

call create_index('expand1_tradename','RXCUI');

-- ##############################################
call log('expand1_consists', 'refresh'); 

drop table if exists expand1_consists;
create table expand1_consists
select distinct RXCUI,RELA, STR from expand1 where RELA in ('consists_of', 'constitutes') order by RXCUI,RELA, STR ;

call create_index('expand1_consists','RXCUI');

-- ##############################################
call log('expand1_isa', 'refresh'); 

drop table if exists expand1_isa;
create table expand1_isa
select distinct RXCUI,RELA, STR from expand1 where RELA in ('isa', 'inverse_isa') order by RXCUI,RELA, STR ;

call create_index('expand1_isa','RXCUI');

-- ##############################################
call log('expand1_ingredient', 'refresh'); 

drop table if exists expand1_ingredient;
create table expand1_ingredient
select distinct RXCUI,RELA, STR from expand1 where RELA in ('has_ingredient', 'ingredient_of', 'has_precise_ingredient', 'precise_ingredient_of') order by RXCUI,RELA, STR ;

call create_index('expand1_ingredient','RXCUI');

-- ##############################################
call log('expand1_ingredients', 'refresh'); 

drop table if exists expand1_ingredients;
create table expand1_ingredients
select distinct RXCUI,RELA, STR from expand1 where RELA in ('has_ingredients', 'ingredients_of') order by RXCUI,RELA, STR ;

call create_index('expand1_ingredients','RXCUI');

-- ##############################################
call log('expand1_doseform', 'refresh'); 

drop table if exists expand1_doseform;
create table expand1_doseform
select distinct RXCUI,RELA, STR from expand1 where RELA in ('dose_form_of', 'has_dose_form', 'doseformgroup_of', 'has_doseformgroup') order by RXCUI,RELA, STR ;

call create_index('expand1_doseform ','RXCUI');

-- ##############################################
call log('expand1_form', 'refresh'); 

drop table if exists expand1_form;
create table expand1_form
select distinct RXCUI,RELA, STR from expand1 where RELA in ('form_of', 'has_form') order by RXCUI,RELA, STR ;

call create_index('expand1_doseform ','RXCUI');


-- ##############################################
call log('curated', 'done.');



-- ./export_bsv.sh rxnorm expand1
