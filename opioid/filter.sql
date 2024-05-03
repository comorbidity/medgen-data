-- ##############################################
call log('filter.sql', 'begin');

-- ##############################################
call log('filter', 'refresh');

drop    table if exists filter;
create  table           filter
select distinct * from  expand_relax
where   RUI     not in (select distinct RUI     from expand)
and     RXCUI1  not in (select distinct RXCUI1  from expand)
and     RXCUI2  not in (select distinct RXCUI2  from expand);

-- ##############################################
call log('filter_tradename', 'refresh');

drop    table if exists filter_tradename;
create  table           filter_tradename
select  distinct        RXCUI1, TTY1, REL, RELA, RXCUI2, TTY2, STR2
from    filter
where   RELA in         ('has_tradename', 'tradename_of')
order by                RELA, REL, RXCUI2, STR2 ;

-- ##############################################
call log('filter_consists', 'refresh');

drop    table if exists filter_consists;
create  table           filter_consists
select  distinct        RXCUI1, TTY1, REL, RELA, RXCUI2, TTY2, STR2
from    filter
where   RELA in         ('consists_of', 'constitutes')
order by RELA, REL, RXCUI2, STR2 ;

-- ##############################################
call log('filter_isa', 'refresh');

drop    table if exists filter_isa;
create  table           filter_isa
select  distinct        RXCUI1, TTY1, REL, RELA, RXCUI2, TTY2, STR2
from    filter
where   RELA in           ('isa', 'inverse_isa')
order by RELA, REL, RXCUI2, STR2 ;

-- ##############################################
call log('filter_ingredient', 'refresh');

drop    table if exists filter_ingredient;
create  table           filter_ingredient
select  distinct        RXCUI1, TTY1, REL, RELA, RXCUI2, TTY2, STR2
from    filter
where RELA in           ('has_ingredient',          'ingredient_of',
                         'has_precise_ingredient',  'precise_ingredient_of',
                         'has_ingredients',         'ingredients_of')
order by RELA, REL, RXCUI2, STR2 ;

-- ##############################################
call log('filter_doseform', 'refresh');

drop    table if exists     filter_doseform;
create  table               filter_doseform
select  distinct            RXCUI1, TTY1, REL, RELA, RXCUI2, TTY2, STR2
from    filter
where   RELA in             ('dose_form_of',     'has_dose_form',
                             'doseformgroup_of', 'has_doseformgroup')
order by REL, RELA, RXCUI2, STR2 ;

-- ##############################################
call log('filter_form', 'refresh');

drop    table if exists filter_form;
create  table           filter_form
select  distinct        RXCUI1, TTY1, REL, RELA, RXCUI2, TTY2, STR2
from    filter
where   RELA in         ('form_of', 'has_form')
order by REL, RELA, RXCUI2, STR2 ;

-- ##############################################
call log('filter_other', 'refresh');

drop    table if exists filter_other;
create  table           filter_other
select  distinct        RXCUI1, TTY1, REL, RELA, RXCUI2, TTY2, STR2
from    filter
where   RELA NOT IN     ('has_tradename',            'tradename_of',
                         'consists_of',              'constitutes',
                         'isa',                      'inverse_isa',
                         'has_ingredient',           'ingredient_of',
                         'has_precise_ingredient',   'precise_ingredient_of',
                         'has_ingredients',          'ingredients_of',
                         'dose_form_of',             'has_dose_form',
                         'doseformgroup_of',         'has_doseformgroup',
                         'form_of',                  'has_form')
order by RELA, REL, RXCUI2, STR2 ;

call create_index('filter_form','RXCUI2');

-- ##############################################
call log('expand.sql', 'done.');