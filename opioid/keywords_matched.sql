-- ##############################################
call log('keywords_matched', 'do the keywords match self?');

--select K1.*,K2.* from keywords K1, keywords K2 where K1.STR like concat('%',K2.STR,'%') and K1.STR != K2.STR;

-- ##############################################
call log('keywords_matched', 'refresh');

drop table if exists keywords_matched, keywords_diff;

create table keywords_matched
select distinct RXCUI, keyword_min_len, keyword_min, keyword_max_len, keyword_max, STR
from RXNCONSO_curated
where keyword_min_len>1
order by keyword_min_len, keyword_min, keyword_max, STR;

--create table keywords_diff
--select * from keywords_matched
--where RXCUI not in (select distinct RXCUI from RXNCONSO_curated);

RXNCONSO_curated_all_rxcui
RXNCONSO_curated_VSAC
RXNCONSO_curated_bioportal
RXNCONSO_curated_bioportal_to_umls

--select distinct RXCUI,STR from RXNCONSO_curated_all_rxcui
--where keyword_min_len > 1 and RXCUI not in (select distinct RXCUI from RXNCONSO_curated_bioportal_to_umls);
--
--select distinct RXCUI,STR from RXNCONSO_curated_all_rxcui
--where keyword_min_len > 1 and RXCUI not in (select distinct RXCUI from expand);
--
--
--select distinct RXCUI,STR from RXNCONSO_curated_bioportal_to_umls
--where RXCUI not in (select distinct RXCUI from RXNCONSO_curated_all_rxcui
--where keyword_min_len > 1)
--
--
--select distinct RXCUI from RXNCONSO_curated_bioportal_to_umls
--where RXCUI not in
--(select RXCUI1 from expand UNION select RXCUI2 from expand)
--
-- select distinct RXCUI2 from expand where RXCUI2 not in (select RXCUI from curated);
--
--select distinct RXCUI from RXNCONSO_curated_all_rxcui
--where RXCUI not in (
--    select distrinct RXCUI from curated
--)

create table keywords_diff
select distinct RXCUI, keyword_min_len, keyword_min, keyword_max_len, keyword_max, STR
from RXNCONSO_curated_all_rxcui
where keyword_min_len>1
and RXCUI not in (select distinct RXCUI from curated_april7)
order by keyword_min_len, keyword_min, keyword_max, STR;
