call log('jaccard_all.sql', 'begin');

-- $CURATED
--    vsac_math
--    bioportal
--    wasz_april7

-- ###############################################################
-- [vsac_math] stats

select * from vsac_math.stats_expand;
--    +------------+------------+
--    | cnt_rxcui1 | cnt_rxcui2 |
--    +------------+------------+
--    |        350 |       1236 | >1000 relations from vsac_math
--    +------------+------------+

select * from vsac_math.stats_rel;
--    +------+--------------------------------------------------------------+------------+------------+
--    | REL  | REL_STR                                                      | cnt_rxcui1 | cnt_rxcui2 |
--    +------+--------------------------------------------------------------+------------+------------+
--    | RB   | has a broader relationship                                   |        350 |        449 |
--    | RO   | has relationship other than synonymous, narrower, or broader |        350 |        305 |
--    | RN   | has a narrower relationship                                  |        289 |        490 | +include?
--    +------+--------------------------------------------------------------+------------+------------+

select * from vsac_math.stats_rela;
--    +------+---------------------+------------+------------+
--    | REL  | RELA                | cnt_rxcui1 | cnt_rxcui2 |
--    +------+---------------------+------------+------------+
--    | RO   | dose_form_of        |        350 |         21 | -eXclude
--    | RB   | inverse_isa         |        348 |        347 |
--    | RO   | constitutes         |        348 |        246 |
--    | RN   | tradename_of        |        289 |        468 | +include
--    | RB   | has_quantified_form |        119 |        100 | +include
--    | RO   | ingredients_of      |        111 |         38 | +include
--    | RN   | quantified_form_of  |         13 |         20 | +include
--    | RB   | contained_in        |          2 |          2 |
--    | RN   | contains            |          2 |          2 |
--    +------+---------------------+------------+------------+

-- ###############################################################
call log('vsac_math_SUB_bioportal', 'bioportal is missing 5 CUI from subset vsac_math');

drop    table if exists opioid.vsac_math_SUB_bioportal;
create  table opioid.vsac_math_SUB_bioportal
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
-- "bioportal" VS "vsac_math" (Mathematica)

-- #####
-- AND (set intersection)

drop    table if exists opioid.bioportal_AND_vsac_math;
create  table opioid.bioportal_AND_vsac_math
select  distinct B.*
from    bioportal.RXNCONSO_curated B, vsac_math.curated V
where   B.RXCUI = V.RXCUI;

-- #####
-- DIFF (set difference)

drop    table if exists opioid.bioportal_DIFF_vsac_math;
create  table opioid.bioportal_DIFF_vsac_math
select  distinct B.*
from    bioportal.RXNCONSO_curated B
where   RXCUI not in (select distinct RXCUI from vsac_math.curated);

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
--    | TMSY       | Tall Man synonym                                           | 661 | Tall Man is most common type
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

select  U.REL, U.REL_STR,
        count(distinct V.RXCUI) as cnt_rxcui1,
        count(distinct V.RXCUI2) as cnt_rxcui2
from    vsac_math.RXNCONSO_curated_rela V,
        opioid.bioportal_DIFF_vsac_math D,
        umls_rel U
where   V.rel=U.rel and V.RXCUI2 = D.RXCUI
group by U.REL,U.REL_STR
order by cnt_rxcui1 desc, cnt_rxcui2 desc;

--    +------+--------------+------------+------------+
--    | REL  | RELA         | cnt_rxcui1 | cnt_rxcui2 |
--    +------+--------------+------------+------------+
--    | RB   | inverse_isa  |        347 |        245 | ??? broader "has a", usually include but can't always.
--    | RO   | constitutes  |        346 |        176 | +include
--    | RN   | tradename_of |        204 |        234 | +include
--    +------+--------------+------------+------------+

-- ###############################################################
call log('RXNCONSO_curated_rela__vsac_math_DIFF_bioportal', 'vsac_math has 581 *related* RXCUI2 not in bioportal');

drop    table if exists opioid.RXNCONSO_curated_rela__vsac_math_DIFF_bioportal;
create  table opioid.RXNCONSO_curated_rela__vsac_math_DIFF_bioportal
select  distinct REL, RELA, RXCUI, RXCUI2, STR
from vsac_math.RXNCONSO_curated_rela where RXCUI2 not in (
    select distinct RXCUI from bioportal.curated)
order by RXCUI, RXCUI2;

--    +------+--------------+---------+---------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
--    | REL  | RELA         | RXCUI   | RXCUI2  | STR                                                                                                                                                     |
--    +------+--------------+---------+---------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
--    | RN   | tradename_of | 1014599 | 1014605 | acetaminophen 300 MG / oxycodone hydrochloride 10 MG Oral Tablet                                                                                        |
--
--    RXCUI2 is "acetaminophen 300 MG / oxycodone hydrochloride 10 MG Oral Tablet [Perloxx]"
--    ...
--    581 rows in set

select  distinct REL, RELA,
        count(distinct RXCUI) cnt_rxcui1,
        count(distinct RXCUI2) cnt_rxcui2
from    opioid.RXNCONSO_curated_rela__vsac_math_DIFF_bioportal
group by REL, RELA
order by REL, RELA;
--    +------+---------------------+------------+------------+
--    | REL  | RELA                | cnt_rxcui1 | cnt_rxcui2 |
--    +------+---------------------+------------+------------+
--    | RB   | has_quantified_form |        117 |         98 | ?include
--    | RB   | inverse_isa         |        288 |        102 |
--    | RN   | quantified_form_of  |         13 |         18 | ?include
--    | RN   | tradename_of        |        127 |        234 | +include
--    | RO   | constitutes         |        107 |         70 | ?include
--    | RO   | dose_form_of        |        350 |         21 | -eXclude
--    | RO   | ingredients_of      |        111 |         38 |
--    +------+---------------------+------------+------------+




