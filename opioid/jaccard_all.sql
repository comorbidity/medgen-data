call log('jaccard_all.sql', 'begin');

drop table if exists RXNCONSO_curated, RXNCONSO_curated_jaccard;

create table RXNCONSO_curated_jaccard like RXNCONSO_curated_VSAC_Mathematica;
alter table RXNCONSO_curated_jaccard add column curated varchar(100);

call create_index('RXNCONSO_curated_jaccard', 'curated');

insert into RXNCONSO_curated_jaccard
select *, 'VSAC_Mathematica' as curated from  RXNCONSO_curated_VSAC_Mathematica;

insert into RXNCONSO_curated_jaccard
select *, 'bioportal' as curated from  RXNCONSO_curated_bioportal;

insert into RXNCONSO_curated_jaccard
select *, 'bioportal_to_umls' as curated from  RXNCONSO_curated_bioportal_to_umls;

insert into RXNCONSO_curated_jaccard
select *, 'umls_reviewed_april7' as curated from  RXNCONSO_curated_umls_reviewed_april7;

insert into RXNCONSO_curated_jaccard
select *, 'opium_rxcui_str' as curated from  RXNCONSO_curated_opium_rxcui_str;

call log('jaccard_all.sql', 'done');