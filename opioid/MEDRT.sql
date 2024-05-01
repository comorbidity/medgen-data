-- ##############################################
call log('MEDRT.sql', 'begin');

--    MRREL not in MED-RT
--    C0376196|Opiates
--    C0242402|Opioids

-- TODO: X guard against X
-- C0027410|Narcotic Antagonists

drop    table if exists opioid.MRCONSO_medrt;
create  table           opioid.MRCONSO_medrt
select  *
from    umls.MRCONSO
where   CUI in ('C0376196', 'C0242402') OR (
        SAB in ('MED-RT') AND
                (lower(STR) like '%opioid%' OR
                 lower(STR) like '%opiate%'))
order by STR,TTY;

-- ############################################################################
-- MRREL_medrt_cui1
-- ############################################################################

-- relate
drop    table if exists opioid.MRREL_medrt_cui1;
create  table           opioid.MRREL_medrt_cui1
select  distinct
        R.CUI1,
        R.AUI1,
        R.STYPE1,
        R.CUI2,
        R.AUI2,
        R.STYPE2,
        R.SAB,
        R.REL,
        R.RELA,
        C.TTY   as TTY,
        C.CODE  as CODE,
        C.STR   as STR
from    opioid.MRREL_copy R, opioid.MRCONSO_medrt C
where   R.CUI1 = C.CUI;

delete from MRREL_medrt_cui1 where REL in ('PAR', 'RB');

-- include
drop    table if exists opioid.include;
create  table           opioid.include
select  distinct
        'CUI1' as tier, CUI1  as CUI,
        SAB, CODE, TTY, STR
from    MRREL_medrt_cui1;

call create_index('opioid.include', 'CUI');
call create_index('opioid.include', 'SAB,CODE');

-- count
select SAB, count(*) cnt from MRREL_medrt_cui1 group by SAB order by CNT desc;

--    select  count(distinct CUI1) as cnt_cui1,
--            count(distinct CUI2) as cnt_cui2,
--            REL,RELA
--    from    opioid.MRREL_medrt_cui1
--    where   CUI1 != CUI2
--    group by REL,RELA
--    order by cnt_cui2 desc, cnt_cui1 desc;

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

-- relate
drop    table if exists opioid.MRREL_medrt_cui2;
create  table           opioid.MRREL_medrt_cui2
select  distinct
        R.CUI1, R.AUI1, R.STYPE1, R.REL, R.RELA, R.CUI2, R.AUI2, R.STYPE2, D.SAB, D.CODE, D.TTY, D.STR
from    opioid.MRREL_medrt_cui1 as R,
        opioid.MRCONSO_drug     as D
where   R.CUI2 = D.CUI
and     R.CUI2 not in (select distinct CUI from opioid.include);

-- include
drop    table if exists opioid.MRREL_medrt_cui2_include;
create  table           opioid.MRREL_medrt_cui2_include
select  *
from    MRREL_medrt_cui2
where   REL = 'CHD'
OR     (REL = 'RN' and RELA='ISA')
OR     (RELA in ('has_mechanism_of_action', 'mechanism_of_action_of'));

insert  into    opioid.include
select  distinct
        'CUI2' as tier, CUI2  as CUI,
        SAB, CODE, TTY, STR
from    MRREL_medrt_cui2_include;

-- count
select  count(distinct CUI1) as cnt_cui1,
        count(distinct CUI2) as cnt_cui2,
        REL, RELA, SAB, TTY
from    opioid.MRREL_medrt_cui2_include
group by REL, RELA, SAB, TTY
order by cnt_cui2 desc, cnt_cui1 desc;

--    +----------+----------+-----+-------------------------+
--    | cnt_cui1 | cnt_cui2 | REL | RELA                    |
--    +----------+----------+-----+-------------------------+
--    |        2 |      107 | CHD | isa                     |
--    |        8 |       93 | RO  | has_mechanism_of_action |
--    |        3 |       56 | CHD | NULL                    |
--    |        9 |       33 | CHD | has_parent              |
--    |        1 |        4 | RN  | isa                     |
--    +----------+----------+-----+-------------------------+


