-- ##############################################
call log('drop_common.sql', 'begin');

-- version
    drop table if exists    version;

-- keywords
    drop table if exists    keywords,
                            keywords_orig,
                            keywords_str_in_str;

-- UMLS abbreviations
    drop table if exists umls_rel;
    drop table if exists umls_rela;
    drop table if exists umls_tty;
    drop table if exists umls_tui;

-- ##############################################
call log('drop_common.sql', 'begin');




