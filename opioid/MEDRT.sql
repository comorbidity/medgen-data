-- ##############################################
call log('MEDRT.sql', 'begin');

drop table if exists    MRCONSO_medrt;

drop table if exists    MRREL_medrt_cui1,
                        MRREL_medrt_cui2,
                        MRREL_medrt_cui3,
                        MRREL_medrt_cui4,
                        MRREL_medrt_cui5,
                        MRREL_medrt_cui6;

drop table if exists    curated_cui,
                        curated_cui_stat,
                        curated_cui_stat_sab,
                        curated_cui_stat_sab_tty,
                        curated_cui_stat_rel,
                        curated_cui_stat_rela,
                        curated_cui_stat_rel_rela;

--    drop    table if exists RXNCONSO_medrt
--    create  table           RXNCONSO_medrt
--    select * from rxnorm.RXNCONSO;
--
--    call create_index('RXNCONSO_medrt', 'RXCUI');
--    call create_index('RXNCONSO_medrt', 'SAB,CODE');
--
--    drop    table if exists MRREL_medrt;
--    create  table           MRREL_medrt
--    select  *
--    from    umls.MRREL
--    where   REL = 'CHD'
--    OR      RELA in ('isa',
--            'tradename_of','has_tradename',
--            'has_basis_of_strength_substance');
--
--    delete from MRREL_medrt where REL in ('RB', 'PAR');

--    not in MED-RT
--    C0376196|Opiates
--    C0242402|Opioids

-- TODO: X guard against X
-- C0027410|Narcotic Antagonists
-- C2917434|Narcotic Antitussive
-- C2916808|NMDA Receptor Antagonists

drop    table if exists MRCONSO_medrt;
create  table           MRCONSO_medrt
select  *
from    umls.MRCONSO
where   TRUE and
        SAB in ('MED-RT') AND
                (lower(STR) like '%opioid%' OR
                 lower(STR) like '%opiate%')
order by STR,TTY;

call create_index('MRCONSO_medrt', 'CUI');

-- ############################################################################
-- MRREL_medrt_cui1
-- ############################################################################

drop    table if exists MRREL_medrt_cui1;
create  table           MRREL_medrt_cui1
select  distinct
        R.CUI1,
        R.REL,
        R.RELA,
        R.CUI2,
        R.SAB,
        C.TTY,
        C.CODE,
        C.STR
from    MRREL_medrt R, MRCONSO_medrt C
where   R.CUI1 = C.CUI;

call create_index('MRREL_medrt_cui1', 'CUI1');
call create_index('MRREL_medrt_cui1', 'CUI2');

drop    table if exists curated_cui;
create  table           curated_cui
select  distinct 'CUI1' as tier, CUI1  as CUI, R.*
from    MRREL_medrt_cui1 R;

call create_index('curated_cui', 'CUI');
call create_index('curated_cui', 'SAB,CODE');

-- count
select SAB, count(*) cnt from MRREL_medrt_cui1 group by SAB order by CNT desc;

select  count(distinct CUI1) as cnt_cui1,
        count(distinct CUI2) as cnt_cui2,
        REL, RELA, TTY
from    MRREL_medrt_cui1
where   CUI1 != CUI2
group by REL,RELA, TTY
order by cnt_cui2 desc, cnt_cui1 desc;

