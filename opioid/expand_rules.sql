-- ##############################################
call log('expand_rules.sql', 'create table');

drop    table if exists expand_rules;
create  table           expand_rules
(
    TTY1    varchar(40)  not null,
    RELA    varchar(100) not null,
    TTY2    varchar(40)  not null,
    rule    varchar(20)  not null
);

call log('infile', 'expand_rules.tsv');

load    data
local   infile     'expand_rules.tsv'
into    table       expand_rules
        fields      terminated by '\t'
        optionally  enclosed by '"' ESCAPED BY ''
        lines       terminated by '\n'
        ignore 1 lines;

show warnings;

alter table expand_rules add column include boolean default NULL;
update expand_rules set include = TRUE  where lower(rule) = 'yes';
update expand_rules set include = FALSE where lower(rule) = 'no';

drop    table if exists expand_rules_readme;
create  table           expand_rules_readme
select  E.*,
        U1.TTY_STR as TTY1_STR,
        U2.TTY_STR as TTY2_STR
from    expand_rules E,
        UMLS_TTY U1,
        UMLS_TTY U2
where   E.TTY1 = U1.TTY
and     E.TTY2 = U2.TTY;

call create_index('expand_rules','include');
call create_index('expand_rules','TTY1');
call create_index('expand_rules','TTY2');
call create_index('expand_rules','RELA');
call create_index('expand_rules','RELA, TTY1, TTY2');

-- ##############################################
call log('expand_rules.sql', 'done');