-- ############################################################################
-- MRREL_medrt_cui3
-- ############################################################################

-- relate
drop    table if exists opioid.MRREL_medrt_cui3;
create  table           opioid.MRREL_medrt_cui3
select  distinct
        R.CUI1   as CUI2,
        R.AUI1   as AUI2,
        R.STYPE1 as STYPE2,
        R.REL,
        R.RELA,
        R.CUI2   as CUI3,
        R.AUI2   as AUI3,
        R.STYPE2 as STYPE3,
        D.SAB, D.CODE, D.TTY, D.STR
from    opioid.MRREL_copy           as R,
        MRREL_medrt_cui2_include    as I,
        opioid.MRCONSO_drug         as D
where   R.CUI1!= R.CUI2
and     R.CUI1 = I.CUI2
and     R.CUI2 = D.CUI
and     R.CUI2 not in (select distinct CUI from opioid.include);

-- include
drop    table if exists opioid.MRREL_medrt_cui3_include;
create  table           opioid.MRREL_medrt_cui3_include
select  *
from    MRREL_medrt_cui3
where   REL = 'CHD'
OR     (REL = 'RN' and RELA='ISA')
OR     (RELA in ('tradename_of'));

insert  into    opioid.include
select  distinct
        'CUI3' as tier, CUI3  as CUI,
        SAB, CODE, TTY, STR
from    MRREL_medrt_cui3_include;

select * from include I1, include I2 where I1.CUI=I2.CUI and I1.tier != I2.tier;

-- count
select  count(distinct CUI2) as cnt_cui2,
        count(distinct CUI3) as cnt_cui3,
        REL, RELA, SAB
from    opioid.MRREL_medrt_cui3_include
group by REL, RELA, SAB
order by cnt_cui3 desc, cnt_cui2 desc;

-- ############################################################################
-- MRREL_medrt_cui4
-- ############################################################################

-- relate
drop    table if exists opioid.MRREL_medrt_cui4;
create  table           opioid.MRREL_medrt_cui4
select  distinct
        R.CUI1   as CUI3,
        R.AUI1   as AUI3,
        R.STYPE1 as STYPE3,
        R.REL,
        R.RELA,
        R.CUI2   as CUI4,
        R.AUI2   as AUI4,
        R.STYPE2 as STYPE4,
        D.SAB, D.CODE, D.TTY, D.STR
from    opioid.MRREL_copy           as R,
        MRREL_medrt_cui3_include    as I,
        opioid.MRCONSO_drug         as D
where   R.CUI1 = I.CUI2
and     R.CUI2 = D.CUI
and     R.CUI2 not in (select distinct CUI from include);

-- include
drop    table if exists opioid.MRREL_medrt_cui4_include;
create  table           opioid.MRREL_medrt_cui4_include
select  *
from    MRREL_medrt_cui4
where   REL = 'CHD'
OR     (REL = 'RN' and RELA='ISA')
OR     (RELA in ('tradename_of',
                'basis_of_strength_substance_of',
                'has_basis_of_strength_substance'));

insert  into    opioid.include
select  distinct
        'CUI4' as tier, CUI4  as CUI,
        SAB, CODE, TTY, STR
from    MRREL_medrt_cui4_include;

-- count
select  count(distinct CUI3) as cnt_cui3,
        count(distinct CUI4) as cnt_cui4,
        REL
from    opioid.MRREL_medrt_cui4
group by REL
order by cnt_cui4 desc, cnt_cui3 desc;

--    +----------+----------+-----+
--    | cnt_cui3 | cnt_cui4 | REL |
--    +----------+----------+-----+
--    |       84 |     3200 | RO  |
--    |       45 |      764 | RN  |
--    |       83 |       98 | PAR |
--    |       44 |       27 | RB  |
--    |        9 |       12 | RQ  |
--    |        1 |        1 | SY  |
--    +----------+----------+-----+

