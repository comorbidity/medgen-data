-- #############################################################################
call log('keywords_db.sql', 'begin');

drop    table if exists     keywords.RXNCONSO_curated;
create  table               keywords.RXNCONSO_curated
select  distinct * from all_rxcui_str.RXNCONSO_curated;

call create_index('RXNCONSO_curated', 'RXCUI');
call create_index('RXNCONSO_curated', 'STR(255)');

drop    table if exists keywords.curated;
create  table           keywords.curated
select  distinct RXCUI,STR
from    RXNCONSO_curated
where   keyword_len > 0
order by RXCUI,STR;


-- #############################################################################
call log('keywords_db.sql', 'done');
