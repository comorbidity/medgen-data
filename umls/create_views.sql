call log('create_views.sql', 'refresh');

-- #################################################################################
drop   table if exists MRCONSO_long; 
create table MRCONSO_long
select distinct * from MRCONSO where length(STR) > 100 order by length(str);

call utf8_unicode('MRCONSO_long');
call create_index('MRCONSO_long', 'CUI');

update MRCONSO set STR = SUBSTRING(STR, 0, 250) where length(STR) > 255;

-- #################################################################################
call log('MRCONSO_snomed', 'refresh'); 

drop   table if exists MRCONSO_snomed;
create table           MRCONSO_snomed like MRCONSO; 
insert into            MRCONSO_snomed select * from MRCONSO where SAB like 'SNOMED%'; 

call utf8_unicode('MRCONSO_snomed');

-- ######################################################################
call log('MRCONSO_loinc', 'refresh');

drop   table if exists MRCONSO_loinc;
create table           MRCONSO_loinc like MRCONSO;
insert into            MRCONSO_loinc select * from MRCONSO where SAB='LNC' and TS in ('S','P'); 

call utf8_unicode('MRCONSO_loinc');

-- #################################################################################
call log('MRCONSO_icd', 'refresh'); 

drop   table if exists MRCONSO_icd;
create table           MRCONSO_icd like MRCONSO; 
insert into            MRCONSO_icd select * from MRCONSO where SAB in ('ICD9CM', 'ICD10', 'ICD10CM', 'ICD10AE'); 

call utf8_unicode('MRCONSO_icd');

-- #################################################################################################################
call log('MRCONSO_hpo', 'refresh');

drop   table if exists MRCONSO_hpo;
create table           MRCONSO_hpo like MRCONSO;
insert into            MRCONSO_hpo select * from MRCONSO where SAB = 'HPO';

call utf8_unicode('MRCONSO_hpo');

-- #################################################################################
call log('MRSTY_copy', 'refresh');

drop table if exists MRSTY_copy;

create table MRSTY_copy like MRSTY;
insert into  MRSTY_copy select distinct * from MRSTY order by CUI,TUI asc; 

call utf8_unicode('MRSTY_copy');
call create_index('MRSTY_copy', 'CUI');
call create_index('MRSTY_copy', 'TUI');
call create_index('MRSTY_copy', 'CUI,TUI');

-- #################################################################################
call log('MRCONSO_semtype', 'refresh');

drop table if exists MRCONSO_semtype;

create table MRCONSO_semtype
select distinct C.*, S.TUI, S.STY from MRCONSO C, MRSTY S where C.CUI = S.CUI order by C.CUI,C.STR, S.TUI, C.TTY;

call log('MRCONSO_semtype', 'done');

call utf8_unicode('MRCONSO_semtype');
call create_index('MRCONSO_semtype', 'CUI');
call create_index('MRCONSO_semtype', 'TUI');
call create_index('MRCONSO_semtype', 'CUI, TUI'); 
call create_index('MRCONSO_semtype', 'TTY');
call create_index('MRCONSO_semtype', 'STT');
call create_index('MRCONSO_semtype', 'SAB');
call create_index('MRCONSO_semtype', 'CVF');
call create_index('MRCONSO_semtype', 'ISPREF');

-- #################################################################################
call log('MRREL_vocab_rel', 'refresh');

select count(*) into @total from MRREL;

drop table if exists MRREL_vocab_rel;
create table MRREL_vocab_rel
select SL, SAB, RELA, count(*) as cnt, count(*)/@total as prct from MRREL group by RELA order by cnt desc;

call utf8_unicode('MRREL_freq_rela');
call create_index('MRREL_freq_rela', 'RELA'); 


-- #################################################################################
call log('MRREL_freq_rela', 'refresh');

select count(*) into @total from MRREL;

drop table if exists MRREL_freq_rela;
create table MRREL_freq_rela
select RELA, count(*) as cnt, count(*)/@total as prct from MRREL group by RELA order by cnt desc;

call utf8_unicode('MRREL_freq_rela');
call create_index('MRREL_freq_rela', 'RELA'); 

