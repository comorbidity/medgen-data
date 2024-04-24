-- ##############################################
call log('stats.sql', 'begin');

-- ##############################################
drop table if exists stats_sab; -- RXNORM vocab summary

create table stats_sab as
select SAB, count(distinct RXCUI) as cnt from RXNCONSO_curated group by SAB order by cnt desc;

-- ##############################################
drop table if exists stats_keywords; -- STR matches Keyword

create table stats_keywords as
select count(distinct RXCUI) as cnt from RXNCONSO_curated where keyword_min is not null;

-- ##############################################
drop table if exists stats_tty; -- Term Types

create table stats_tty as
select C.TTY,TTY_STR, count(distinct RXCUI) as cnt from RXNCONSO_curated C, umls_tty U where C.tty=U.tty group by C.TTY,TTY_STR order by cnt desc;

-- ##############################################
drop table if exists stats_tui; -- Semantic Types

create table stats_tui as
select C.TUI,TUI_STR, count(distinct RXCUI) as cnt from RXNSTY_curated C, umls_tui U where C.tui=U.tui group by C.tui,TUI_STR order by cnt desc;

-- ##############################################
drop table if exists stats_expand; -- Expand (relationships)

create table stats_expand as
select count(distinct RXCUI1) cnt_rxcui1, count(distinct RXCUI2) cnt_rxcui2 from expand;

-- ##############################################
drop table if exists stats_rel; -- REL concepts

create table stats_rel as 
select C.REL,REL_STR, count(distinct RXCUI) as cnt from RXNCONSO_curated_rela C, umls_rel U where C.rel=U.rel group by C.rel,REL_STR order by cnt desc; 

-- ##############################################
drop table if exists stats_rela; -- REL Attributes

create table stats_rela as 
select C.RELA, count(distinct RXCUI) as cnt from RXNCONSO_curated_rela C, umls_rel U where C.rel=U.rel group by C.RELA order by cnt desc;

-- ##############################################
call log('stats.sql', 'done');