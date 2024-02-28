call log('create_index.sql', 'begin');

call create_index('MRCONSO', 'CUI');
call create_index('MRCONSO', 'AUI');
call create_index('MRCONSO', 'CODE');
call create_index('MRCONSO', 'STR(255)');
call create_index('MRCONSO', 'SAB');
call create_index('MRCONSO', 'SAB,CODE');
call create_index('MRCONSO', 'SAB,CUI'); 
call create_index('MRCONSO', 'LAT');

call create_index('MRHIER', 'CUI');
call create_index('MRHIER', 'AUI');
call create_index('MRHIER', 'SAB');
call create_index('MRHIER', 'RELA');
call create_index('MRHIER', 'PTR');
call create_index('MRHIER', 'HCD');

call create_index('MRSTY', 'CUI');
call create_index('MRSTY', 'TUI');
call create_index('MRSTY', 'STY'); 

call create_index('MRREL', 'SAB');
call create_index('MRREL', 'SL');
call create_index('MRREL', 'SL,SAB');

call create_index('MRREL', 'CUI1');
call create_index('MRREL', 'CUI2');
call create_index('MRREL', 'AUI1');
call create_index('MRREL', 'AUI2');
call create_index('MRREL', 'STYPE1');
call create_index('MRREL', 'REL');
call create_index('MRREL', 'RELA');
call create_index('MRREL', 'REL, RELA');
call create_index('MRREL', 'CUI1,CUI2,REL');

-- ##########################################

call log('create_index.sql', 'done');

call log('MRCONSO_LAT', 'begin');

create table MRCONSO_LAT
select * from MRCONSO where LAT != 'ENG';

call log('MRCONSO_LAT', 'done');

call create_index('MRCONSO_LAT', 'CUI');
call create_index('MRCONSO_LAT', 'AUI');
call create_index('MRCONSO_LAT', 'CUI, AUI');

delete from MRCONSO where LAT != 'ENG';

-- ##########################################
