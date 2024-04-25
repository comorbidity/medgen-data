-- $CURATED sets in this file:
--    bioportal
--    bioportal_to_umls

-- ###############################################################
-- [bioportal_to_umls] stats

select * from bioportal_to_umls.stats_expand;
--    +------------+------------+
--    | cnt_rxcui1 | cnt_rxcui2 |
--    +------------+------------+
--    |       5205 |       5758 |
--    +------------+------------+

select * from bioportal_to_umls.stats_rela;
--    +------+------------------------+------------+------------+
--    | REL  | RELA                   | cnt_rxcui1 | cnt_rxcui2 |
--    +------+------------------------+------------+------------+
--    | RO   | ingredient_of          |       4109 |        706 |
--    | RB   | has_tradename          |       3572 |       1640 |
--    | RB   | inverse_isa            |       3248 |       3619 |
--    | RO   | dose_form_of           |       3099 |         30 |
--    | RO   | constitutes            |       2297 |       1578 |
--    | RN   | isa                    |       2226 |       2984 |
--    | RN   | tradename_of           |       1612 |       5585 |
--    | RO   | consists_of            |       1224 |       2553 |
--    | RO   | doseformgroup_of       |        984 |         16 |
--    | RN   | form_of                |        914 |        971 |
--    | RO   | ingredients_of         |        510 |        127 |
--    | RB   | has_form               |        466 |        430 |
--    | RB   | has_quantified_form    |        343 |        283 |
--    | RN   | quantified_form_of     |        283 |        343 |
--    | RO   | precise_ingredient_of  |        193 |         23 |
--    | RO   | boss_of                |        154 |         54 |
--    | RO   | has_ingredient         |        100 |       3504 |
--    | RB   | precise_ingredient_of  |         69 |         33 |
--    | RO   | has_ingredients        |         44 |        334 |
--    | RO   | part_of                |         44 |         33 |
--    | RO   | has_boss               |         27 |        442 |
--    | RO   | has_part               |         22 |        403 |
--    | RO   | has_precise_ingredient |         21 |        294 |
--    | RN   | has_precise_ingredient |         20 |        652 |
--    | RB   | contained_in           |          5 |          5 |
--    | RN   | contains               |          5 |          5 |
--    | RO   | reformulated_to        |          1 |          1 |
--    +------+------------------------+------------+------------+

