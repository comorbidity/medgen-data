-- ##############################################
call log('umls_tty', 'Term Type in source'); 

drop table if exists umls_tty;
create table umls_tty
(
 TTY  varchar(11)	NOT NULL,
 TTY_STR   varchar(50) 	NULL
);    

load data local infile 'UMLS_TTY.tsv' 
into table umls_tty
fields terminated by '\t'
optionally enclosed by '"' 
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
ignore 1 lines;

show warnings; 

call create_index('umls_tty','TTY');

-- ##############################################
call log('umls_rel', 'relationships'); 

drop table if exists umls_rel;
create table umls_rel
(
 REL varchar(8)	NOT NULL,
 REL_STR   varchar(50) 	NULL
);    

load data local infile 'UMLS_REL.tsv' 
into table umls_rel
fields terminated by '\t'
optionally enclosed by '"' 
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
ignore 1 lines;

show warnings; 

call create_index('umls_rel','REL');

-- ##############################################
call log('umls_rela', 'relationship attributes'); 

drop table if exists umls_rela;
create table umls_rela
(
 RELA varchar(100)	NOT NULL,
 RELA_STR   varchar(100) 	NULL
);    

load data local infile 'UMLS_RELA.tsv' 
into table umls_rela
fields terminated by '\t'
optionally enclosed by '"' 
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
ignore 1 lines;

show warnings; 

call create_index('umls_rela','RELA');
