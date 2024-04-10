-- ##############################################
drop table if exists stats_tty;

create table stats_tty as 
select C.TTY,TTY_STR, count(distinct RXCUI) as cnt from RXNCONSO_curated C, umls_tty U where C.tty=U.tty group by C.TTY,TTY_STR order by cnt desc; 


-- ##############################################
drop table if exists stats_tui;

create table stats_tui as 
select C.TUI,TUI_STR, count(distinct RXCUI) as cnt from RXNSTY_curated C, umls_tui U where C.tui=U.tui group by C.tui,TUI_STR order by cnt desc; 

-- ##############################################
drop table if exists stats_tui;

create table stats_tui as 
select TUI, count(distinct RXCUI) as cnt from RXNSTY_curated group by TUI order by cnt desc; 

-- ##############################################
drop table if exists stats_sab;

create table stats_sab as 
select SAB, count(distinct RXCUI) as cnt from RXNCONSO_curated group by SAB order by cnt desc; 

