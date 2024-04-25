-- $CURATED sets in this file:
--    bioportal
--    all_rxcui_str

-- ###############################################################
-- [bioportal_to_umls] stats

select * from bioportal.stats_expand;

--    +------------+------------+
--    | cnt_rxcui1 | cnt_rxcui2 |
--    +------------+------------+
--    |       2007 |       4308 |
--    +------------+------------+

select * from bioportal.stats_rela;

--    +------+-----------------------+------------+------------+
--    | REL  | RELA                  | cnt_rxcui1 | cnt_rxcui2 |
--    +------+-----------------------+------------+------------+
--    | RO   | ingredient_of         |       1571 |        165 | -eXclude
--    | RO   | dose_form_of          |       1033 |         28 | -eXclude
--    | RB   | inverse_isa           |       1031 |        900 |
--    | RB   | has_tradename         |        918 |        817 | +include
--    | RN   | tradename_of          |        913 |       3070 | +include
--    | RN   | isa                   |        726 |       1865 |
--    | RO   | constitutes           |        726 |        601 | ?include
--    | RO   | consists_of           |        553 |       2079 | ? no
--    | RO   | doseformgroup_of      |        421 |         16 | -eXclude
--    | RN   | form_of               |        415 |        446 | -eXclude
--    | RB   | has_quantified_form   |        192 |        166 | ?include
--    | RO   | precise_ingredient_of |        191 |         21 | ?
--    | RO   | ingredients_of        |        173 |         44 | -eXclude
--    | RN   | quantified_form_of    |         13 |         20 | ?include
--    | RN   | contains              |          5 |          5 |
--    | RB   | contained_in          |          2 |          2 |
--    +------+-----------------------+------------+------------+

-- ###############################################################
-- KEYWORDS comparison

select keyword_len, count(distinct RXCUI) cnt
from bioportal.RXNCONSO_curated
group by keyword_len order by keyword_len asc;

--    (bioportal)
--    +-------------+-----+
--    | keyword_len | cnt |
--    +-------------+-----+
--    |        NULL | 166 |
--    |           5 |  52 |
--    |           6 |  91 |
--    |           7 | 590 |
--    |           8 | 764 |
--    |           9 | 287 |
--    |          10 | 154 |
--    |          11 |  36 |
--    |          12 |   1 |
--    |          13 | 129 |
--    |          14 |   1 |
--    |          15 |   5 |
--    +-------------+-----+

select keyword_len, count(distinct RXCUI) cnt
from all_rxcui_str.RXNCONSO_curated
group by keyword_len order by keyword_len asc;

--    (all_rxcui_str)
--    +-------------+--------+
--    | keyword_len | cnt    |
--    +-------------+--------+
--    |        NULL | 380381 |
--    |           4 |      3 |
--    |           5 |    250 |
--    |           6 |    650 |
--    |           7 |   3281 |
--    |           8 |   4706 |
--    |           9 |    898 |
--    |          10 |    620 |
--    |          11 |    217 |
--    |          12 |     31 |
--    |          13 |    253 |
--    |          14 |     10 |
--    |          15 |     11 |
--    +-------------+--------+

-- #####
-- AND (set intersection)

drop    table if exists opioid.all_keywords_AND_bioportal;
create  table opioid.all_keywords_AND_bioportal
select  distinct B.*
from    all_rxcui_str.RXNCONSO_curated A,
        bioportal.RXNCONSO_curated B
where   A.RXCUI = B.RXCUI
and     A.keyword_len > 1;

-- #####
-- DIFF (set difference)

drop    table if exists opioid.all_keywords_DIFF_bioportal;
create  table opioid.all_keywords_DIFF_bioportal
select  distinct A.*
from    all_rxcui_str.RXNCONSO_curated A
where   A.keyword_len > 1
and     A.RXCUI not in (select distinct RXCUI from bioportal.RXNCONSO_curated);

-- ###############################################################
-- DIFF analyze set differences

-- ####
-- TTY Term Types
select  U.TTY, U.TTY_STR, count(distinct C.RXCUI) as cnt
from    all_rxcui_str.RXNCONSO_curated C,
        opioid.all_keywords_DIFF_bioportal D,
        umls_tty U
where   C.RXCUI = D.RXCUI
and     U.TTY = C.TTY
group by U.TTY, U.TTY_STR
order by cnt desc;

