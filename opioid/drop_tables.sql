-- Curated tables
drop table if exists curated;
drop table if exists RXNSTY_curated;
drop table if exists RXNREL_curated;
drop table if exists RXNCONSO_curated;
drop table if exists RXNCONSO_curated_rela;

-- Exapnd (REL+RELA Relationship walks) 
drop table if exists expand;
drop table if exists expand_cui;
drop table if exists expand_cui_str;
drop table if exists expand_cui_rela_str;
drop table if exists expand_cui_rela_cui;
drop table if exists expand_tradename;
drop table if exists expand_consists;
drop table if exists expand_isa;
drop table if exists expand_ingredient;
drop table if exists expand_ingredients;
drop table if exists expand_doseform;
drop table if exists expand_form;

-- UMLS abbrevaiations
drop table if exists umls_rel;
drop table if exists umls_rela;
drop table if exists umls_tty;
drop table if exists umls_tui;

-- Statistics 
drop table if exists stats_tty;
drop table if exists stats_rel;
drop table if exists stats_rela;
drop table if exists stats_tui; 
drop table if exists stats_sab;