-- ###############################################################
-- [Assert #1] Subset: all RXCUI **should** be included.

select  distinct B.*
from    bioportal.curated B
where   RXCUI not in (select distinct RXCUI from bioportal_to_umls.curated);

-- #####
-- AND (set intersection)

drop    table if exists opioid.bioportal_to_umls_AND_bioportal;
create  table opioid.bioportal_to_umls_AND_bioportal
select  distinct B.*
from    bioportal_to_umls.RXNCONSO_curated B, bioportal.curated V
where   B.RXCUI = V.RXCUI;

-- #####
-- DIFF (set difference)

drop    table if exists opioid.bioportal_to_umls_DIFF_bioportal;
create  table opioid.bioportal_to_umls_DIFF_bioportal
select  distinct B.*
from    bioportal_to_umls.RXNCONSO_curated B
where   RXCUI not in (select distinct RXCUI from bioportal.curated);

-- ###############################################################
-- DIFF analyze set differences

-- ####
-- TTY Term Types
select  U.TTY, U.TTY_STR, count(distinct C.RXCUI) as cnt
from    bioportal_to_umls.RXNCONSO_curated C,
        opioid.bioportal_to_umls_DIFF_bioportal D,
        umls_tty U
where   C.RXCUI = D.RXCUI
and     U.TTY = C.TTY
group by U.TTY, U.TTY_STR
order by cnt desc;

--    +-------------+-------------------------------------------------------------------------+------+
--    | TTY         | TTY_STR                                                                 | cnt  |
--    +-------------+-------------------------------------------------------------------------+------+
--    | TMSY        | Tall Man synonym                                                        | 1988 |
--    | SY          | Designated synonym                                                      | 1265 |
--    | SBD         | Semantic branded drug                                                   |  812 |
--    | SCD         | Semantic Clinical Drug                                                  |  759 |
--    | BD          | Fully-specified drug brand name that can be prescribed                  |  702 |
--    | SBDC        | Semantic Branded Drug Component                                         |  657 |
--    | SBDG        | Semantic branded drug group                                             |  554 |
--    | SBDF        | Semantic branded drug and form                                          |  451 |
--    | PSN         | Prescribable Names                                                      |  434 |
--    | CD          | Clinical Drug                                                           |  414 |
--    | CDA         | Clinical drug name in abbreviated format                                |  269 |
--    | CDC         | Clinical drug name in concatenated format (NDDF)                        |  269 |
--    | CDD         | Clinical drug name in delimited format                                  |  269 |
--    | SCDGP       | Semantic clinical drug group w/ precise ingredient as basis strength    |  186 |
--    | FN          | Full form of descriptor                                                 |  181 |
--    | PT          | Designated preferred name                                               |  181 |
--    | SCDFP       | Semantic clinical drug and form w/ precise ingredient as basis strength |  154 |
--    | AB          | Abbreviation in any source vocabulary                                   |  136 |
--    | BN          | Fully-specified drug brand name that can not be prescribed              |  109 |
--    | SBDFP       | Semantic branded drug and form w/ precise ingredient as basis strength  |  105 |
--    | IN          | Name for an ingredient                                                  |   85 |
--    | DP          | Drug Product                                                            |   74 |
--    | GN          | Generic drug name                                                       |   69 |
--    | MIN         | name for a multi-ingredient                                             |   44 |
--    | SU          | Active Substance                                                        |   43 |
--    | SCDF        | Semantic clinical drug and form                                         |   41 |
--    | FSY         | Foreign Synonym                                                         |   23 |
--    | PIN         | Name from a precise ingredient                                          |   21 |
--    | SCDC        | Semantic Drug Component                                                 |   14 |
--    | SCDG        | Semantic clinical drug group                                            |    9 |
--    | MTH_RXN_CD  | RxNorm Created CD                                                       |    6 |
--    | MTH_RXN_BD  | RxNorm Created BD                                                       |    6 |
--    | SYGB        | British synonym                                                         |    3 |
--    | MTH_RXN_CDC | RxNorm Created CDC                                                      |    2 |
--    | BPCK        | Branded Drug Delivery Device                                            |    2 |
--    | GPCK        | Generic Drug Delivery Device                                            |    1 |
--    +-------------+-------------------------------------------------------------------------+------+


-- ####
-- REL Relationships

select  U.REL, U.REL_STR,
        count(distinct V.RXCUI) as cnt_rxcui1,
        count(distinct V.RXCUI2) as cnt_rxcui2
from    bioportal.RXNCONSO_curated_rela V,
        opioid.bioportal_to_umls_DIFF_bioportal D,
        umls_rel U
where   V.rel=U.rel and V.RXCUI2 = D.RXCUI
group by U.REL,U.REL_STR
order by cnt_rxcui1 desc, cnt_rxcui2 desc;

--    +-----+--------------------------------------------------------------+------------+------------+
--    | REL | REL_STR                                                      | cnt_rxcui1 | cnt_rxcui2 |
--    +-----+--------------------------------------------------------------+------------+------------+
--    | RO  | has relationship other than synonymous, narrower, or broader |       1482 |       1533 |
--    | RN  | has a narrower relationship                                  |        853 |       3210 |
--    | RB  | has a broader relationship                                   |        833 |        530 |
--    +-----+--------------------------------------------------------------+------------+------------+

drop    table if exists opioid.RXNCONSO_curated_rela__bioportal_to_umls_DIFF_bioportal;
create  table opioid.RXNCONSO_curated_rela__bioportal_to_umls_DIFF_bioportal
select  distinct REL, RELA, RXCUI, RXCUI2, STR
from bioportal_to_umls.RXNCONSO_curated_rela where RXCUI2 not in (
    select distinct RXCUI from bioportal.curated)
order by RXCUI, RXCUI2;

--    +------+----------------+---------+---------+-----------------------------------------------------------------------------------------------------------------------------------------+
--    | REL  | RELA           | RXCUI   | RXCUI2  | STR                                                                                                                                     |
--    +------+----------------+---------+---------+-----------------------------------------------------------------------------------------------------------------------------------------+
--    | RO   | dose_form_of   | 1010600 | 2269578 | buprenorphine 2 MG / naloxone 0.5 MG Buccal Film                                                                                        |
--    | RO   | dose_form_of   | 1010600 | 2269578 | buprenorphine 2 MG / naloxone 0.5 MG Sublingual Film                                                                                    |
--    | RO   | dose_form_of   | 1010600 | 2269578 | BUPRENORPHINE 2MG/NALOXONE 0.5MG FILM,SUBLINGUAL                                                                                        |
--    | RO   | dose_form_of   | 1010600 | 2269578 | BUPRENORPHINE 2MG/NALOXONE 0.5MG SL FILM                                                                                                |
--    ...
--    174552 rows in set
--
--    TODO: notice! dose_form_of here is "Sublingual Film", not an opioid

select  distinct REL, RELA,
        count(distinct RXCUI) cnt_rxcui1,
        count(distinct RXCUI2) cnt_rxcui2
from    opioid.RXNCONSO_curated_rela__bioportal_to_umls_DIFF_bioportal
group by REL, RELA
order by cnt_rxcui1 desc, cnt_rxcui2 desc;

--    +------+------------------------+------------+------------+
--    | REL  | RELA                   | cnt_rxcui1 | cnt_rxcui2 |
--    +------+------------------------+------------+------------+
--    | RO   | ingredient_of          |       4109 |        706 |
--    | RO   | dose_form_of           |       3099 |         30 | -eXclude
--    | RB   | inverse_isa            |       2622 |       2893 |
--    | RB   | has_tradename          |       2057 |        734 | +include
--    | RN   | isa                    |       1800 |       1953 |
--    | RO   | constitutes            |       1444 |       1025 |
--    | RN   | tradename_of           |       1175 |       4672 | +include
--    | RO   | doseformgroup_of       |        984 |         16 |
--    | RO   | consists_of            |        968 |       1827 |
--    | RN   | form_of                |        914 |        971 |
--    | RO   | ingredients_of         |        510 |        127 |
--    | RB   | has_quantified_form    |        323 |        270 | +include
--    | RO   | precise_ingredient_of  |        193 |         23 |
--    | RO   | boss_of                |        154 |         54 |
--    | RN   | quantified_form_of     |        125 |        151 | +include
--    | RB   | precise_ingredient_of  |         69 |         33 |
--    | RO   | has_ingredient         |         63 |       2224 |
--    | RO   | part_of                |         44 |         33 |
--    | RO   | has_ingredients        |         33 |        161 |
--    | RO   | has_boss               |         27 |        442 |
--    | RO   | has_part               |         22 |        403 |
--    | RB   | has_form               |         21 |         16 |
--    | RN   | has_precise_ingredient |         20 |        652 |
--    | RO   | has_precise_ingredient |         17 |        103 |
--    | RN   | contains               |          3 |          3 |
--    | RO   | reformulated_to        |          1 |          1 |
--    +------+------------------------+------------+------------+



