-- ##############################################
call log('keywords_str_in_str.sql', 'codone');

    select distinct RXCUI,STR from rxnorm.RXNCONSO
    where lower(STR) like concat('%','codone','%')
    and   lower(STR) not like concat('%','oxycodone','%')
    and   lower(STR) not like concat('%','hydrocodone','%')
    and   lower(STR) not like concat('%','endocodone','%')
    and   lower(STR) not like concat('%','roxicodone','%')
    order by STR, length(STR);

-- ##############################################
call log('keywords_str_in_str.sql', 'brovex');

    select distinct RXCUI,STR from rxnorm.RXNCONSO
    where lower(STR) like concat('%','brovex','%')
    and   lower(STR) not like concat('%','brovex cb','%')
    and   lower(STR) not like concat('%','brovex dc','%')
    and   lower(STR) not like concat('%','brovex hc','%')
    and   lower(STR) not like concat('%','brovex pb','%')
    and   lower(STR) not like concat('%','brovex-cb','%')
    and   lower(STR) not like concat('%','brovex-dc','%')
    and   lower(STR) not like concat('%','brovex-hc','%')
    and   lower(STR) not like concat('%','brovex-pb','%')
    order by STR, length(STR);

-- ##############################################
call log('keywords_str_in_str.sql', 'co-tuss');

    select distinct RXCUI,STR,CODE from rxnorm.RXNCONSO
    where lower(STR) like concat('%','co-tuss','%')
    and   lower(STR) not like concat('%','co-tussin','%')
    order by STR, length(STR);

-- ##############################################
call log('keywords_str_in_str.sql', 'methadon');

    select distinct RXCUI,STR,CODE from rxnorm.RXNCONSO
    where lower(STR) like concat('%','methadon','%')
    and   lower(STR) not like concat('%','methadone','%')
    order by STR, length(STR);

-- ##############################################
call log('keywords_str_in_str.sql', 'percocet');

    select distinct RXCUI,STR,CODE from rxnorm.RXNCONSO
    where lower(STR) like concat('%','cocet','%')
    and   lower(STR) not like concat('%','percocet','%')
    order by STR, length(STR);

-- ##############################################
call log('keywords_str_in_str.sql', 'medent');

    select distinct RXCUI,STR,CODE from rxnorm.RXNCONSO
    where lower(STR) like concat('%','medent','%')
    and   lower(STR) not like concat('%','medent c','%')
    order by STR, length(STR);

-- ##############################################
call log('keywords_str_in_str.sql', 'atuss g');

    select distinct RXCUI,STR,CODE from rxnorm.RXNCONSO
    where lower(STR) like concat('%','atuss g','%')
    order by STR, length(STR);