--    +----------+----------+-----+----------------------------------------+
--    | cnt_cui1 | cnt_cui2 | REL | RELA                                   |
--    +----------+----------+-----+----------------------------------------+
--    |        2 |      133 | CHD | isa                                    | +include
--    |        8 |      101 | CHD | NULL                                   | +include
--    |        8 |      100 | RO  | has_mechanism_of_action                | +include
--    |        2 |      100 | RO  | has_component                          | X
--    |       15 |       66 | RO  | NULL                                   | X
--    |        1 |       57 | RO  | has_causative_agent                    | X
--    |        1 |       49 | RO  | measures                               | X
--    |        9 |       36 | CHD | has_parent                             | +include
--    |        2 |       24 | RN  | NULL                                   | ?
--    |        7 |        7 | SY  | NULL                                   | XXX NO !
--    |        1 |        7 | RN  | isa                                    | +include
--    |        1 |        7 | RO  | has_direct_substance                   | X
--    |        7 |        6 | RO  | mechanism_of_action_of                 | +include
--    |        2 |        5 | RO  | has_answer                             | X
--    |        1 |        5 | RO  | has_active_ingredient                  | X
--    |        1 |        4 | RO  | associated_with                        | X
--    |        1 |        4 | RO  | contraindicated_class_of               | X
--    |        2 |        3 | RQ  | NULL                                   |
--    |        1 |        2 | RO  | contraindicated_mechanism_of_action_of |
--    |        1 |        2 | RQ  | use                                    |
--    |        1 |        2 | RQ  | used_for                               |
--    |        1 |        1 | RO  | active_ingredient_of                   | X
--    |        1 |        1 | RO  | disposition_of                         | X
--    +----------+----------+-----+----------------------------------------+


-- ############################################################################
-- MRREL_medrt_cui2
-- ############################################################################

drop    table if exists MRREL_medrt_cui2;
create  table           MRREL_medrt_cui2
select  distinct
        R.CUI1, R.REL, R.RELA, R.CUI2, D.SAB, D.TTY, D.CODE, D.STR
from    MRREL_medrt_cui1 as R,
        MRCONSO_drug     as D
where   R.CUI2 = D.CUI
and     R.CUI2 not in (select distinct CUI from curated_cui);

call create_index('MRREL_medrt_cui2', 'CUI1');
call create_index('MRREL_medrt_cui2', 'CUI2');

insert  into    curated_cui
select  distinct 'CUI2' as tier, CUI2  as CUI, R.*
from    MRREL_medrt_cui2 R;

-- ############################################################################
-- MRREL_medrt_cui3
-- ############################################################################

drop    table if exists MRREL_medrt_cui3;
create  table           MRREL_medrt_cui3
select  distinct
        R.CUI1   as CUI2,
        R.REL,
        R.RELA,
        R.CUI2   as CUI3,
        D.SAB, D.TTY, D.CODE, D.STR
from    MRREL_medrt         as R,
        MRREL_medrt_cui2    as I,
        MRCONSO_drug        as D
where   R.CUI1 = I.CUI2
and     R.CUI2 = D.CUI
and     R.CUI2 not in (select distinct CUI from curated_cui);

call create_index('MRREL_medrt_cui3', 'CUI2');
call create_index('MRREL_medrt_cui3', 'CUI3');

insert  into    curated_cui
select  distinct 'CUI3' as tier, CUI3  as CUI, R.*
from    MRREL_medrt_cui3 R;

-- ############################################################################
-- MRREL_medrt_cui4
-- ############################################################################

-- relate
drop    table if exists MRREL_medrt_cui4;
create  table           MRREL_medrt_cui4
select  distinct
        R.CUI1   as CUI3,
        R.REL,
        R.RELA,
        R.CUI2   as CUI4,
        D.SAB, D.TTY, D.CODE, D.STR
from    MRREL_medrt         as R,
        MRREL_medrt_cui3    as I,
        MRCONSO_drug        as D
where   R.CUI1 = I.CUI3
and     R.CUI2 = D.CUI
and     R.CUI2 not in (select distinct CUI from curated_cui);

call create_index('MRREL_medrt_cui4', 'CUI3');
call create_index('MRREL_medrt_cui4', 'CUI4');

insert  into    curated_cui
select  distinct 'CUI4' as tier, CUI4  as CUI, R.*
from    MRREL_medrt_cui4 R;

-- ############################################################################
-- MRREL_medrt_cui5
-- ############################################################################

