-- ##########################################
call log('xxx_MRCONSO_LAT', 'begin');

create table xxx_MRCONSO_LAT
select * from MRCONSO where LAT != 'ENG';

call log('xxx_MRCONSO_LAT', 'done');

call create_index('xxx_MRCONSO_LAT', 'CUI');
call create_index('xxx_MRCONSO_LAT', 'AUI');
call create_index('xxx_MRCONSO_LAT', 'CUI, AUI');

delete from MRCONSO where LAT != 'ENG';

call log('xxx_MRCONSO_LAT', 'done');
-- ##########################################

call log('xxx_MRCONSO_SAB', 'begin');

create table xxx_MRCONSO_SAB
select * from MRCONSO where SAB in
('SCTSPA',
'MDRJPN',
'MSHJPN',
'MSHRUS',
'MSHFRE',
'LNC-PT-BR',
'MDRSPA','MDRDUT','MDRGER','MDRITA','MDRPOR','MDRCZE','MDRFRE','MDRHUN',
'LNC-FR-FR',
'SNOMEDCT_VET',
'MSHGER',
'MSHPOR',
'LNC-ZH-CN',
'ICPC2ICD10DUT',
'LNC-ES-AR',
'MSHCZE',
'MSHSPA',
'LNC-IT-IT',
'MSHNOR',
'MSHITA',
'LNC-RU-RU','LNC-ES-ES','LNC-NL-NL','LNC-TR-TR',
'MSHPOL',
'LNC-FR-BE','LNC-FR-CA',
'MSHDUT',
'LNC-ET-EE',
'MSHSWE',
'LNC-KO-KR',
'ICD10AM',
'MSHFIN',
'DMDICD10',
'ICD10DUT',
'LNC-DE-DE',
'MSHSCR',
'ALT',
'LNC-DE-AT','LNC-DE-CH','LNC-ES-CH','LNC-FR-CH','LNC-IT-CH','NCI_NCI-HGNC',
'WHOPOR','WHOFRE','WHOGER','WHOSPA',
'ICD10AMAE',
'LNC-EL-GR',
'ICF-CY',
'MSHLAV',
'NCI_BRIDG',
'ICPCSPA','ICPCDUT','ICPCFRE','ICPCITA','ICPCPOR','ICPCSWE','ICPCDAN','ICPCGER','ICPCFIN','ICPCNOR','ICPCHUN','ICPCBAQ','ICPC2EDUT','ICPCHEB',
'NCI_KEGG',
'RAM',
'NCI_NCI-HL7','NCI_GAIA','NCI_PID','NCI_JAX',
'MTHICPC2ICD10AE','MTHICPC2EAE',
'NCI_ZFin',
'MTHCMSFRF');

call create_index('xxx_MRCONSO_SAB', 'SAB');

delete from MRCONSO where SAB in (select distinct SAB from xxx_MRCONSO_SAB);
delete from MRHIER  where SAB in (select distinct SAB from xxx_MRCONSO_SAB);
delete from MRREL   where SAB in (select distinct SAB from xxx_MRCONSO_SAB);
delete from MRSAT   where SAB in (select distinct SAB from xxx_MRCONSO_SAB);

-- 6,624 entries longer than 255 characters for UMLS2023AB release
-- 
-- alter table MRCONSO MODIFY STR varchar(255); 
