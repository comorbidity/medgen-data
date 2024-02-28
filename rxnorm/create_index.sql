-- #################################################################
call log('create_index.sql','rxnorm');
-- #################################################################

call create_index('RXNCONSO','STR(255)'); 
call create_index('RXNCONSO','RXCUI');
call create_index('RXNCONSO','TTY');
call create_index('RXNCONSO','CODE');

-- #################################################################

call create_index('RXNSAT','RXCUI'); 
call create_index('RXNSAT','ATV(255)');
call create_index('RXNSAT','ATN');

-- #################################################################

call create_index('RXNREL','RXCUI1'); 
call create_index('RXNREL','RXCUI2');
call create_index('RXNREL','RELA');

-- #################################################################

call create_index('RXNATOMARCHIVE','RXAUI'); 
call create_index('RXNATOMARCHIVE','RXCUI');
call create_index('RXNATOMARCHIVE','MERGED_TO_RXCUI');

-- #################################################################
call log('create_index.sql','done'); 