select  count(distinct CUI3) as cnt_cui3,
        count(distinct CUI4) as cnt_cui4,
        REL, RELA, SAB, TTY
from    opioid.MRREL_medrt_cui4_include
group by REL, RELA, SAB, TTY
order by cnt_cui4 desc, cnt_cui3 desc;

-- ############################################################################
--
-- ############################################################################


--drop    table if exists opioid.MRREL_medrt_cui1_stats;
--create  table           opioid.MRREL_medrt_cui1_stats
--select  count(distinct CUI1) as cnt_cui1,
--        count(distinct CUI2) as cnt_cui2,
--        REL, RELA, SAB
--from    opioid.MRREL_medrt_cui1
--where   CUI1 != CUI2
--and     CUI2 not in (select distinct CUI1 from opioid.MRREL_medrt_cui1)
--group by REL, RELA, SAB
--order by cnt_cui1 desc, cnt_cui2 desc;
--
--select * from MRREL_medrt_cui1_stats where SAB='MED-RT';
--    +----------+----------+-----+----------------------------------------+--------+
--    | cnt_cui1 | cnt_cui2 | REL | RELA                                   | SAB    |
--    +----------+----------+-----+----------------------------------------+--------+
--    |        9 |       33 | CHD | has_parent                             | MED-RT | include
--    |        8 |       93 | RO  | has_mechanism_of_action                | MED-RT | include
--    |        6 |        5 | PAR | NULL                                   | MED-RT | X
--    |        3 |        3 | SY  | NULL                                   | MED-RT | risky
--    |        2 |        2 | PAR | parent_of                              | MED-RT | X
--    |        1 |        4 | RO  | contraindicated_class_of               | MED-RT | X
--    |        1 |        2 | RO  | contraindicated_mechanism_of_action_of | MED-RT | X
--    +----------+----------+-----+----------------------------------------+--------+

--drop    table if exists opioid.MRREL_medrt_cui2_stats;
--create  table           opioid.MRREL_medrt_cui2_stats
--select  count(distinct CUI1) as cnt_cui1,
--        count(distinct CUI2) as cnt_cui2,
--        REL, RELA, SAB, TTY
--from    opioid.MRREL_medrt_cui2
--group by REL, RELA, SAB, TTY
--order by cnt_cui1 desc, cnt_cui2 desc;

--    select  count(distinct CUI1) as cnt_cui1,
--            count(distinct CUI2) as cnt_cui2,
--            REL
--    from    opioid.MRREL_medrt_cui2
--    group by REL
--    order by cnt_cui1 desc, cnt_cui2 desc;
--
--    drop    table if exists opioid.MRREL_medrt_cui2_include;
--    create  table           opioid.MRREL_medrt_cui2_include
--    select  *
--    from    MRREL_medrt_cui2
--    where   REL = 'CHD'
--    OR     (REL = 'RN' and RELA='ISA')
--    OR     (RELA in ('has_mechanism_of_action', 'mechanism_of_action_of'));



--    +----------+----------+-----+----------------------------------------+
--    | cnt_cui1 | cnt_cui2 | REL | RELA                                   |
--    +----------+----------+-----+----------------------------------------+
--    |        9 |       33 | CHD | has_parent                             | +include
--    |        8 |       93 | RO  | has_mechanism_of_action                | +include
--    |        4 |       11 | RO  | NULL                                   |
--    |        3 |       56 | CHD | NULL                                   | +include
--    |        3 |        3 | SY  | NULL                                   |
--    |        2 |      107 | CHD | isa                                    | +include
--    |        2 |        9 | RN  | NULL                                   |
--    |        2 |        2 | RQ  | NULL                                   |
--    |        1 |       44 | RO  | has_causative_agent                    | X (Opioid abuse (disorder))
--    |        1 |       11 | RO  | has_component                          | X (Opioid screening)
--    |        1 |        4 | RN  | isa                                    | +include
--    |        1 |        4 | RO  | contraindicated_class_of               | X
--    |        1 |        2 | RO  | contraindicated_mechanism_of_action_of | X
--    |        1 |        2 | RO  | has_direct_substance                   | X (Opioid therapy for breathlessness management)
--    |        1 |        1 | RO  | associated_with                        | X (Opiate misuse (finding))
--    |        1 |        1 | RO  | disposition_of                         | X (not a drug)
--    |        1 |        1 | RO  | measures                               | X (Urine opiate measurement (procedure))
--    |        1 |        1 | RQ  | use                                    | X
--    +----------+----------+-----+----------------------------------------+

