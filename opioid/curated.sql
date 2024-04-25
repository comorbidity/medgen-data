-- ##############################################
call log('curated.sql', 'create table');

drop table if exists curated;
create table curated
(
 RXCUI varchar(8)	    NOT NULL,
 STR   varchar(3000)    NOT NULL
);

call log('infile', 'curated.tsv');

load    data local infile 'curated.tsv'
into    table curated
        fields      terminated by '\t'
        optionally  enclosed by '"' ESCAPED BY ''
        lines       terminated by '\n'
        ignore 1 lines;

show warnings; 

call create_index('curated','RXCUI');
call create_index('curated','STR(255)');

-- ##############################################
call log('RXNCONSO_curated', 'refresh'); 

drop table if exists RXNCONSO_curated;

CREATE TABLE RXNCONSO_curated
(
    RXCUI   varchar(8)  NOT NULL,
    STR     varchar(3000)   NOT NULL,
    TTY     varchar(20) NOT NULL,
    SAB     varchar(20) NOT NULL,
    keyword_str varchar(50) NULL,
    keyword_len int NULL
);

insert into RXNCONSO_curated
    (RXCUI, STR, TTY, SAB)
select distinct
    C.RXCUI, C.STR, C.TTY, C.SAB
from rxnorm.RXNCONSO as C, curated
where C.RXCUI = curated.RXCUI
order by RXCUI,STR
;

update RXNCONSO_curated C, keywords K
set
    C.keyword_str = K.STR,
    C.keyword_len = K.LEN
where lower(C.STR) like concat('%',K.STR, '%')
;

call create_index('RXNCONSO_curated','STR(255)');
call create_index('RXNCONSO_curated','RXCUI');

-- ##############################################
--    call log('RXNCONSO_curated_keywords', 'refresh');
--
--    drop table if exists RXNCONSO_curated_keywords;
--
--    create table RXNCONSO_curated_keywords
--    select distinct
--        C.RXCUI,
--        C.STR,
--        C.TTY,
--        C.SAB,
--        K.STR as keyword_str,
--        K.LEN as keyword_len
--    from RXNCONSO_curated C, keywords K
--    where lower(C.STR) like concat('%',K.STR, '%')
--    order by K.STR, K.LEN;

-- ##############################################
call log('RXNSTY_curated', 'refresh');

drop table if exists RXNSTY_curated;

create table RXNSTY_curated
select distinct S.* from rxnorm.RXNSTY as S, curated where S.RXCUI = curated.RXCUI;

call create_index('RXNSTY_curated','RXCUI');

-- ##############################################
call log('RXNREL_curated', 'refresh');

drop table if exists RXNREL_curated;

create table RXNREL_curated
select distinct R.* from rxnorm.RXNREL as R, curated
where R.RXCUI1 = curated.RXCUI;

call create_index('RXNREL_curated','RXCUI1');
call create_index('RXNREL_curated','RXCUI2');

-- ##############################################
call log('RXNCONSO_curated_rela', 'refresh'); 

drop table if exists RXNCONSO_curated_rela;

create table RXNCONSO_curated_rela
select distinct C.*, R.RXCUI1, R.RXCUI2, R.REL, R.RELA
from rxnorm.RXNCONSO as C, RXNREL_curated as R
where (C.RXCUI = R.RXCUI1) or (C.RXCUI = R.RXCUI2);

call create_index('RXNCONSO_curated_rela','RXCUI');
call create_index('RXNCONSO_curated_rela','RXCUI1'); 
call create_index('RXNCONSO_curated_rela','RXCUI2');
call create_index('RXNCONSO_curated_rela','TTY');
call create_index('RXNCONSO_curated_rela','REL');
call create_index('RXNCONSO_curated_rela','RELA');

-- ##############################################
call log('curated.sql', 'done.');
