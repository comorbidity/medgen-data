-- ##############################################
call log('expand.sql', 'begin');

-- ##############################################
call log('expand_relax', 'refresh');

drop    table if exists expand_relax;
create  table           expand_relax
select  distinct
        C1.RXCUI    as RXCUI1,
        C2.RXCUI    as RXCUI2,
        C1.TTY      as TTY1,
        C2.TTY      as TTY2,
        C1.RUI,
        C1.REL,
        C1.RELA,
        C1.STR      as STR1,
        C2.keyword_str,
        C2.keyword_len,
        C2.STR      as STR2
from    RXNCONSO_curated_rela C1, all_rxcui_str.RXNCONSO_curated C2
where   C1.RXCUI2 = C2.RXCUI
and     C1.RXCUI2 NOT in (select distinct RXCUI from RXNCONSO_curated);

call create_index('expand_relax','RXCUI1');
call create_index('expand_relax','RXCUI2');
call create_index('expand_relax','REL');
call create_index('expand_relax','RELA');
call create_index('expand_relax','TTY1');
call create_index('expand_relax','TTY2');

-- ##############################################
call log('expand_strict', 'refresh');

drop    table if exists expand_strict;
create  table           expand_strict
select  distinct        relax.*
from    expand_relax as relax,
        expand_rules as rules
where   relax.REL not in ('RB', 'PAR')
and     rules.include is TRUE
and     rules.TTY1 = relax.TTY1
and     rules.TTY2 = relax.TTY2
and     rules.RELA = relax.RELA;


-- ##############################################
call log('expand_keywords', 'refresh');

drop    table if exists expand_keywords;
create  table           expand_keywords
select  distinct        relax.*
from    expand_relax as relax,
        expand_rules as rules
where   rules.include is NULL
and     relax.REL not in ('RB', 'PAR')
and     relax.keyword_len >1
and     rules.TTY1 = relax.TTY1
and     rules.TTY2 = relax.TTY2
and     rules.RELA = relax.RELA;

-- ##############################################
call log('expand', 'refresh');

drop    table if exists expand;
create  table           expand
select  distinct * from expand_strict
        UNION
select distinct * from expand_keywords;

-- ##############################################
call log('expand_rxcui_str', 'refresh');

drop    table if exists expand_keywords_rxcui_str;
create  table           expand_keywords_rxcui_str
select  distinct        RXCUI2, STR2
from    expand_keywords
order by RXCUI2, STR2;

drop    table if exists expand_strict_rxcui_str;
create  table           expand_strict_rxcui_str
select  distinct        RXCUI2, STR2
from    expand_strict
order by RXCUI2, STR2;

drop    table if exists expand_rxcui_str;
create  table           expand_rxcui_str
select  distinct        RXCUI2, STR2 from  expand_strict_rxcui_str
UNION
select  distinct        RXCUI2, STR2 from  expand_keywords_rxcui_str
order by RXCUI2, STR2 ;

call create_index('expand_rxcui_str','RXCUI2');
-- ##############################################
call log('expand.sql', 'done.');