drop    table if exists opioid.RXNCONSO_copy;
create  table           opioid.RXNCONSO_copy
select  *
from    rxnorm.RXNCONSO;

call utf8_unicode('opioid.RXNCONSO_copy');
call create_index('opioid.RXNCONSO_copy', 'RXCUI');
call create_index('opioid.RXNCONSO_copy', 'SAB');
call create_index('opioid.RXNCONSO_copy', 'CODE');
call create_index('opioid.RXNCONSO_copy', 'TTY');

drop    table if exists opioid.MRCONSO_drug;
create  table           opioid.MRCONSO_drug
select  *
from    umls.MRCONSO
where   SAB IN  (
        'ATC',
        'CVX',
        'DRUGBANK',
        'GS',
        'MED-RT',
        'MMSL',
        'MMX'
        'MTHCMSFRF',
        'MTHSPL',
        'NDDF',
        'RXNORM',
        'SNOMEDCT_US',
        'USP',
        'VANDF');

--    call utf8_unicode('opioid.MRCONSO_drug');
call create_index('opioid.MRCONSO_drug', 'CUI');
call create_index('opioid.MRCONSO_drug', 'SAB');
call create_index('opioid.MRCONSO_drug', 'CODE');

alter table opioid.MRCONSO_drug add column  RXCUI   varchar(8) NULL;

--    drop    table if exists opioid.MRREL_copy;
--    create  table           opioid.MRREL_copy
--    select  *
--    from    umls.MRREL;
--
--    call utf8_unicode('opioid.MRREL_copy');
--    call create_index('opioid.MRREL_copy','CUI1');
--    call create_index('opioid.MRREL_copy','CUI2');
--    call create_index('opioid.MRREL_copy','SAB');
--    call create_index('opioid.MRREL_copy','REL');
--    call create_index('opioid.MRREL_copy','RELA');

delete from MRREL_copy where SAB in ('SCTSPA', 'MSHSPA', 'MSHFRE','MSHGER','MSHITA','MSHPOR','MSHCZE');


update  opioid.MRCONSO_drug  as U,
        opioid.RXNCONSO_copy as RX
set     U.RXCUI = RX.RXCUI
where   U.SAB = RX.SAB
and     U.CODE= RX.CODE;

select count(distinct RXCUI) from opioid.MRCONSO_drug;



-- select distinct RXCUI,CODE,SAB,SCUI,TTY,STR from rxnorm.RXNCONSO where RXCUI not in (select distinct RXCUI from rxnorm.RXNCONSO where SAB='RXNORM') limit 50 ;
-- select distinct RXCUI,CODE,SAB,SCUI,TTY,STR from rxnorm.RXNCONSO where RXCUI = '60';


--    drop    table if exists opioid.rxcui_cui;
--    create  table           opioid.rxcui_cui
--    select  distinct
--            CUI,
--            CODE as RXCUI
--    from    umls.MRCONSO
--    where   SAB = 'RXNORM';
--
--    call create_index('opioid.rxcui_cui', 'CUI');
--    call create_index('opioid.rxcui_cui', 'RXCUI');
--    call create_index('opioid.rxcui_cui', 'CUI, RXCUI');

--    select distinct RXCUI,STR from rxnorm.RXNCONSO
--    where RXCUI not in (select distinct RXCUI from opioid.rxcui_cui);

--        Rx.SAB,
--        Rx.CODE,
--        Rx.TTY,
--        Rx.RXAUI,
--        Rx.SAUI,
--        Rx.SCUI,
--        Rx.SDUI

drop    table if exists opioid.RXNCONSO_cui;
create  table           opioid.RXNCONSO_cui
select  distinct
        U.CUI,
        Rx.SAB,
        Rx.RXCUI
from    umls.MRCONSO as U,
        rxnorm.RXNCONSO as Rx
where   Rx.SAB = U.SAB
and     Rx.CODE = U.CODE;

drop    table if exists opioid.MRCONSO_medrt;
create  table           opioid.MRCONSO_medrt
select  *
from    umls.MRCONSO
where   SAB ='MED-RT'
and (   lower(STR) like '%opioid%' OR
        lower(STR) like '%opiate%')
order by STR,TTY;

