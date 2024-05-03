call log('jaccard_self.sql', 'begin');

-- $CURATED sets in this file:

--    vsac_math
--    bioportal
--    bioportal_to_umls
--    custom_rxcui_str
--    all_rxcui_str
--    wasz_april7

-- ###############################################################
-- [Assert #1] Verify curated RXCUI were found in RXNORM

select * from vsac_math.curated where RXCUI not in
(select distinct RXCUI from vsac_math.RXNCONSO_curated);

select * from bioportal.curated where RXCUI not in
(select distinct RXCUI from bioportal.RXNCONSO_curated);

-- ###############################################################
call log('bioportal_to_umls.RXNCONSO_curated', 'missing 2 RXCUI');

select * from bioportal_to_umls.curated where RXCUI not in
(select distinct RXCUI from bioportal_to_umls.RXNCONSO_curated);

--    +--------+----------------------------------------------------------------+
--    | RXCUI  | STR                                                            |
--    +--------+----------------------------------------------------------------+
--    | 149373 | 12 HR tapentadol 200 MG Extended Release Oral Tablet [Nucynta] |
--    | 187503 | Tylenol with Codeine Pill                                      |
--    +--------+----------------------------------------------------------------+


-- ###############################################################
call log('wasz_april7.RXNCONSO_curated', 'missing 2 RXCUI');

select * from wasz_april7.curated where RXCUI not in
(select distinct RXCUI from wasz_april7.RXNCONSO_curated);

--    +--------+----------------------------------------------------------------+
--    | RXCUI  | STR                                                            |
--    +--------+----------------------------------------------------------------+
--    | 149373 | 12 HR tapentadol 200 MG Extended Release Oral Tablet [Nucynta] |
--    | 187503 | Tylenol with Codeine Pill                                      |
--    +--------+----------------------------------------------------------------+

call log('jaccard_self.sql', 'done');
