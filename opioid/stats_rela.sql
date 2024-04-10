-- ##############################################
drop table if exists stats_tty;

create table stats_tty as 
select C.TTY,TTY_STR, count(distinct RXCUI) as cnt from RXNCONSO_curated_rela C, umls_tty U where C.tty=U.tty group by C.TTY,TTY_STR order by cnt desc; 

-- ##############################################
drop table if exists stats_rel;

create table stats_rel as 
select C.REL,REL_STR, count(distinct RXCUI) as cnt from RXNCONSO_curated_rela C, umls_rel U where C.rel=U.rel group by C.rel,REL_STR order by cnt desc; 

-- ##############################################
drop table if exists stats_rela;

create table stats_rela as 
select C.RELA, count(distinct RXCUI) as cnt from RXNCONSO_curated_rela C, umls_rel U where C.rel=U.rel group by C.RELA order by cnt desc; 


