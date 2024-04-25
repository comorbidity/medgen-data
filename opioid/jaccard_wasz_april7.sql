-- $CURATED sets in this file:
--    wasz_april7
--    all_rxcui_str

-- ###############################################################
-- [wasz_april7] stats

select * from wasz_april7.stats_expand;
--    +------------+------------+
--    | cnt_rxcui1 | cnt_rxcui2 |
--    +------------+------------+
--    |       7703 |       5101 |
--    +------------+------------+

select * from wasz_april7.stats_rela;
--    +------+------------------------+------------+------------+
--    | REL  | RELA                   | cnt_rxcui1 | cnt_rxcui2 |
--    +------+------------------------+------------+------------+
--    | RO   | ingredient_of          |       5858 |        858 |
--    | RB   | has_tradename          |       5045 |       1989 |
--    | RB   | inverse_isa            |       4565 |       5137 |
--    | RN   | isa                    |       4148 |       4685 |
--    | RO   | dose_form_of           |       4137 |         36 |
--    | RO   | constitutes            |       2841 |       1909 |
--    | RN   | tradename_of           |       2084 |       7291 |
--    | RN   | form_of                |       1722 |       1818 |
--    | RO   | consists_of            |       1668 |       3795 |
--    | RO   | doseformgroup_of       |       1573 |         20 |
--    | RB   | has_form               |       1329 |       1269 |
--    | RO   | ingredients_of         |        817 |        195 |
--    | RO   | has_ingredient         |        451 |       5523 |
--    | RO   | boss_of                |        433 |        107 |
--    | RB   | precise_ingredient_of  |        389 |         58 |
--    | RB   | has_quantified_form    |        367 |        302 |
--    | RO   | precise_ingredient_of  |        332 |         29 |
--    | RN   | quantified_form_of     |        302 |        367 |
--    | RO   | has_ingredients        |        279 |       1466 |
--    | RO   | part_of                |        279 |        101 |
--    | RN   | has_precise_ingredient |         37 |        719 |
--    | RO   | has_boss               |         35 |        484 |
--    | RO   | has_precise_ingredient |         29 |        332 |
--    | RO   | has_part               |         22 |        403 |
--    | RN   | contains               |         18 |         33 |
--    | RO   | reformulated_to        |          8 |          8 |
--    | RO   | reformulation_of       |          8 |          8 |
--    | RB   | contained_in           |          5 |          5 |
--    +------+------------------------+------------+------------+

-- ###############################################################
-- All KEYWORDS comparison

-- #####
-- AND (set intersection)

drop    table if exists opioid.all_keywords_AND_wasz_april7;
create  table opioid.all_keywords_AND_wasz_april7
select  distinct W.*
from    all_rxcui_str.RXNCONSO_curated A,
        wasz_april7.RXNCONSO_curated W
where   A.RXCUI = W.RXCUI
and     A.keyword_len > 1;

-- #####
-- DIFF (set difference)

drop    table if exists opioid.all_keywords_DIFF_wasz_april7;
create  table opioid.all_keywords_DIFF_wasz_april7
select  distinct A.*
from    all_rxcui_str.RXNCONSO_curated A
where   A.keyword_len > 1
and     A.RXCUI not in (select distinct RXCUI from wasz_april7.RXNCONSO_curated)
order   by STR asc;

-- ###############################################################
-- DIFF analyze set differences

select keyword_str, count(distinct RXCUI) cnt
from opioid.all_keywords_DIFF_wasz_april7 group by keyword_str order by cnt desc;

--    +----------------+-----+
--    | keyword_str    | cnt |
--    +----------------+-----+
--    | codeine        | 493 |
--    | hydrocod       | 433 |
--    | morphine       | 266 |
--    | fentanyl       | 255 |
--    | morphone       | 161 |
--    | naltrexone     |  70 |
--    | sufenta        |  54 |
--    | opana          |  52 |
--    | ultram         |  46 |
--    | methadone      |  39 |
--    | tramadol       |  39 |
--    | buprenorphine  |  31 |
--    | naloxone       |  31 |
--    | oxycodone      |  29 |
--    | codimal        |  26 |
--    | meperidine     |  23 |
--    | atuss g        |  22 |
--    | relcof         |  22 |
--    | deconsal       |  20 |
--    | maxifed        |  20 |
--    | dolorex        |  19 |
--    | prolex         |  19 |
--    | pentazocin     |  18 |
--    | poly-histine   |  16 |
--    | allfen c       |  14 |
--    | butorphanol    |  11 |
--    | lortab         |  11 |
--    | nalbuphine     |  11 |
--    | nalex          |  11 |
--    | pethidine      |  11 |
--    | de-chlor       |   9 |
--    ...
--    | zomorph        |   1 |

-- ####
-- TTY Term Types
select  U.TTY, U.TTY_STR, count(distinct C.RXCUI) as cnt
from    all_rxcui_str.RXNCONSO_curated C,
        opioid.all_keywords_DIFF_wasz_april7 D,
        umls_tty U
where   C.RXCUI = D.RXCUI
and     U.TTY = C.TTY
group by U.TTY, U.TTY_STR
order by cnt desc;