--     (all_rxcui_str)
--    +-------------+-------------------------------------------------------------------------+------+
--    | TTY         | TTY_STR                                                                 | cnt  |
--    +-------------+-------------------------------------------------------------------------+------+
--    | TMSY        | Tall Man synonym                                                        | 3445 |
--    | SY          | Designated synonym                                                      | 1735 |
--    | BD          | Fully-specified drug brand name that can be prescribed                  | 1226 |
--    | CD          | Clinical Drug                                                           | 1058 |
--    | SBD         | Semantic branded drug                                                   | 1029 |
--    | SCD         | Semantic Clinical Drug                                                  |  979 |
--    | SBDC        | Semantic Branded Drug Component                                         |  850 |
--    | CDA         | Clinical drug name in abbreviated format                                |  739 |
--    | CDC         | Clinical drug name in concatenated format (NDDF)                        |  739 |
--    | CDD         | Clinical drug name in delimited format                                  |  739 |
--    | SBDFP       | Semantic branded drug and form w/ precise ingredient as basis strength  |  728 |
--    | BN          | Fully-specified drug brand name that can not be prescribed              |  705 |
--    | SBDG        | Semantic branded drug group                                             |  692 |
--    | SBDF        | Semantic branded drug and form                                          |  657 |
--    | PSN         | Prescribable Names                                                      |  579 |
--    | PT          | Designated preferred name                                               |  511 |
--    | FN          | Full form of descriptor                                                 |  510 |
--    | SCDGP       | Semantic clinical drug group w/ precise ingredient as basis strength    |  394 |
--    | IN          | Name for an ingredient                                                  |  325 |
--    | SCDFP       | Semantic clinical drug and form w/ precise ingredient as basis strength |  287 |
--    | SCDG        | Semantic clinical drug group                                            |  272 |
--    | AB          | Abbreviation in any source vocabulary                                   |  271 |
--    | SCDC        | Semantic Drug Component                                                 |  210 |
--    | SCDF        | Semantic clinical drug and form                                         |  193 |
--    | DP          | Drug Product                                                            |  185 |
--    | MIN         | name for a multi-ingredient                                             |  172 |
--    | GN          | Generic drug name                                                       |  154 |
--    | SU          | Active Substance                                                        |   89 |
--    | PIN         | Name from a precise ingredient                                          |   48 |
--    | FSY         | Foreign Synonym                                                         |   44 |
--    | MTH_RXN_BD  | RxNorm Created BD                                                       |   10 |
--    | MTH_RXN_CD  | RxNorm Created CD                                                       |    9 |
--    | PTGB        | British preferred term                                                  |    8 |
--    | MS          | Multum names of branded and generic supplies or supplements             |    6 |
--    | MTH_RXN_DP  | RxNorm Created DP                                                       |    5 |
--    | MTH_RXN_CDC | RxNorm Created CDC                                                      |    5 |
--    | SYGB        | British synonym                                                         |    5 |
--    | BPCK        | Branded Drug Delivery Device                                            |    3 |
--    | GPCK        | Generic Drug Delivery Device                                            |    2 |
--    | RXN_PT      | Rxnorm Preferred                                                        |    1 |
--    +-------------+-------------------------------------------------------------------------+------+

-- ####
-- REL Relationships

select  U.REL, U.REL_STR,
        count(distinct A.RXCUI) as cnt_rxcui1,
        count(distinct A.RXCUI2) as cnt_rxcui2
from    all_rxcui_str.RXNCONSO_curated_rela A,
        opioid.all_keywords_DIFF_bioportal D,
        umls_rel U
where   A.rel=U.rel and A.RXCUI2 = D.RXCUI
group by U.REL,U.REL_STR
order by cnt_rxcui1 desc, cnt_rxcui2 desc;

--    +-----+--------------------------------------------------------------+------------+------------+
--    | REL | REL_STR                                                      | cnt_rxcui1 | cnt_rxcui2 |
--    +-----+--------------------------------------------------------------+------------+------------+
--    | RO  | has relationship other than synonymous, narrower, or broader |       8805 |       5850 |
--    | RB  | has a broader relationship                                   |       6908 |       3991 |
--    | RN  | has a narrower relationship                                  |       5654 |       6286 |
--    +-----+--------------------------------------------------------------+------------+------------+

-- ####
-- REL Attributes

drop    table if exists opioid.RXNCONSO_curated_rela__all_keywords_DIFF_bioportal;
create  table opioid.RXNCONSO_curated_rela__all_keywords_DIFF_bioportal
select  distinct A.REL, A.RELA, A.RXCUI, A.RXCUI2, A.STR
from    all_rxcui_str.RXNCONSO_curated_rela A,
        opioid.all_keywords_DIFF_bioportal D
where   A.RXCUI2 = D.RXCUI;

-- 160265 rows in set

select  REL, RELA,
        count(distinct RXCUI) as cnt_rxcui1,
        count(distinct RXCUI2) as cnt_rxcui2
from    opioid.RXNCONSO_curated_rela__all_keywords_DIFF_bioportal
group by REL,RELA
order by cnt_rxcui1 desc, cnt_rxcui2 desc;

--    +------+------------------------+------------+------------+
--    | REL  | RELA                   | cnt_rxcui1 | cnt_rxcui2 |
--    +------+------------------------+------------+------------+
--    | RO   | ingredient_of          |       5465 |        478 |
--    | RN   | isa                    |       4261 |       3145 |
--    | RB   | has_tradename          |       4100 |       1211 |
--    | RB   | inverse_isa            |       3164 |       3223 |
--    | RN   | tradename_of           |       1757 |       4383 |
--    | RO   | consists_of            |       1690 |       2008 |
--    | RN   | form_of                |       1390 |       1457 |
--    | RO   | constitutes            |       1296 |       1060 |
--    | RB   | has_form               |       1046 |        999 |
--    | RO   | has_ingredient         |        745 |       3903 |
--    | RB   | precise_ingredient_of  |        677 |         38 |
--    | RO   | ingredients_of         |        616 |        172 |
--    | RB   | has_quantified_form    |        364 |        300 |
--    | RO   | part_of                |        322 |         31 |
--    | RO   | precise_ingredient_of  |        309 |         26 |
--    | RO   | boss_of                |        289 |         32 |
--    | RO   | has_ingredients        |        189 |        503 |
--    | RN   | quantified_form_of     |        159 |        196 |
--    | RO   | has_boss               |         89 |        287 |
--    | RO   | has_part               |         80 |        172 |
--    | RN   | has_precise_ingredient |         60 |        400 |
--    | RO   | has_dose_form          |         28 |       2863 |
--    | RO   | has_precise_ingredient |         23 |        119 |
--    | RO   | has_doseformgroup      |         14 |        964 |
--    | RN   | contains               |         13 |          5 |
--    | RO   | reformulated_to        |          7 |          7 |
--    | RO   | reformulation_of       |          7 |          7 |
--    | RB   | contained_in           |          4 |         11 |
--    +------+------------------------+------------+------------+
