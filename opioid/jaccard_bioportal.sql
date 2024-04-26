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

select * from bioportal.stats_expand_rela;

--    +----------+------------+------------+-----------------------+
--    | cnt_star | cnt_rxcui1 | cnt_rxcui2 | RELA                  |
--    +----------+------------+------------+-----------------------+
--    |    32761 |       1571 |        165 | ingredient_of         |
--    |    15525 |       1033 |         28 | dose_form_of          |
--    |    14660 |        565 |        229 | inverse_isa           |
--    |    62488 |        521 |       2181 | tradename_of          |
--    |      782 |        421 |         16 | doseformgroup_of      |
--    |     1333 |        415 |        446 | form_of               |
--    |    21468 |        412 |        841 | isa                   |
--    |     2128 |        321 |        197 | has_tradename         |
--    |    13937 |        298 |       1354 | consists_of           |
--    |     4765 |        264 |         90 | constitutes           |
--    |     2004 |        191 |         21 | precise_ingredient_of |
--    |    15332 |        190 |        164 | has_quantified_form   |
--    |    16101 |        173 |         44 | ingredients_of        |
--    |     1199 |         13 |         18 | quantified_form_of    |
--    |      207 |          3 |          3 | contains              |
--    +----------+------------+------------+-----------------------+

-- ###############################################################
-- KEYWORDS comparison

select keyword_len, count(distinct RXCUI) cnt
from bioportal.RXNCONSO_curated
group by keyword_len order by keyword_len asc;

--    (bioportal)
--    +-------------+-----+
--    | keyword_len | cnt |
--    +-------------+-----+
--    |        NULL | 177 |
--    |           5 |  48 |
--    |           6 |  86 |
--    |           7 | 586 |
--    |           8 | 764 |
--    |           9 | 287 |
--    |          10 | 157 |
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
--    |        NULL | 380565 |
--    |           4 |      3 |
--    |           5 |    173 |
--    |           6 |    564 |
--    |           7 |   3207 |
--    |           8 |   4670 |
--    |           9 |    898 |
--    |          10 |    647 |
--    |          11 |    219 |
--    |          12 |     32 |
--    |          13 |    253 |
--    |          14 |     10 |
--    |          15 |     11 |
--    +-------------+--------+

-- #####
-- DIFF (set difference)

drop    table if exists opioid.all_keywords_DIFF_bioportal;
create  table           opioid.all_keywords_DIFF_bioportal
select  distinct A.*
from    all_rxcui_str.RXNCONSO_curated A
where   A.keyword_len > 1
and     A.RXCUI not in (select distinct RXCUI from bioportal.RXNCONSO_curated);

-- ###############################################################
-- DIFF analyze set differences

-- ####
-- TTY Term Types
select  count(distinct C.RXCUI) as cnt,
        U.TTY, U.TTY_STR
from    all_rxcui_str.RXNCONSO_curated C,
        opioid.all_keywords_DIFF_bioportal D,
        umls_tty U
where   C.RXCUI = D.RXCUI
and     U.TTY = C.TTY
group by U.TTY, U.TTY_STR
order by cnt desc;

--     (all_rxcui_str)
--    +------+-------------+-------------------------------------------------------------------------+
--    | cnt  | TTY         | TTY_STR                                                                 |
--    +------+-------------+-------------------------------------------------------------------------+
--    | 3440 | TMSY        | Tall Man synonym                                                        |
--    | 1669 | SY          | Designated synonym                                                      |
--    | 1186 | BD          | Fully-specified drug brand name that can be prescribed                  |
--    | 1031 | CD          | Clinical Drug                                                           |
--    | 1011 | SBD         | Semantic branded drug                                                   |
--    |  962 | SCD         | Semantic Clinical Drug                                                  |
--    |  841 | SBDC        | Semantic Branded Drug Component                                         |
--    |  725 | CDA         | Clinical drug name in abbreviated format                                |
--    |  725 | CDC         | Clinical drug name in concatenated format (NDDF)                        |
--    |  725 | CDD         | Clinical drug name in delimited format                                  |
--    |  724 | SBDFP       | Semantic branded drug and form w/ precise ingredient as basis strength  |
--    |  666 | BN          | Fully-specified drug brand name that can not be prescribed              |
--    |  661 | SBDG        | Semantic branded drug group                                             |
--    |  649 | SBDF        | Semantic branded drug and form                                          |
--    |  558 | PSN         | Prescribable Names                                                      |
--    |  484 | PT          | Designated preferred name                                               |
--    |  483 | FN          | Full form of descriptor                                                 |
--    |  394 | SCDGP       | Semantic clinical drug group w/ precise ingredient as basis strength    |
--    |  287 | SCDFP       | Semantic clinical drug and form w/ precise ingredient as basis strength |
--    |  281 | IN          | Name for an ingredient                                                  |
--    |  272 | SCDG        | Semantic clinical drug group                                            |
--    |  249 | AB          | Abbreviation in any source vocabulary                                   |
--    |  210 | SCDC        | Semantic Drug Component                                                 |
--    |  193 | SCDF        | Semantic clinical drug and form                                         |
--    |  172 | MIN         | name for a multi-ingredient                                             |
--    |  170 | DP          | Drug Product                                                            |
--    |  135 | GN          | Generic drug name                                                       |
--    |   59 | SU          | Active Substance                                                        |

-- ####
-- REL Relationships

select  count(distinct A.RXCUI)  as cnt_rxcui1,
        count(distinct A.RXCUI2) as cnt_rxcui2,
        U.REL,
        U.REL_STR