--    (all_rxcui_str)
--    +-------------+-------------------------------------------------------------------------+-----+
--    | TTY         | TTY_STR                                                                 | cnt |
--    +-------------+-------------------------------------------------------------------------+-----+
--    | CD          | Clinical Drug                                                           | 613 |
--    | CDA         | Clinical drug name in abbreviated format                                | 443 |
--    | CDC         | Clinical drug name in concatenated format (NDDF)                        | 443 |
--    | CDD         | Clinical drug name in delimited format                                  | 443 |
--    | TMSY        | Tall Man synonym                                                        | 422 |
--    | BD          | Fully-specified drug brand name that can be prescribed                  | 397 |
--    | SY          | Designated synonym                                                      | 329 |
--    | PT          | Designated preferred name                                               | 302 |
--    | FN          | Full form of descriptor                                                 | 301 |
--    | BN          | Fully-specified drug brand name that can not be prescribed              | 270 |
--    | SCDGP       | Semantic clinical drug group w/ precise ingredient as basis strength    | 204 |
--    | SCD         | Semantic Clinical Drug                                                  | 189 |
--    | IN          | Name for an ingredient                                                  | 172 |
--    | SBDC        | Semantic Branded Drug Component                                         | 147 |
--    | AB          | Abbreviation in any source vocabulary                                   | 126 |
--    | PSN         | Prescribable Names                                                      | 106 |
--    | SBD         | Semantic branded drug                                                   |  97 |
--    | DP          | Drug Product                                                            |  97 |
--    | SBDF        | Semantic branded drug and form                                          |  80 |
--    | SBDG        | Semantic branded drug group                                             |  77 |
--    | SBDFP       | Semantic branded drug and form w/ precise ingredient as basis strength  |  69 |
--    | SU          | Active Substance                                                        |  44 |
--    | GN          | Generic drug name                                                       |  35 |
--    | SCDC        | Semantic Drug Component                                                 |  26 |
--    | SCDG        | Semantic clinical drug group                                            |  26 |
--    | FSY         | Foreign Synonym                                                         |  25 |
--    | SCDF        | Semantic clinical drug and form                                         |  18 |
--    | SCDFP       | Semantic clinical drug and form w/ precise ingredient as basis strength |  11 |
--    ...
--    +-------------+-------------------------------------------------------------------------+-----+

-- ####
-- REL Relationships

drop    table if exists opioid.RXNCONSO_curated_rela__all_keywords_DIFF_wasz_april7;
create  table opioid.RXNCONSO_curated_rela__all_keywords_DIFF_wasz_april7
select  distinct R.REL, R.RELA, R.RXCUI, R.RXCUI2, R.STR
from    all_rxcui_str.RXNCONSO_curated_rela R,
        opioid.all_keywords_DIFF_wasz_april7 D
where   R.RXCUI = D.RXCUI
and     R.RXCUI2 not in (select distinct RXCUI from wasz_april7.curated);

select  distinct REL, RELA,
        count(distinct RXCUI) cnt_rxcui1,
        count(distinct RXCUI2) cnt_rxcui2
from    opioid.RXNCONSO_curated_rela__all_keywords_DIFF_wasz_april7
group by REL, RELA
order by cnt_rxcui1 desc, cnt_rxcui2 desc;

--    +------+------------------------+------------+------------+
--    | REL  | RELA                   | cnt_rxcui1 | cnt_rxcui2 |
--    +------+------------------------+------------+------------+
--    | RO   | dose_form_of           |        386 |         20 | -eXclude
--    | RB   | has_tradename          |        354 |        269 | +include
--    | RO   | ingredient_of          |        308 |        103 |
--    | RB   | inverse_isa            |        286 |        479 |
--    | RO   | constitutes            |        276 |        270 | ?include
--    | RN   | isa                    |        264 |        193 |
--    | RN   | tradename_of           |        236 |        490 | +include
--    | RN   | form_of                |        105 |        113 |
--    | RO   | doseformgroup_of       |        103 |          9 |
--    | RO   | consists_of            |        100 |        120 |
--    | RB   | has_form               |         87 |         87 |
--    | RO   | has_ingredient         |         44 |        598 | +include
--    | RO   | ingredients_of         |         38 |         26 |
--    | RB   | has_quantified_form    |         33 |         27 |
--    | RN   | quantified_form_of     |         26 |         32 |
--    | RO   | has_part               |         14 |         30 |
--    | RB   | precise_ingredient_of  |         13 |         13 |
--    | RN   | contains               |         11 |          4 |
--    | RO   | boss_of                |         10 |          7 |
--    | RO   | precise_ingredient_of  |          8 |          2 |
--    | RO   | has_ingredients        |          5 |         22 |
--    | RO   | part_of                |          5 |          9 |
--    | RO   | has_boss               |          5 |          8 |
--    | RN   | has_precise_ingredient |          5 |          7 | +include
--    | RB   | contained_in           |          2 |         10 |
--    | RO   | has_precise_ingredient |          2 |          8 | +include
--    +------+------------------------+------------+------------+



