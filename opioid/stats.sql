-- ##############################################
call log('stats.sql', 'begin');

-- ############################################## (curated)
-- SAB RXNORM vocab summary
drop    table if exists stats_sab;
create  table           stats_sab
select  count(*) as cnt_star,
        count(distinct RXCUI) as cnt_rxcui,
        SAB
from    RXNCONSO_curated
group by SAB
order by cnt_rxcui desc;

-- ############################################## (curated)
-- STR matches %keyword%
drop    table if exists stats_keywords;
create  table           stats_keywords
select  count(*) as cnt_star,
        count(distinct RXCUI) as cnt_rxcui,
        keyword_str
from    RXNCONSO_curated
group by keyword_str
order by cnt_rxcui desc;

-- ############################################## (curated)
-- TTY TermType
drop    table if exists stats_tty;
create  table           stats_tty as
select  count(*) as cnt_star,
        count(distinct RXCUI) as cnt_rxcui,
        U.TTY,
        U.TTY_STR
from    RXNCONSO_curated C,
        umls_tty U
where   C.tty=U.tty
group by U.TTY, U.TTY_STR
order by cnt_rxcui desc;

-- ############################################## (curated)
-- TUI SemanticType
drop    table if exists stats_tui;
create  table           stats_tui as
select  count(*) as cnt_star,
        count(distinct RXCUI) as cnt_rxcui,
        U.TUI,
        U.TUI_STR
from    RXNSTY_curated C,
        umls_tui U
where   C.TUI=U.TUI
group by U.TUI,U.TUI_STR
order by cnt_rxcui desc;

-- ############################################## (expand)
--
drop    table if exists stats_expand;
create  table           stats_expand as
select  count(*)                as cnt_star,
        count(distinct RXCUI1)   as cnt_rxcui1,
        count(distinct RXCUI2)  as cnt_rxcui2
from    expand;

-- ############################################## (expand)
-- REL "broader", "narrower", "other"
drop    table if exists stats_expand_rel;
create  table           stats_expand_rel as
select  count(*)                as cnt_star,
        count(distinct RXCUI1)  as cnt_rxcui1,
        count(distinct RXCUI2)  as cnt_rxcui2,
        U.REL, U.REL_STR
from    expand E, umls_rel U
where   E.REL=U.REL
group by U.REL, U.REL_STR
order by cnt_rxcui1 desc, cnt_rxcui2 desc;

-- ############################################## (expand)
-- REL Attributes
drop    table if exists stats_expand_rela;
create  table           stats_expand_rela as
select  count(*)                as cnt_star,
        count(distinct RXCUI1)  as cnt_rxcui1,
        count(distinct RXCUI2)  as cnt_rxcui2,
        RELA
from    expand E
group by RELA
order by cnt_rxcui1 desc, cnt_rxcui2 desc;

-- ############################################## (expand)
-- RELA Attributes TTY TermTypes
drop    table if exists stats_expand_rel_tty;
create  table           stats_expand_rel_tty as
select  count(*) as cnt_star,
        count(distinct RXCUI1)   as cnt_rxcui1,
        count(distinct RXCUI2)  as cnt_rxcui2,
        REL,
        TTY1,
        TTY2
from    expand E
group by REL, TTY1, TTY2
order by cnt_rxcui1 desc, cnt_rxcui2 desc;

-- ############################################## (expand)
-- RELA Attributes TTY TermTypes
drop    table if exists stats_expand_rela_tty;
create  table           stats_expand_rela_tty as
select  count(*) as cnt_star,
        count(distinct RXCUI1)  as cnt_rxcui1,
        count(distinct RXCUI2)  as cnt_rxcui2,
        RELA,
        TTY1,
        TTY2
from    expand E
group by RELA, TTY1, TTY2
order by cnt_rxcui1 desc, cnt_rxcui2 desc;


-- ############################################## (expand)
-- RELA Attributes TTY TermTypes
drop    table if exists stats_expand_rel_rela_tty;
create  table           stats_expand_rel_rela_tty as
select  count(*) as cnt_star,
        count(distinct RXCUI1)  as cnt_rxcui1,
        count(distinct RXCUI2)  as cnt_rxcui2,
        REL,
        RELA,
        TTY1,
        TTY2
from    expand E
group by REL, RELA, TTY1, TTY2
order by cnt_rxcui1 desc, cnt_rxcui2 desc;

-- ##############################################
call log('stats.sql', 'done');