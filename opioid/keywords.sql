-- #############################################################################
call log('keywords.sql', 'begin');

-- #############################################################################
call log('keywords', 'create table');

drop table if exists keywords, keywords_orig, keywords_str_in_str, keywords_delete;

create table keywords(
 STR   VARCHAR(50) 	NOT NULL
);

call log('keywords.tsv', 'infile');

load    data
local   infile          'keywords.tsv'
into    table            keywords
        fields           terminated by '\t'
        optionally       enclosed by '"' ESCAPED BY ''
        lines            terminated by '\n'
        ignore 1 lines;

show warnings;

-- #############################################################################
call log('keywords', 'keywords_orig');

rename  table keywords to keywords_orig;
create  table keywords
select  distinct trim(STR)  as STR,
        length(trim(STR))   as LEN
from    keywords_orig
order by trim(STR);

call create_index('keywords','STR');
call create_index('keywords','LEN');

-- #############################################################################
call log('keywords_str_in_str', 'keyword1 like %keyword2%');

create table keywords_str_in_str
select
    K1.STR as STR1,
    K2.STR as STR2
from
    keywords K1, keywords K2
where
    K1.STR like concat('%',K2.STR,'%') and
    K1.STR != K2.STR
order by
    length(K1.STR) desc,
    length(K2.STR) asc;

-- #############################################################################
call log('keywords_delete', 'deleting longer pattern');

drop    table if exists keywords_delete;
create  table           keywords_delete
select  distinct STR1, STR2
from    keywords_str_in_str
order by  STR1, STR2;

delete from keywords where STR in (select STR1 from keywords_str_in_str);

-- #############################################################################
call log('keywords.sql', 'done');
