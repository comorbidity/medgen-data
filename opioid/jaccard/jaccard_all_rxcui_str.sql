-- $CURATED sets in this file:
--    all_rxcui_str
--    rxnorm

select  count(distinct RXCUI) cnt_rxcui1,
        count(distinct RXCUI2) cnt_rxcui2, RELA
from    all_rxcui_str.RXNCONSO_curated_rela
group by RELA order
by cnt_rxcui1 desc, cnt_rxcui2 ;

drop    table if exists rxnorm.stats_expand_rela;
create  table rxnorm.stats_expand_rela
select  count(distinct RXCUI1) as cnt_rxcui1,
        count(distinct RXCUI2) as cnt_rxcui2, RELA
from    rxnorm.RXNREL
group by RELA order
by cnt_rxcui1 desc, cnt_rxcui2 ;

--    +------------+------------+------------------------+
--    | cnt_rxcui1 | cnt_rxcui2 | RELA                   |
--    +------------+------------+------------------------+
--    |     134062 |      16148 | ingredient_of          |
--    |      95033 |      78625 | inverse_isa            |
--    |      92822 |      48049 | has_tradename          |
--    |      92331 |        126 | dose_form_of           |
--    |      78625 |      95033 | isa                    |
--    |      61607 |      46397 | constitutes            |
--    |      48049 |      92822 | tradename_of           |
--    |      46397 |      61607 | consists_of            |
--    |      35764 |         43 | doseformgroup_of       |
--    |      17301 |      15207 | has_form               |
--    |      16148 |     134062 | has_ingredient         |
--    |      15207 |      17301 | form_of                |
--    |      11659 |       3800 | ingredients_of         |
--    |       9642 |       1619 | precise_ingredient_of  |
--    |       6210 |       4855 | has_quantified_form    |
--    |       4855 |       6210 | quantified_form_of     |
--    |       4290 |       1546 | boss_of                |
--    |       3800 |       1913 | part_of                |
--    |       3800 |      11659 | has_ingredients        |
--    |       1913 |       3800 | has_part               |
--    |       1753 |       1092 | contained_in           |
--    |       1619 |       9642 | has_precise_ingredient |
--    |       1546 |       4290 | has_boss               |
--    |       1092 |       1753 | contains               |
--    |        126 |      92331 | has_dose_form          |
--    |         54 |         54 | reformulated_to        |
--    |         54 |         54 | reformulation_of       |
--    |         43 |      35764 | has_doseformgroup      |
--    +------------+------------+------------------------+