-- +--------------------------------------------------------+----------+--------+
-- | RELA                                                   | cnt      | prct   |
-- +--------------------------------------------------------+----------+--------+
-- | NULL                                                   | 41924464 | 0.5460 |
-- | inverse_isa                                            |  3196203 | 0.0416 |
-- | isa                                                    |  3196203 | 0.0416 |
-- | has_inactive_ingredient                                |  1216062 | 0.0158 |
-- | inactive_ingredient_of                                 |  1216062 | 0.0158 |
-- ...
-- | has_finding_site                                       |   775488 | 0.0101 |
-- | finding_site_of                                        |   775488 | 0.0101 |
-- ...
-- | has_active_ingredient                                  |   385985 | 0.0050 |
-- | active_ingredient_of                                   |   385985 | 0.0050 |
-- ...
-- | has_ingredient                                         |   347475 | 0.0045 |
-- | ingredient_of                                          |   347475 | 0.0045 |
-- ...
-- | procedure_site_of                                      |   277801 | 0.0036 |
-- | has_procedure_site                                     |   277801 | 0.0036 |
-- ...
-- | dose_form_of                                           |   184777 | 0.0024 |
-- | has_dose_form                                          |   184777 | 0.0024 |
-- ...
-- | has_direct_procedure_site                              |   171576 | 0.0022 |
-- | direct_procedure_site_of                               |   171576 | 0.0022 |
-- ..
-- | contraindicated_with_disease                           |    47664 | 0.0006 |
-- | has_contraindicated_drug                               |    47664 | 0.0006 |
-- ..
-- | direct_substance_of                                    |    45084 | 0.0006 |
-- | has_direct_substance                                   |    45084 | 0.0006 |
-- ...
-- | has_finding_method                                     |    38825 | 0.0005 |
-- | finding_method_of                                      |    38825 | 0.0005 |
-- ...
-- | disease_has_associated_anatomic_site                   |    31178 | 0.0004 |
-- | is_associated_anatomic_site_of                         |    31178 | 0.0004 |
-- ...
-- | clinically_associated_with                             |    29632 | 0.0004 |
-- ...
-- | clinician_form_of                                      |    27147 | 0.0004 |
-- | has_clinician_form                                     |    27147 | 0.0004 |
-- ...
-- | associated_finding_of                                  |    26180 | 0.0003 |
-- | has_associated_finding                                 |    26180 | 0.0003 |
-- ... 
-- | is_finding_of_disease                                  |    25128 | 0.0003 |
-- | disease_has_finding                                    |    25128 | 0.0003 |
-- ...
-- | has_specialty                                          |    25076 | 0.0003 |
-- | specialty_of                                           |    25076 | 0.0003 |
-- ...
-- | device_used_by                                         |    22526 | 0.0003 |
-- | uses_device                                            |    22526 | 0.0003 |
-- ...
-- | disease_has_primary_anatomic_site                      |    20798 | 0.0003 |
-- | is_primary_anatomic_site_of_disease                    |    20798 | 0.0003 |
-- ...
-- | disease_may_have_finding                               |    15486 | 0.0002 |
-- | may_be_finding_of_disease                              |    15486 | 0.0002 |
-- ...
-- | specimen_of                                            |    14874 | 0.0002 |
-- | has_specimen                                           |    14874 | 0.0002 |
-- ...
-- | entire_anatomy_structure_of                            |    14126 | 0.0002 |
-- | has_entire_anatomy_structure                           |    14126 | 0.0002 |
-- ...
-- | co-occurs_with                                         |    13768 | 0.0002 |

call utf8_unicode('MRREL_freq_rela'); 

-- #################################################################################
call log('MRREL_rela', 'begin'); 

drop table if exists MRREL_rela; 
create table MRREL_rela
select distinct R.* from MRREL R where R.RELA in
('has_inactive_ingredient', 'inactive_ingredient_of',
 'has_finding_site', 'finding_site_of',
 'has_active_ingredient', 'active_ingredient_of',
 'has_ingredient','ingredient_of',
 'procedure_site_of', 'has_procedure_site',
 'dose_form_of','has_dose_form',
 'has_direct_procedure_site', 'direct_procedure_site_of',
 'contraindicated_with_disease', 'has_contraindicated_drug',
 'direct_substance_of', 'has_direct_substance',
 'has_finding_method', 'finding_method_of',
 'disease_has_associated_anatomic_site', 'is_associated_anatomic_site_of',
 'clinically_associated_with',
 'clinician_form_of','has_clinician_form',
 'associated_finding_of','has_associated_finding',
 'is_finding_of_disease', 'disease_has_finding',
 'has_specialty', 'specialty_of',
 'device_used_by', 'uses_device',
 'disease_has_primary_anatomic_site', 'is_primary_anatomic_site_of_disease',
 'disease_may_have_finding', 'may_be_finding_of_disease',
 'specimen_of', 'has_specimen' ,
 'entire_anatomy_structure_of','has_entire_anatomy_structure',
 'co-occurs_with');

call utf8_unicode('MRREL_rela');
call create_index('MRREL_rela','RELA');
call create_index('MRREL_rela','CUI1');

call log('MRREL_rela', 'done');

-- #################################################################################
call log('MRREL_rela_rank', 'start');

drop   table if exists MRREL_rela_rank;

select count(*) into @total from MRREL_rela;

create table MRREL_rela_rank
select RELA, count(*) as cnt, count(*)/@total as prct from MRREL_rela group by RELA order by cnt desc;

-- ALTER TABLE MRREL_rela_rank ADD rank INT NOT NULL AUTO_INCREMENT PRIMARY KEY; 

call utf8_unicode('MRREL_rela_rank');
call create_index('MRREL_rela_rank','RELA');

-- #################################################################################
call log('MRCONSO_rela', 'start'); 

drop table if exists MRCONSO_rela; 
create table MRCONSO_rela
select distinct C.*, R.RUI, R.RELA from MRCONSO C, MRREL_rela R where C.CUI = R.CUI1;

call utf8_unicode('MRCONSO_rela'); 
call create_index('MRCONSO_rela', 'CUI');
call create_index('MRCONSO_rela', 'RELA');
call create_index('MRCONSO_rela', 'RELA, CUI'); 

-- #################################################################################
call log('MRSTY_freq', 'start'); 

select count(*) into @total from MRSTY;

drop   table if exists MRSTY_freq; 
create table           MRSTY_freq
select TUI,STY, count(*) as cnt, count(*)/@total as prct from MRSTY group by TUI,STY order by cnt desc;

call utf8_unicode('MRSTY_freq');
call create_index('MRSTY_freq', 'TUI');
call create_index('MRSTY_freq', 'STY');


-- #################################################################################
call log('create_views.sql', 'done');
