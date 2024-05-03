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

select * from vsac_math.stats_expand_rel;
--    +----------+------------+------------+-----+--------------------------------------------------------------+
--    | cnt_star | cnt_rxcui1 | cnt_rxcui2 | REL | REL_STR                                                      |
--    +----------+------------+------------+-----+--------------------------------------------------------------+
--    |    31377 |        350 |        305 | RO  | has relationship other than synonymous, narrower, or broader |
--    |    59977 |        348 |        445 | RB  | has a broader relationship                                   |
--    |    80062 |        289 |        486 | RN  | has a narrower relationship                                  |
--    +----------+------------+------------+-----+--------------------------------------------------------------+

select * from vsac_math.stats_expand_rela;
--    +----------+------------+------------+---------------------+
--    | cnt_star | cnt_rxcui1 | cnt_rxcui2 | RELA                |
--    +----------+------------+------------+---------------------+
--    |     9234 |        350 |         21 | dose_form_of        |
--    |    46758 |        348 |        347 | inverse_isa         |
--    |    11401 |        348 |        246 | constitutes         |
--    |    78863 |        289 |        468 | tradename_of        |
--    |    13219 |        117 |         98 | has_quantified_form |
--    |    10742 |        111 |         38 | ingredients_of      |
--    |     1199 |         13 |         18 | quantified_form_of  |
--    +----------+------------+------------+---------------------+


-- ###############################################################
call log('vsac_math_SUB_bioportal', 'bioportal is missing 5 CUI from subset vsac_math');

drop    table if exists opioid.vsac_math_SUB_bioportal;
create  table           opioid.vsac_math_SUB_bioportal
select  distinct V.*
from    vsac_math.curated V
where   RXCUI not in (select distinct RXCUI from bioportal.curated);
--    +---------+----------------------------------------------+
--    | RXCUI   | STR                                          |
--    +---------+----------------------------------------------+
--    | 2629337 | 0.5 ML fentanyl 0.05 MG/ML Prefilled Syringe |
--    | 2474269 | 1 ML fentanyl 0.05 MG/ML Prefilled Syringe   |
--    | 2635081 | 100 ML fentanyl 0.05 MG/ML Injection         |
--    | 2474267 | 2 ML fentanyl 0.05 MG/ML Prefilled Syringe   |
--    | 2670390 | tramadol hydrochloride 25 MG Oral Tablet     |
--    +---------+----------------------------------------------+

-- ###############################################################

-- #####
-- DIFF (set difference)

drop    table if exists opioid.bioportal_DIFF_vsac_math;
create  table           opioid.bioportal_DIFF_vsac_math
select  distinct B.*
from    bioportal.RXNCONSO_curated B
where   RXCUI not in (select distinct RXCUI from vsac_math.curated);

-- ####
-- TTY Term Types
select  count(distinct C.RXCUI) as cnt_rxcui,
        U.TTY,
        U.TTY_STR
from    bioportal.RXNCONSO_curated C,
        opioid.bioportal_DIFF_vsac_math D,
        umls_tty U
where   C.RXCUI = D.RXCUI
and     U.TTY = C.TTY
group by U.TTY, U.TTY_STR
order by cnt desc;

--    +-----+------------+------------------------------------------------------------+
--    | cnt | TTY        | TTY_STR                                                    |
--    +-----+------------+------------------------------------------------------------+
--    | 661 | TMSY       | Tall Man synonym                                           |
--    | 390 | SY         | Designated synonym                                         |
--    | 363 | PSN        | Prescribable Names                                         |
--    | 317 | BD         | Fully-specified drug brand name that can be prescribed     |
--    | 292 | SBD        | Semantic branded drug                                      |
--    | 277 | SCDC       | Semantic Drug Component                                    |
--    | 276 | SBDC       | Semantic Branded Drug Component                            |
--    | 234 | DP         | Drug Product                                               |
--    | 221 | SBDG       | Semantic branded drug group                                |
--    | 200 | SCDG       | Semantic clinical drug group                               |
--    | 176 | SCDF       | Semantic clinical drug and form                            |
--    | 129 | SBDF       | Semantic branded drug and form                             |
--    | 117 | FN         | Full form of descriptor                                    |
--    | 117 | PT         | Designated preferred name                                  |
--    |  92 | CD         | Clinical Drug                                              |
--    |  91 | SCD        | Semantic Clinical Drug                                     |
--    |  75 | CDA        | Clinical drug name in abbreviated format                   |
--    |  75 | CDC        | Clinical drug name in concatenated format (NDDF)           |
--    |  75 | CDD        | Clinical drug name in delimited format                     |
--    |  54 | AB         | Abbreviation in any source vocabulary                      |
--    |   9 | MTH_RXN_BD | RxNorm Created BD                                          |
--    |   5 | BN         | Fully-specified drug brand name that can not be prescribed |
--    |   4 | MTH_RXN_CD | RxNorm Created CD                                          |
--    |   2 | GN         | Generic drug name                                          |
--    |   2 | MTH_RXN_DP | RxNorm Created DP                                          |
--    +-----+------------+------------------------------------------------------------+

-- ####
-- REL Relationships

select  count(distinct V.RXCUI)     as cnt_rxcui1,
        count(distinct V.RXCUI2)    as cnt_rxcui2,
        U.REL, U.REL_STR
from    vsac_math.RXNCONSO_curated_rela V,
        opioid.bioportal_DIFF_vsac_math D,
        umls_rel U
where   V.rel=U.rel and V.RXCUI2 = D.RXCUI
group by U.REL,U.REL_STR
order by cnt_rxcui1 desc, cnt_rxcui2 desc;

--    +------------+------------+-----+--------------------------------------------------------------+
--    | cnt_rxcui1 | cnt_rxcui2 | REL | REL_STR                                                      |
--    +------------+------------+-----+--------------------------------------------------------------+
--    |        347 |        245 | RB  | has a broader relationship                                   |
--    |        346 |        176 | RO  | has relationship other than synonymous, narrower, or broader |
--    |        204 |        234 | RN  | has a narrower relationship                                  |
--    +------------+------------+-----+--------------------------------------------------------------+

-- ###############################################################
call log('RXNCONSO_curated_rela__vsac_math_DIFF_bioportal', 'vsac_math has *related* RXCUI2 not in bioportal');

drop    table if exists opioid.RXNCONSO_curated_rela__vsac_math_DIFF_bioportal;
create  table           opioid.RXNCONSO_curated_rela__vsac_math_DIFF_bioportal
select  distinct
        REL, RELA, RXCUI, RXCUI2, STR
from    vsac_math.RXNCONSO_curated_rela
where   RXCUI2 not in
        (select distinct RXCUI from bioportal.curated)
order by RXCUI, RXCUI2;

select  distinct REL, RELA,
        count(distinct RXCUI) cnt_rxcui1,
        count(distinct RXCUI2) cnt_rxcui2
from    opioid.RXNCONSO_curated_rela__vsac_math_DIFF_bioportal
group by REL, RELA
order by REL, RELA;
--    +------+---------------------+------------+------------+
--    | REL  | RELA                | cnt_rxcui1 | cnt_rxcui2 |
--    +------+---------------------+------------+------------+
--    | RB   | has_quantified_form |        117 |         98 |
--    | RB   | inverse_isa         |        288 |        102 |
--    | RN   | quantified_form_of  |         13 |         18 |
--    | RN   | tradename_of        |        127 |        234 |
--    | RO   | constitutes         |        107 |         70 |
--    | RO   | dose_form_of        |        350 |         21 |
--    | RO   | ingredients_of      |        111 |         38 |
--    +------+---------------------+------------+------------+