drop    table if exists MRREL_medrt_cui5;
create  table           MRREL_medrt_cui5
select  distinct
        R.CUI1   as CUI4,
        R.REL,
        R.RELA,
        R.CUI2   as CUI5,
        D.SAB, D.TTY, D.CODE, D.STR
from    MRREL_medrt          as R,
        MRREL_medrt_cui4     as I,
        MRCONSO_drug         as D
where   R.CUI1 = I.CUI4
and     R.CUI2 = D.CUI
and     R.CUI2 not in (select distinct CUI from curated_cui);

insert  into    curated_cui
select  distinct 'CUI5' as tier, CUI5  as CUI, R.*
from    MRREL_medrt_cui5 R;

select tier, count(*), count(distinct CUI) from curated_cui group by tier order by tier;

call create_index('MRREL_medrt_cui5', 'CUI4');
call create_index('MRREL_medrt_cui5', 'CUI5');

-- ############################################################################
-- MRREL_medrt_cui6
-- ############################################################################

drop    table if exists MRREL_medrt_cui6;
create  table           MRREL_medrt_cui6
select  distinct
        R.CUI1   as CUI5,
        R.REL,
        R.RELA,
        R.CUI2   as CUI6,
        D.SAB, D.TTY, D.CODE, D.STR
from    MRREL_medrt          as R,
        MRREL_medrt_cui5     as I,
        MRCONSO_drug         as D
where   R.CUI1 = I.CUI5
and     R.CUI2 = D.CUI
and     R.CUI2 not in (select distinct CUI from curated_cui);

insert  into    curated_cui
select  distinct 'CUI6' as tier, CUI6  as CUI, R.*
from    MRREL_medrt_cui6 R;

call create_index('MRREL_medrt_cui6', 'CUI5');
call create_index('MRREL_medrt_cui6', 'CUI6');

-- ############################################################################
-- MRREL_medrt_cui7
-- ############################################################################

drop    table if exists MRREL_medrt_cui7;
create  table           MRREL_medrt_cui7
select  distinct
        R.CUI1   as CUI6,
        R.REL,
        R.RELA,
        R.CUI2   as CUI7,
        D.SAB, D.TTY, D.CODE, D.STR
from    MRREL_medrt          as R,
        MRREL_medrt_cui6     as I,
        MRCONSO_drug         as D
where   R.CUI1 = I.CUI6
and     R.CUI2 = D.CUI
and     R.CUI2 not in (select distinct CUI from curated_cui);

insert  into    curated_cui
select  distinct 'CUI7' as tier, CUI7  as CUI, R.*
from    MRREL_medrt_cui7 R;

call create_index('MRREL_medrt_cui7', 'CUI6');
call create_index('MRREL_medrt_cui7', 'CUI7');

-- ############################################################################
-- MRREL_medrt_cui8
-- ############################################################################

drop    table if exists MRREL_medrt_cui8;
create  table           MRREL_medrt_cui8
select  distinct
        R.CUI1   as CUI7,
        R.REL,
        R.RELA,
        R.CUI2   as CUI8,
        D.SAB, D.TTY, D.CODE, D.STR
from    MRREL_medrt          as R,
        MRREL_medrt_cui7     as I,
        MRCONSO_drug         as D
where   R.CUI1 = I.CUI7
and     R.CUI2 = D.CUI
and     R.CUI2 not in (select distinct CUI from curated_cui);

insert  into    curated_cui
select  distinct 'CUI8' as tier, CUI8  as CUI, R.*
from    MRREL_medrt_cui8 R;

call create_index('MRREL_medrt_cui8', 'CUI7');
call create_index('MRREL_medrt_cui8', 'CUI8');

-- ############################################################################
-- MRREL_medrt_cui9
-- ############################################################################

drop    table if exists MRREL_medrt_cui9;
create  table           MRREL_medrt_cui9
select  distinct
        R.CUI1   as CUI8,
        R.REL,
        R.RELA,
        R.CUI2   as CUI9,
        D.SAB, D.TTY, D.CODE, D.STR