from    all_rxcui_str.RXNCONSO_curated_rela A,
        opioid.all_keywords_DIFF_bioportal  D,
        umls_rel U
where   A.rel=U.rel and A.RXCUI2 = D.RXCUI
group by U.REL,U.REL_STR
order by cnt_rxcui1 desc, cnt_rxcui2 desc;

--    +------------+------------+-----+--------------------------------------------------------------+
--    | cnt_rxcui1 | cnt_rxcui2 | REL | REL_STR                                                      |
--    +------------+------------+-----+--------------------------------------------------------------+
--    |       7436 |       5727 | RO  | has relationship other than synonymous, narrower, or broader |
--    |       6701 |       3918 | RB  | has a broader relationship                                   |
--    |       5531 |       6179 | RN  | has a narrower relationship                                  |
--    +------------+------------+-----+--------------------------------------------------------------+

-- ####
-- REL Attributes

drop    table if exists opioid.RXNCONSO_curated_rela__all_keywords_DIFF_bioportal;
create  table           opioid.RXNCONSO_curated_rela__all_keywords_DIFF_bioportal
select  distinct        A.REL, A.RELA, A.RXCUI, A.RXCUI2, A.STR
from    all_rxcui_str.RXNCONSO_curated_rela A,
        opioid.all_keywords_DIFF_bioportal  D
where   A.RXCUI2 = D.RXCUI;

-- 155462 rows in set

select  RELA,
        count(distinct RXCUI) as cnt_rxcui1,
        count(distinct RXCUI2) as cnt_rxcui2
from    opioid.RXNCONSO_curated_rela__all_keywords_DIFF_bioportal
group by RELA
order by cnt_rxcui1 desc, cnt_rxcui2 desc;

--    +------------------------+------------+------------+
--    | RELA                   | cnt_rxcui1 | cnt_rxcui2 |
--    +------------------------+------------+------------+
--    | ingredient_of          |       4198 |        438 |
--    | isa                    |       4185 |       3102 |
--    | has_tradename          |       3952 |       1184 |
--    | inverse_isa            |       3136 |       3180 |
--    | tradename_of           |       1712 |       4295 |
--    | consists_of            |       1662 |       1973 |
--    | form_of                |       1384 |       1451 |
--    | constitutes            |       1287 |       1051 |
--    | has_form               |       1013 |        976 |
--    | precise_ingredient_of  |        986 |         39 |
--    | has_ingredient         |        734 |       3837 |
--    | ingredients_of         |        616 |        172 |
--    | has_quantified_form    |        363 |        299 |
--    | boss_of                |        287 |         29 |
--    | has_ingredients        |        182 |        491 |
--    | part_of                |        174 |         20 |
--    | quantified_form_of     |        156 |        193 |
--    | has_boss               |         89 |        287 |
--    | has_part               |         80 |        172 |
--    | has_precise_ingredient |         62 |        504 |
--    | has_dose_form          |         27 |       2820 |
--    | has_doseformgroup      |         14 |        933 |
--    | contains               |         13 |          5 |
--    | reformulated_to        |          7 |          7 |
--    | reformulation_of       |          7 |          7 |
--    | contained_in           |          4 |         11 |
--    +------------------------+------------+------------+

select  REL, RELA,
        count(distinct RXCUI) as cnt_rxcui1,
        count(distinct RXCUI2) as cnt_rxcui2
from    opioid.RXNCONSO_curated_rela__all_keywords_DIFF_bioportal
group by REL,RELA
order by cnt_rxcui1 desc, cnt_rxcui2 desc;

--    +------+------------------------+------------+------------+
--    | REL  | RELA                   | cnt_rxcui1 | cnt_rxcui2 |
--    +------+------------------------+------------+------------+
--    | RO   | ingredient_of          |       4198 |        438 |
--    | RN   | isa                    |       4185 |       3102 |
--    | RB   | has_tradename          |       3952 |       1184 |
--    | RB   | inverse_isa            |       3136 |       3180 |
--    | RN   | tradename_of           |       1712 |       4295 |
--    | RO   | consists_of            |       1662 |       1973 |
--    | RN   | form_of                |       1384 |       1451 |
--    | RO   | constitutes            |       1287 |       1051 |
--    | RB   | has_form               |       1013 |        976 |
--    | RO   | has_ingredient         |        734 |       3837 |
--    | RB   | precise_ingredient_of  |        677 |         38 |
--    | RO   | ingredients_of         |        616 |        172 |
--    | RB   | has_quantified_form    |        363 |        299 |
--    | RO   | precise_ingredient_of  |        309 |         26 |
--    | RO   | boss_of                |        287 |         29 |
--    | RO   | has_ingredients        |        182 |        491 |
--    | RO   | part_of                |        174 |         20 |
--    | RN   | quantified_form_of     |        156 |        193 |
--    | RO   | has_boss               |         89 |        287 |
--    | RO   | has_part               |         80 |        172 |
--    | RN   | has_precise_ingredient |         59 |        385 |
--    | RO   | has_dose_form          |         27 |       2820 |
--    | RO   | has_precise_ingredient |         23 |        119 |
--    | RO   | has_doseformgroup      |         14 |        933 |
--    | RN   | contains               |         13 |          5 |
--    | RO   | reformulated_to        |          7 |          7 |
--    | RO   | reformulation_of       |          7 |          7 |
--    | RB   | contained_in           |          4 |         11 |
--    +------+------------------------+------------+------------+