call log('jaccard_medrt.sql', 'begin');

-- $CURATED sets in this file:

--    medrt

-- ###############################################################

--    MRREL_medrt_cui1
--
--    select count(*), count(distinct CUI),  SAB, TTY from curated_cui where tier = 'CUI1'