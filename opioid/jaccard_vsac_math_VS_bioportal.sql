call log('jaccard_all.sql', 'begin');

-- $CURATED
--    vsac_math
--    bioportal
--    bioportal_to_umls
--    custom_rxcui_str
--    all_rxcui_str
--    wasz_april7

=
-- ###############################################################
-- [Assert #1] Verify curated RXCUI were found in RXNORM

select * from vsac_math.curated where RXCUI not in
(select distinct RXCUI from vsac_math.RXNCONSO_curated);

select * from bioportal.curated where RXCUI not in
(select distinct RXCUI from bioportal.RXNCONSO_curated);

select * from bioportal_to_umls.curated where RXCUI not in
(select distinct RXCUI from bioportal_to_umls.RXNCONSO_curated);

--    +--------+----------------------------------------------------------------+
--    | RXCUI  | STR                                                            |
--    +--------+----------------------------------------------------------------+
--    | 149373 | 12 HR tapentadol 200 MG Extended Release Oral Tablet [Nucynta] |
--    | 187503 | Tylenol with Codeine Pill                                      |
--    +--------+----------------------------------------------------------------+

select * from wasz_april7.curated where RXCUI not in
(select distinct RXCUI from wasz_april7.RXNCONSO_curated);

--    +--------+----------------------------------------------------------------+
--    | RXCUI  | STR                                                            |
--    +--------+----------------------------------------------------------------+
--    | 149373 | 12 HR tapentadol 200 MG Extended Release Oral Tablet [Nucynta] |
--    | 187503 | Tylenol with Codeine Pill                                      |
--    +--------+----------------------------------------------------------------+

-- ###############################################################
-- [Assert #2] SUPerset "bioportal" includes "vsac_math" (Mathematica)
-- all RXCUI **should** be included.

drop    table if exists opioid.vsac_math_SUP_bioportal;
create  table opioid.vsac_math_SUP_bioportal
select  distinct V.*
from    vsac_math.curated V
where   RXCUI not in (select distinct RXCUI from bioportal.curated);

--    +---------+----------------------------------------------+
--    | RXCUI   | STR                                          |
--    +---------+----------------------------------------------+
--    | 2474267 | 2 ML fentanyl 0.05 MG/ML Prefilled Syringe   |
--    | 2474269 | 1 ML fentanyl 0.05 MG/ML Prefilled Syringe   |
--    | 2629337 | 0.5 ML fentanyl 0.05 MG/ML Prefilled Syringe |
--    | 2635081 | 100 ML fentanyl 0.05 MG/ML Injection         |
--    | 2670390 | tramadol hydrochloride 25 MG Oral Tablet     |
--    +---------+----------------------------------------------+

-- ###############################################################
-- [3] "bioportal" VS "vsac_math" (Mathematica)

drop    table if exists opioid.bioportal_DIFF_vsac_math;
create  table opioid.bioportal_DIFF_vsac_math
select  distinct B.*
from    bioportal.RXNCONSO_curated B
where   RXCUI not in (select distinct RXCUI from vsac_math.curated);

drop    table if exists opioid.bioportal_AND_vsac_math;
create  table opioid.bioportal_AND_vsac_math
select  distinct B.*
from    bioportal.RXNCONSO_curated B, vsac_math.curated V
where   B.RXCUI = V.RXCUI;

-- ###
-- CNT DIFF

select count(distinct RXCUI) from opioid.bioportal_DIFF_vsac_math;
--    +-----------------------+
--    | count(distinct RXCUI) |
--    +-----------------------+
--    |                  1662 |
--    +-----------------------+

-- ####
-- TTY Term Types
select  U.TTY, U.TTY_STR, count(distinct C.RXCUI) as cnt
from    bioportal.RXNCONSO_curated C,
        opioid.bioportal_DIFF_vsac_math D,
        umls_tty U
where   C.RXCUI = D.RXCUI
and     U.TTY = C.TTY
group by U.TTY, U.TTY_STR
order by cnt desc;

--    +------------+------------------------------------------------------------+-----+
--    | TTY        | TTY_STR                                                    | cnt |
--    +------------+------------------------------------------------------------+-----+
--    | TMSY       | Tall Man synonym                                           | 661 |
--    | SY         | Designated synonym                                         | 390 |
--    | PSN        | Prescribable Names                                         | 363 |
--    | BD         | Fully-specified drug brand name that can be prescribed     | 317 |
--    | SBD        | Semantic branded drug                                      | 292 |
--    | SCDC       | Semantic Drug Component                                    | 277 |
--    | SBDC       | Semantic Branded Drug Component                            | 276 |
--    | DP         | Drug Product                                               | 234 |
--    | SBDG       | Semantic branded drug group                                | 221 |
--    | SCDG       | Semantic clinical drug group                               | 200 |
--    | SCDF       | Semantic clinical drug and form                            | 176 |
--    | SBDF       | Semantic branded drug and form                             | 129 |
--    | FN         | Full form of descriptor                                    | 117 |
--    | PT         | Designated preferred name                                  | 117 |
--    | CD         | Clinical Drug                                              |  92 |
--    | SCD        | Semantic Clinical Drug                                     |  91 |
--    | CDA        | Clinical drug name in abbreviated format                   |  75 |
--    | CDC        | Clinical drug name in concatenated format (NDDF)           |  75 |
--    | CDD        | Clinical drug name in delimited format                     |  75 |
--    | AB         | Abbreviation in any source vocabulary                      |  54 |
--    | MTH_RXN_BD | RxNorm Created BD                                          |   9 |
--    | BN         | Fully-specified drug brand name that can not be prescribed |   5 |
--    | MTH_RXN_CD | RxNorm Created CD                                          |   4 |
--    | GN         | Generic drug name                                          |   2 |
--    | MTH_RXN_DP | RxNorm Created DP                                          |   2 |
--    +------------+------------------------------------------------------------+-----+

-- ####
-- REL Relationships

select  U.REL, U.REL_STR, count(distinct C.RXCUI) as cnt
from    vsac_math.RXNCONSO_curated_rela C,
        opioid.bioportal_DIFF_vsac_math D,
        umls_rel U
where   C.RXCUI = D.RXCUI
and     C.rel=U.rel
group by U.REL,U.REL_STR
order by cnt desc;

--    +-----+--------------------------------------------------------------+-----+
--    | REL | REL_STR                                                      | cnt |
--    +-----+--------------------------------------------------------------+-----+
--    | RB  | has a broader relationship                                   | 245 |
--    | RN  | has a narrower relationship                                  | 234 |
--    | RO  | has relationship other than synonymous, narrower, or broader | 176 |
--    +-----+--------------------------------------------------------------+-----+

-- ####
-- RELA Attributes

select  C.REL, C.RELA, count(distinct C.RXCUI) as cnt
from    RXNCONSO_curated_rela C,
        opioid.bioportal_DIFF_vsac_math D
where   C.RXCUI = D.RXCUI
group by C.REL,C.RELA
order by cnt desc;

--    +------+------------------------+------+
--    | REL  | RELA                   | cnt  |
--    +------+------------------------+------+
--    | RO   | ingredient_of          | 1571 |
--    | RN   | tradename_of           | 1537 |
--    | RB   | has_tradename          | 1535 |
--    | RO   | has_ingredient         | 1280 |
--    | RB   | inverse_isa            | 1109 |
--    | RN   | isa                    | 1109 |
--    | RO   | consists_of            |  936 |
--    | RO   | constitutes            |  936 |
--    | RO   | dose_form_of           |  688 |
--    | RO   | doseformgroup_of       |  421 |
--    | RN   | form_of                |  415 |
--    | RB   | has_form               |  414 |
--    | RO   | has_precise_ingredient |  191 |
--    | RO   | precise_ingredient_of  |  191 |
--    | RB   | has_quantified_form    |   77 |
--    | RN   | quantified_form_of     |   77 |
--    | RO   | has_ingredients        |   62 |
--    | RO   | ingredients_of         |   62 |
--    | RB   | contained_in           |    3 |
--    | RN   | contains               |    3 |
--    +------+------------------------+------+



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