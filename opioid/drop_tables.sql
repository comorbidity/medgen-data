-- ##############################################
call log('drop_tables.sql', 'begin');

-- curated
drop table if exists    curated,
                        curated_keywords,
                        RXNCONSO_curated_all_rxcui_str,
                        RXNCONSO_curated_VSAC_Mathematica,
                        RXNCONSO_curated_bioportal,
                        RXNCONSO_curated_bioportal_to_umls,
                        RXNCONSO_curated_wasz_april7;

-- RXNCONSO_curated
drop table if exists    RXNCONSO_curated, RXNCONSO_curated_rela,
                        RXNCONSO_curated_all_rxcui_str,
                        RXNCONSO_curated_VSAC_Mathematica,
                        RXNCONSO_curated_bioportal,
                        RXNCONSO_curated_bioportal_to_umls,
                        RXNCONSO_curated_wasz_april7,
                        RXNCONSO_curated_jaccard;

-- UMLS Semantic Network
drop table if exists RXNSTY_curated;
drop table if exists RXNREL_curated;

-- UMLS (expand from curated)
drop table if exists    expand,
                        expand_all_rxcui_str,
                        expand_VSAC_Mathematica,
                        expand_bioportal,
                        expand_bioportal_to_umls,
                        expand_wasz_april7,
                        expand_jaccard;


-- Exapnd (REL+RELA Relationship walks) 
drop table if exists    expand,
                        expand_cui,
                        expand_cui_str,
                        expand_cui_rela_str,
                        expand_cui_rela_cui,
                        expand_tradename,
                        expand_consists,
                        expand_isa,
                        expand_ingredient,
                        expand_ingredients,
                        expand_doseform,
                        expand_form;

-- Statistics
drop table if exists    stats_keywords,
                        stats_expand,
                        stats_tty,
                        stats_rel,
                        stats_rela,
                        stats_tui,
                        stats_sab;

-- keywords
--    drop table if exists    keywords,
--                            keywords_orig,
--                            keywords_str_in_str;

-- UMLS abbreviations
--    drop table if exists umls_rel;
--    drop table if exists umls_rela;
--    drop table if exists umls_tty;
--    drop table if exists umls_tui;

-- ##############################################
call log('drop_tables.sql', 'done');




