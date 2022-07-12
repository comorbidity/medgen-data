call log('bsv_medgen.sql', 'begin');
-- #####################################################################
call log('bsv_medgen', 'refresh');
     
update MGCONSO set STR= substring(STR,1,255);
alter table MGCONSO  MODIFY STR varchar(255);

drop   table if exists bsv_medgen;
create table           bsv_medgen
select distinct C.CUI,S.TUI,C.TTY,C.CODE,C.SAB,C.STR,C.STR as PREF
from MGCONSO C, MGSTY S
where C.CUI=S.CUI
order by CUI,STR; 

call utf8_unicode('bsv_medgen'); 
call create_index('bsv_medgen','CUI');
call create_index('bsv_medgen','SAB');
call create_index('bsv_medgen','TTY');
call create_index('bsv_medgen','STR');

call freq('bsv_medgen', 'SAB');
-- +-------------+--------+---------+
-- | SAB         | cnt    | prct    |
-- +-------------+--------+---------+
-- | MSH         | 281484 | 34.6582 |
-- | SNOMEDCT_US | 157911 | 19.4430 |
-- | NCI         | 138862 | 17.0976 |
-- | OMIM        |  84661 | 10.4240 |
-- | GTR         |  65338 |  8.0448 |
-- | MONDO       |  51358 |  6.3235 |
-- | HPO         |  32553 |  4.0081 |
-- | ORDO        |      5 |  0.0006 |
-- +-------------+--------+---------+


-- #####################################################################
call log('bsv_medgen, sab=GTR_COND', 'Genetic Test Registry : Condition');

insert into bsv_medgen
select distinct 
  GTR_identifier as CUI,
  'T047',
  'PT' as TTY,
  T.gene_or_SNOMED_CT_ID as CODE,
  'GTR_COND' as SAB,
  regexp_replace(umls_name, '[[:alnum:]]+:', '')as STR,
  T.umls_name as PREF
from
  GTR.test_condition_gene T
where
  T.concept_type = 'condition'
order by CUI,STR;

-- #####################################################################
call log('bsv_medgen, sab=GTR_GENE', 'Genetic Test Registry : Gene');

insert into bsv_medgen
select distinct 
  T.GTR_identifier as CUI,
  'T028', 
  'PT' as TTY,
  T.gene_or_SNOMED_CT_ID as CODE,
  'GTR_GENE'  as SAB,  
  regexp_replace(umls_name, '[[:alnum:]]+:', '') as STR,  
  T.umls_name as PREF
from
  GTR.test_condition_gene T
where
  T.concept_type = 'gene' 
order by CUI,STR;

insert into bsv_medgen
select distinct 
  T.GTR_identifier as CUI,
  'T028', 
  'PT' as TTY,
  T.gene_or_SNOMED_CT_ID as CODE,
  'GTR_GENE'  as SAB,  
  regexp_replace(umls_name, ':([a-zA-z0-9 ])+', '') as STR,  
  T.umls_name as PREF
from
  GTR.test_condition_gene T
where
  T.concept_type = 'gene' 
order by CUI,STR;

-- #####################################################################
call log('bsv_medgen, sab=clinvar', 'NCBI ClinVar Genetic Variants curated');

insert into bsv_medgen
select distinct
  ConceptID as CUI, 'T028', 'PT', GeneID as CODE,
  'clinvar' as SAB,
  CV.Symbol as STR,
  CV.Symbol as PREF
from
  clinvar.gene_condition_source_id CV
order by CUI,STR;

-- #####################################################################
call log('bsv_medgen, sab=clingen', 'NCBI Clinical Genomics curation');

insert into bsv_medgen
select distinct
  CV.ConceptID as CUI, 'T028', 'PT', CG.GeneID as CODE,
  'clingen' as SAB,
  CG.Symbol as STR,
  CG.Symbol as PREF
from
  clinvar.clingen_gene_curation_list CG,
  clinvar.gene_condition_source_id   CV
where
  CG.Symbol = CV.Symbol
order by CUI,STR;

update bsv_medgen set STR='' where STR like '%(%)%'; 
call trimstr('bsv_medgen',3,100);

call freq('bsv_medgen', 'SAB');
call freq('bsv_medgen', 'TUI');

-- ###################################################
call log('bsv_medgen.sql', 'done');