--    --select * from MRREL_medrt_cui2_stats;
--
--    drop    table if exists opioid.MRREL_medrt_cui2_moa;
--    create  table           opioid.MRREL_medrt_cui2_moa
--    select  *
--    from    MRREL_medrt_cui2
--    where   RELA in ('has_mechanism_of_action', 'mechanism_of_action_of');
--
--    drop    table if exists opioid.MRREL_medrt_cui2_child;
--    create  table           opioid.MRREL_medrt_cui2_child
--    select  *
--    from    MRREL_medrt_cui2
--    where   REL in ('CHD', 'RN') or RELA in ('has_parent', 'isa');
--
--    select distinct RELA,SAB,TTY from MRREL_medrt_cui2_child order by RELA,SAB,TTY;
--
--    drop    table if exists opioid.MRREL_medrt_cui2_include;
--    create  table           opioid.MRREL_medrt_cui2_include
--    select  * from MRREL_medrt_cui2_moa
--    UNION
--    select  * from MRREL_medrt_cui2_child;
--
--    call create_index ('MRREL_medrt_cui2_include', 'CUI1');
--    call create_index ('MRREL_medrt_cui2_include', 'CUI2');
--    call create_index ('MRREL_medrt_cui2_include', 'REL');
--    call create_index ('MRREL_medrt_cui2_include', 'RELA');
--
--    drop    table if exists opioid.MRREL_medrt_cui3;
--    create  table           opioid.MRREL_medrt_cui3
--    select  distinct
--            R.CUI1   as CUI2,
--            R.AUI1   as AUI2,
--            R.STYPE1 as STYPE2,
--            R.REL,
--            R.RELA,
--            R.CUI2   as CUI3,
--            R.AUI2   as AUI3,
--            R.STYPE2 as STYPE3,
--            D.SAB, D.TTY, D.STR
--    from    opioid.MRREL_copy           as R,
--            MRREL_medrt_cui2_include    as I,
--            opioid.MRCONSO_drug         as D
--    where   R.CUI1 = I.CUI2
--    and     R.CUI2 = D.CUI
--    and     R.CUI1 not in (select distinct CUI1 from MRREL_medrt_cui2_include);
--
--    delete from MRREL_medrt_cui3 where REL in ('PAR', 'RB');
--
--    select  count(distinct CUI2) as cnt_cui2,
--            count(distinct CUI3) as cnt_cui3,
--            REL, RELA
--    from    opioid.MRREL_medrt_cui3
--    group by REL, RELA
--    order by cnt_cui3 desc, cnt_cui2 desc;

