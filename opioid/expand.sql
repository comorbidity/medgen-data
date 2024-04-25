-- ##############################################
call log('expand.sql', 'begin');

drop table if exists expand;

create table expand
select distinct RXCUI,RXCUI1,RXCUI2,SAB,TTY,REL,RELA,STR from RXNCONSO_curated_rela
where RXCUI=RXCUI2 and RXCUI2 not in (select distinct RXCUI from RXNCONSO_curated);

call create_index('expand','RXCUI');
call create_index('expand','RXCUI1');
call create_index('expand','RXCUI2');
-- call create_index('expand','REL');
-- call create_index('expand','RELA');
-- call create_index('expand','TTY');

-- ##############################################
call log('expand_cui', 'refresh');

drop table if exists expand_cui;
create table expand_cui
select distinct RXCUI from expand order by RXCUI ;

call create_index('expand_cui','RXCUI');

-- ##############################################
call log('expand_cui_str', 'refresh');

drop table if exists expand_cui_str;
create table expand_cui_str
select distinct RXCUI,STR from expand order by RXCUI, STR ;

call create_index('expand_cui_str','RXCUI');

-- ##############################################
call log('expand_cui_str_rela', 'refresh');

drop table if exists expand_cui_str_rela;
create table expand_cui_str_rela
select distinct RXCUI,RELA,STR from expand order by RXCUI, RELA, STR ;

call create_index('expand_cui_str_rela','RXCUI');

-- ##############################################
call log('expand_cui_rela_cui', 'refresh');

drop table if exists expand_cui_rela_cui;
create table expand_cui_rela_cui
select distinct RXCUI,RXCUI1,RELA,RXCUI2 from expand order by RXCUI,RXCUI1,RELA,RXCUI2 ;

call create_index('expand_cui_rela_cui','RXCUI');

-- ##############################################
call log('expand_tradename', 'refresh');

drop table if exists expand_tradename;
create table expand_tradename
select distinct RXCUI,RELA, STR from expand where RELA in ('has_tradename', 'tradename_of')
order by RXCUI,RELA, STR ;

call create_index('expand_tradename','RXCUI');

-- ##############################################
call log('expand_consists', 'refresh');

drop table if exists expand_consists;
create table expand_consists
select distinct RXCUI,RELA, STR from expand where RELA in ('consists_of', 'constitutes')
order by RXCUI,RELA, STR ;

call create_index('expand_consists','RXCUI');

-- ##############################################
call log('expand_isa', 'refresh');

drop table if exists expand_isa;
create table expand_isa
select distinct RXCUI,RELA, STR from expand where RELA in ('isa', 'inverse_isa')
order by RXCUI,RELA, STR ;

call create_index('expand_isa','RXCUI');

-- ##############################################
call log('expand_ingredient', 'refresh');

drop table if exists expand_ingredient;
create table expand_ingredient
select distinct RXCUI,RELA, STR from expand where RELA in (
    'has_ingredient', 'ingredient_of',
    'has_precise_ingredient', 'precise_ingredient_of',
    'has_ingredients', 'ingredients_of')
order by RXCUI,RELA, STR ;

call create_index('expand_ingredient','RXCUI');

-- ##############################################
call log('expand_doseform', 'refresh');

drop table if exists expand_doseform;
create table expand_doseform
select distinct RXCUI,RELA, STR from expand where RELA in (
    'dose_form_of', 'has_dose_form',
    'doseformgroup_of', 'has_doseformgroup')
order by RXCUI,RELA, STR ;

call create_index('expand_doseform ','RXCUI');

-- ##############################################
call log('expand_form', 'refresh');

drop table if exists expand_form;
create table expand_form
select distinct RXCUI,RELA, STR from expand where RELA in ('form_of', 'has_form')
order by RXCUI,RELA, STR ;

call create_index('expand_form ','RXCUI');

-- ##############################################
call log('expand.sql', 'done.');