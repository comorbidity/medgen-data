-- ##############################################
call log('expand.sql', 'begin');

drop    table if exists expand;
create  table expand
select  distinct
        C1.RXCUI,   C2.RXCUI    as RXCUI2,
        C1.TTY,     C2.TTY      as TTY2,
        C1.REL,
        C1.RELA,
        C1.STR,     C2.STR      as STR2
from    RXNCONSO_curated_rela C1, rxnorm.RXNCONSO C2
where   C1.RXCUI2 = C2.RXCUI
and     C1.RXCUI2 NOT in (select distinct RXCUI from RXNCONSO_curated);

call create_index('expand','RXCUI');
call create_index('expand','RXCUI2');
call create_index('expand','REL');
call create_index('expand','RELA');
call create_index('expand','TTY');

-- ##############################################
call log('expand_cui2_str2', 'refresh');

drop    table if exists expand_cui2_str2;
create  table           expand_cui2_str2
select  distinct        RXCUI2, STR2
from    expand
order by RXCUI2, STR2 ;

call create_index('expand_cui2_str2','RXCUI2');

-- ##############################################
call log('expand_tradename', 'refresh');

drop    table if exists expand_tradename;
create  table           expand_tradename
select  distinct        RXCUI, RELA, RXCUI2, STR2
from    expand
where   RELA in         ('has_tradename', 'tradename_of')
order by                RELA, RXCUI2, STR2 ;

call create_index('expand_tradename','RXCUI2');

-- ##############################################
call log('expand_tradename_tty', 'refresh');

drop    table if exists expand_tradename_tty;
create  table           expand_tradename_tty
select  distinct        RXCUI, TTY, RELA, RXCUI2, TTY2, STR2
from    expand
where   RELA in         ('has_tradename', 'tradename_of')
order by                RELA, RXCUI2, STR2 ;

call create_index('expand_tradename_tty','RXCUI2');

-- ##############################################
call log('expand_consists', 'refresh');

drop    table if exists expand_consists;
create  table           expand_consists
select  distinct        RXCUI, RELA, RXCUI2, STR2
from    expand
where   RELA in         ('consists_of', 'constitutes')
order by RELA, RXCUI2, STR2 ;

call create_index('expand_consists','RXCUI2');

-- ##############################################
call log('expand_consists_tty', 'refresh');

drop    table if exists expand_consists_tty;
create  table           expand_consists_tty
select  distinct        RXCUI, TTY, RELA, RXCUI2, TTY2, STR2
from    expand
where   RELA in         ('consists_of', 'constitutes')
order by RELA, RXCUI2, STR2 ;

call create_index('expand_consists_tty','RXCUI2');

-- ##############################################
call log('expand_isa', 'refresh');

drop    table if exists expand_isa;
create  table           expand_isa
select  distinct        RXCUI, RELA, RXCUI2, STR2
from    expand
where RELA in           ('isa', 'inverse_isa')
order by RELA, RXCUI2, STR2 ;

call create_index('expand_isa','RXCUI2');

-- ##############################################
call log('expand_isa_tty', 'refresh');

drop    table if exists expand_isa_tty;
create  table           expand_isa_tty
select  distinct        RXCUI, TTY, RELA, RXCUI2, TTY2, STR2
from    expand
where RELA in           ('isa', 'inverse_isa')
order by RELA, RXCUI2, STR2 ;

call create_index('expand_isa_tty','RXCUI2');

-- ##############################################
call log('expand_ingredient', 'refresh');

drop    table if exists expand_ingredient;
create  table           expand_ingredient
select  distinct        RXCUI, RELA, RXCUI2, STR2
from expand
where RELA in           ('has_ingredient',          'ingredient_of',
                         'has_precise_ingredient',  'precise_ingredient_of',
                         'has_ingredients',         'ingredients_of')
order by RELA, RXCUI2, STR2 ;

call create_index('expand_ingredient','RXCUI2');

-- ##############################################
call log('expand_ingredient_tty', 'refresh');

drop    table if exists expand_ingredient_tty;
create  table           expand_ingredient_tty
select  distinct        RXCUI, TTY, RELA, RXCUI2, TTY2, STR2
from expand
where RELA in           ('has_ingredient',          'ingredient_of',
                         'has_precise_ingredient',  'precise_ingredient_of',
                         'has_ingredients',         'ingredients_of')
order by RELA, RXCUI2, STR2 ;

call create_index('expand_ingredient_tty','RXCUI2');

-- ##############################################
call log('expand_doseform', 'refresh');

drop    table if exists     expand_doseform;
create  table               expand_doseform
select  distinct            RXCUI, RELA, RXCUI2, STR2
from    expand
where   RELA in             ('dose_form_of',     'has_dose_form',
                             'doseformgroup_of', 'has_doseformgroup')
order by RELA, RXCUI2, STR2 ;

call create_index('expand_doseform ','RXCUI2');

-- ##############################################
call log('expand_doseform_tty', 'refresh');

drop    table if exists     expand_doseform_tty;
create  table               expand_doseform_tty
select  distinct            RXCUI, TTY, RELA, RXCUI2, TTY2, STR2
from    expand
where   RELA in             ('dose_form_of',     'has_dose_form',
                             'doseformgroup_of', 'has_doseformgroup')
order by RELA, RXCUI2, STR2 ;

call create_index('expand_doseform_tty','RXCUI2');

-- ##############################################
call log('expand_form', 'refresh');

drop    table if exists expand_form;
create  table           expand_form
select  distinct        RXCUI, RELA, RXCUI2, STR2
from    expand
where   RELA in         ('form_of', 'has_form')
order by RELA, RXCUI2, STR2 ;

call create_index('expand_form ','RXCUI2');

-- ##############################################
call log('expand_form_tty', 'refresh');

drop    table if exists expand_form_tty;
create  table           expand_form_tty
select  distinct        RXCUI, TTY, RELA, RXCUI2, TTY2, STR2
from    expand
where   RELA in         ('form_of', 'has_form')
order by RELA, RXCUI2, STR2 ;

call create_index('expand_form_tty','RXCUI2');

-- ##############################################
call log('expand_other_tty', 'refresh');

drop    table if exists expand_other_tty;
create  table           expand_other_tty
select  distinct        RXCUI, TTY, RELA, RXCUI2, TTY2, STR2
from    expand
where   RELA NOT IN     ('has_tradename',            'tradename_of',
                         'consists_of',              'constitutes',
                         'isa',                      'inverse_isa',
                         'has_ingredient',           'ingredient_of',
                         'has_precise_ingredient',   'precise_ingredient_of',
                         'has_ingredients',          'ingredients_of',
                         'dose_form_of',             'has_dose_form',
                         'doseformgroup_of',         'has_doseformgroup',
                         'form_of',                  'has_form')
order by RELA, RXCUI2, STR2 ;

call create_index('expand_form_tty','RXCUI2');


-- ##############################################
call log('expand.sql', 'done.');