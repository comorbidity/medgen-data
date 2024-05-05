-- ##############################################
call log('umls_meta.sql', 'begin');

call log('umls_tui', 'UMLS Semantic Type');
call log('umls_tui', 'https://lhncbc.nlm.nih.gov/ii/tools/MetaMap/Docs/SemanticTypes_2018AB.txt'); 

drop table if exists umls_tui;
create table umls_tui
(
 STY        varchar(4)	NOT NULL,
 TUI        varchar(4)	NOT NULL,
 TUI_STR    varchar(50) NOT NULL
);    

load data local infile 'infile/common/umls_tui.tsv' into table umls_tui ignore 1 lines;
show warnings; 

call create_index('umls_tui','TUI');

-- ##############################################
call log('umls_tty', 'Term Type in source'); 

drop table if exists umls_tty;
create table umls_tty
(
 TTY        varchar(11) NOT NULL,
 TTY_STR    varchar(80) NOT NULL
);    

load data local infile 'infile/common/umls_tty.tsv'  into table umls_tty  ignore 1 lines;
show warnings;

call create_index('umls_tty','TTY');

-- ##############################################
call log('umls_rel', 'relationships'); 

drop table if exists umls_rel;
create table umls_rel
(
 REL        varchar(8)	NOT NULL,
 REL_STR    varchar(70) NOT NULL
);    

load data local infile 'infile/common/umls_rel.tsv' into table umls_rel ignore 1 lines;
show warnings;

call create_index('umls_rel','REL');

-- ##############################################
call log('umls_rela', 'relationship attributes'); 

drop table if exists umls_rela;
create table umls_rela
(
 RELA       varchar(100)	NOT NULL,
 RELA_STR   varchar(100) 	NULL
);    

load data local infile 'infile/common/umls_rela.tsv' into table umls_rela ignore 1 lines;
show warnings;

call create_index('umls_rela','RELA');

-- ##############################################
call log('umls_meta.sql', 'done');
