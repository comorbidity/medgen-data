-- ##############################################
call log('drop_curated.sql', 'begin');

-- curated
drop table if exists    curated,
                        curated_keywords,
                        RXNCONSO_curated_all_rxcui_str,
                        RXNCONSO_curated_vsac_math,
                        RXNCONSO_curated_bioportal,
                        RXNCONSO_curated_bioportal_to_umls,
                        RXNCONSO_curated_wasz_april7;

-- RXNCONSO_curated
drop table if exists    RXNCONSO_curated, RXNCONSO_curated_rela,
                        RXNCONSO_curated_all_rxcui_str,
                        RXNCONSO_curated_vsac_math,
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
                        expand_vsac_math,
                        expand_bioportal,
                        expand_bioportal_to_umls,
                        expand_wasz_april7,
                        expand_jaccard;


-- Expand (REL+RELA Relationship walks)
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

-- ##############################################
call log('drop_curated.sql', 'done');