--    +----------+----------+-----+--------------------------------------------+
--    | cnt_cui2 | cnt_cui3 | REL | RELA                                       |
--    +----------+----------+-----+--------------------------------------------+
--    |       81 |     1728 | RO  | has_ingredient                             |
--    |       95 |     1293 | RO  | has_active_ingredient                      |
--    |       79 |      899 | RN  | NULL                                       | ?
--    |       36 |      539 | RO  | has_active_moiety                          |
--    |       30 |      381 | RO  | has_boss                                   |
--    |       48 |      360 | RO  | has_precise_active_ingredient              | +include TTY=IN
--    |       46 |      360 | RO  | has_basis_of_strength_substance            | +include has_basis_of_strength_substance
--    |       63 |      306 | RO  | NULL                                       |
--    |       25 |      249 | RO  | has_precise_ingredient                     |
--    |       63 |      246 | CHD | isa                                        | +include child
--    |       28 |      204 | RO  | has_part                                   | +include child
--    |       32 |      200 | RO  | has_causative_agent                        |
--    |       43 |      145 | RN  | tradename_of                               | +include
--    |       38 |      136 | RN  | has_precise_ingredient                     |
--    |       34 |      128 | CHD | NULL                                       |
--    |      117 |      119 | SY  | NULL                                       |
--    |       19 |      111 | RO  | contains                                   |
--    |       92 |       87 | RO  | active_ingredient_of                       | +include
--    |       50 |       70 | RO  | is_modification_of                         |
--    |       40 |       70 | RO  | has_component                              |
--    |       47 |       69 | RN  | form_of                                    | +include
--    |       40 |       69 | RN  | isa                                        | +include
--    |       21 |       62 | RN  | mapped_to                                  |
--    |       42 |       54 | RO  | associated_with                            |
--    |       41 |       49 | RO  | has_free_acid_or_base_form                 |
--    |       32 |       48 | SY  | tradename_of                               |
--    |       55 |       42 | RO  | has_modification                           |
--    |       39 |       39 | SY  | transliterated_form_of                     |
--    |       39 |       39 | SY  | translation_of                             |
--    |       39 |       39 | SY  | has_transliterated_form                    |
--    |       39 |       39 | SY  | has_translation                            |
--    |       44 |       37 | RO  | has_salt_form                              |
--    |       91 |       35 | RO  | has_contraindicated_drug                   |
--    |       87 |       26 | RO  | may_be_treated_by                          |
--    |       93 |       25 | RO  | physiologic_effect_of                      |
--    |       17 |       25 | RQ  | NULL                                       |
--    |       19 |       19 | SY  | permuted_term_of                           |
--    |       19 |       19 | SY  | has_permuted_term                          |
--    |       16 |       16 | RQ  | mapped_to                                  |
--    |       15 |       16 | RQ  | mapped_from                                |
--    |       96 |       15 | RO  | mechanism_of_action_of                     |
--    |        3 |       12 | RO  | contraindicated_class_of                   |
--    |       94 |       11 | RO  | therapeutic_class_of                       |




--CUI|STR
--C0242402|Opioids
--C0376196|Opiates
--C1883695|Opioid Agonist [EPC]
--C1373059|Opioid Agonists [Function]
--C2917221|Full Opioid Agonists [MoA]
--C3536879|Opioid Antagonist [EPC]
--C3537237|Opioid Analgesic [EPC]
--C1373041|Opioid Receptor Interactions [MoA]
--C4060037|mu-Opioid Receptor Agonist [EPC]
--C4060041|Opioid mu-Receptor Agonists [Function]
--
--Opioid Agonist/Antagonist [EPC]	N0000175692	MED-RT
--Opioid Agonist [EPC]	N0000175690	MED-RT
--Opioid Analgesic [EPC]	N0000175440	MED-RT
--Opioid Receptor Interactions [MoA]	N0000000200	MED-RT
--Kappa Opioid Receptor Agonist [EPC]	N0000194001	MED-RT
--Opioid Antagonist [EPC]	N0000175691	MED-RT
--Full Opioid Agonists [MoA]	N0000175684	MED-RT
--Opioid Agonists [MoA]	N0000000174	MED-RT
--Opioid Antagonists [MoA]	N0000000154	MED-RT
--Partial Opioid Agonists [MoA]	N0000175685	MED-RT
--Competitive Opioid Antagonists [MoA]	N0000175686	MED-RT
--Opioid mu-Receptor Agonists [MoA]	N0000191866	MED-RT
--Opioid kappa Receptor Agonists [MoA]	N0000194007	MED-RT
--mu-Opioid Receptor Agonist [EPC]	N0000191867	MED-RT
--Partial Opioid Agonist/Antagonist [EPC]	N0000175688	MED-RT
--Partial Opioid Agonist [EPC]	N0000175689	MED-RT



