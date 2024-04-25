call log('jaccard_all.sql', 'begin');

drop table if exists RXNCONSO_curated, RXNCONSO_curated_jaccard;

create table RXNCONSO_curated_jaccard like RXNCONSO_curated_vsac_math;
alter table RXNCONSO_curated_jaccard add column curated varchar(100);

call create_index('RXNCONSO_curated_jaccard', 'curated');

insert into RXNCONSO_curated_jaccard
select *, 'vsac_math' as curated from  RXNCONSO_curated_vsac_math;

insert into RXNCONSO_curated_jaccard
select *, 'bioportal' as curated from  RXNCONSO_curated_bioportal;

insert into RXNCONSO_curated_jaccard
select *, 'bioportal_to_umls' as curated from  RXNCONSO_curated_bioportal_to_umls;

insert into RXNCONSO_curated_jaccard
select *, 'wasz_april7' as curated from  RXNCONSO_curated_wasz_april7;

insert into RXNCONSO_curated_jaccard
select *, 'custom_rxcui_str' as curated from  RXNCONSO_curated_custom_rxcui_str;

call log('jaccard_all.sql', 'show summary');
select curated, count(distinct RXCUI) cnt from RXNCONSO_curated_jaccard group by curated order by cnt desc;

call log('jaccard_all.sql', 'done');