from    MRREL_medrt          as R,
        MRREL_medrt_cui8     as I,
        MRCONSO_drug         as D
where   R.CUI1 = I.CUI8
and     R.CUI2 = D.CUI
and     R.CUI2 not in (select distinct CUI from curated_cui);

insert  into    curated_cui
select  distinct 'CUI9' as tier, CUI9  as CUI, R.*
from    MRREL_medrt_cui9 R;

call create_index('MRREL_medrt_cui9', 'CUI8');
call create_index('MRREL_medrt_cui9', 'CUI9');

-- ############################################################################
-- MRREL_medrt_cui10
-- ############################################################################

drop    table if exists MRREL_medrt_cui10;
create  table           MRREL_medrt_cui10
select  distinct
        R.CUI1   as CUI9,
        R.REL,
        R.RELA,
        R.CUI2   as CUI10,
        D.SAB, D.TTY, D.CODE, D.STR
from    MRREL_medrt          as R,
        MRREL_medrt_cui9     as I,
        MRCONSO_drug         as D
where   R.CUI1 = I.CUI9
and     R.CUI2 = D.CUI
and     R.CUI2 not in (select distinct CUI from curated_cui);

insert  into    curated_cui
select  distinct 'CUI10' as tier, CUI10  as CUI, R.*
from    MRREL_medrt_cui10 R;

call create_index('MRREL_medrt_cui10', 'CUI9');
call create_index('MRREL_medrt_cui10', 'CUI10');

-- ############################################################################
-- RXCUI mapping
-- ############################################################################

drop    table if exists curated_cui_rxcui;
create  table           curated_cui_rxcui
select  distinct        C.*, R.RXCUI
from
    curated_cui     as C,
    RXNCONSO_medrt  as R
where
    C.SAB  = R.SAB  and
    C.CODE = R.CODE;

drop    table if exists curated;
create  table           curated
select  distinct        RXCUI, STR
from    curated_cui_rxcui
order by RXCUI, STR;


-- ############################################################################
-- STATS
-- ############################################################################

drop    table   if exists   curated_cui_stat;
create  table               curated_cui_stat
select      count(*) as cnt, count(distinct CUI) as cnt_cui,
            tier
from        curated_cui
group by    tier
order by    tier, cnt desc, cnt_cui desc;

drop    table   if exists   curated_cui_stat_rel;
create  table               curated_cui_stat_rel
select      count(*) as cnt, count(distinct CUI) as cnt_cui,
            tier, REL
from        curated_cui
group by    tier, REL
order by    tier, cnt desc, cnt_cui desc;

drop    table   if exists   curated_cui_stat_rela;
create  table               curated_cui_stat_rela
select      count(*) as cnt, count(distinct CUI) cnt_cui,
            tier, RELA
from        curated_cui
group by    tier, RELA
order by    tier, cnt desc, cnt_cui desc;

drop    table   if exists   curated_cui_stat_rel_rela;
create  table               curated_cui_stat_rel_rela
select      count(*) as cnt, count(distinct CUI) cnt_cui,
            tier, REL, RELA
from        curated_cui
group by    tier, REL, RELA
order by    tier, cnt desc, cnt_cui desc;

drop    table   if exists   curated_cui_stat_tty;
create  table               curated_cui_stat_tty
select      count(*) as cnt, count(distinct CUI) cnt_cui,
            tier, TTY
from        curated_cui
group by    tier, TTY
order by    tier, cnt desc, cnt_cui desc;

drop    table   if exists   curated_cui_stat_sab;
create  table               curated_cui_stat_sab
select      count(*) as cnt, count(distinct CUI) cnt_cui,
            tier, SAB
from        curated_cui
group by    tier, SAB
order by    tier, cnt desc, cnt_cui desc;


-- ##############################################
call log('MEDRT.sql', 'done');