-- https://mor.nlm.nih.gov/RxClass
--
-- Benzodiazepine Antagonist [EPC]	N0000175680
-- Benzomorphan derivatives / id: N02AD
-- Diphenylpropylamine derivatives
-- Morphinan derivatives
-- Natural opium alkaloids
-- Opioids in combination with antispasmodics
-- Opioids in combination with non-opioid analgesics / id: N02AJ
-- Oripavine derivatives / id: N02AE
-- Other opioids / id: N02AX
-- Phenylpiperidine derivatives / id: N02AB
--
drop    table if exists opioid.MRREL_medrt;
create  table           opioid.MRREL_medrt
select  distinct R.*
from    opioid.MRCONSO_medrt C, umls.MRREL R
where   C.CUI = R.CUI1;

drop    table if exists opioid.medrt_cui1;
create  table           opioid.medrt_cui1
select  distinct C.* from opioid.MRREL_medrt M, umls.MRCONSO C
where   M.CUI1 = C.CUI;

drop    table if exists opioid.medrt_cui2;
create  table           opioid.medrt_cui2
select  distinct C.* from opioid.MRREL_medrt M, umls.MRCONSO C
where   M.CUI2 = C.CUI
and     CUI2 not in (select distinct CUI from opioid.MRCONSO_medrt);


drop    table if exists medrt_expand;
create  table           medrt_expand
select  distinct
        C1.RXCUI,   C2.RXCUI    as RXCUI2,
        C1.TTY,     C2.TTY      as TTY2,
        C1.REL,
        C1.RELA,
        C1.STR,     C2.STR      as STR2
from    RXNCONSO_curated_rela C1, rxnorm.RXNCONSO C2
where   C1.RXCUI2 = C2.RXCUI
and     C1.RXCUI2 NOT in (select distinct RXCUI from RXNCONSO_curated);


call create_index('expand','RXCUI');
call create_index('expand','RXCUI2');
call create_index('expand','REL');
call create_index('expand','RELA');
call create_index('expand','TTY');



select distinct CUI from umls.MRCONSO where lower(str) like '%opioid agonist%';

call utf8_unicode('opioid.umls_opioid_agonist');


select * from rxnorm.RXNCONSO C, opioid.umls_opioid_agonist U where C.RXCUI = U.CUI

drop table if exists
select CUI,TTY,STR from umls.MRCONSO
where SAB ='MED-RT'
and (   lower(STR) like '%opioid%' OR
        lower(STR) like '%opiate%')
order by STR,TTY;


CUI|STR
C0242402|Opioids
C0376196|Opiates
C1883695|Opioid Agonist [EPC]
C1373059|Opioid Agonists [Function]
C2917221|Full Opioid Agonists [MoA]
C3536879|Opioid Antagonist [EPC]
C3537237|Opioid Analgesic [EPC]
C1373041|Opioid Receptor Interactions [MoA]
C4060037|mu-Opioid Receptor Agonist [EPC]
C4060041|Opioid mu-Receptor Agonists [Function]

Opioid Agonist/Antagonist [EPC]	N0000175692	MED-RT
Opioid Agonist [EPC]	N0000175690	MED-RT
Opioid Analgesic [EPC]	N0000175440	MED-RT
Opioid Receptor Interactions [MoA]	N0000000200	MED-RT
Kappa Opioid Receptor Agonist [EPC]	N0000194001	MED-RT
Opioid Antagonist [EPC]	N0000175691	MED-RT
Full Opioid Agonists [MoA]	N0000175684	MED-RT
Opioid Agonists [MoA]	N0000000174	MED-RT
Opioid Antagonists [MoA]	N0000000154	MED-RT
Partial Opioid Agonists [MoA]	N0000175685	MED-RT
Competitive Opioid Antagonists [MoA]	N0000175686	MED-RT
Opioid mu-Receptor Agonists [MoA]	N0000191866	MED-RT
Opioid kappa Receptor Agonists [MoA]	N0000194007	MED-RT
mu-Opioid Receptor Agonist [EPC]	N0000191867	MED-RT
Partial Opioid Agonist/Antagonist [EPC]	N0000175688	MED-RT
Partial Opioid Agonist [EPC]	N0000175689	MED-RT



call utf8_unicode('umls.MRREL');
call utf8_unicode('umls.MRCONSO');
call utf8_unicode('umls.MRSAT');
