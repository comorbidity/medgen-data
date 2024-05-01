#!/bin/bash
set -e
source db.config
source env_table_schema.sh

mysql -u root -e "drop database if exists ${TABLE_SCHEMA}"
mysql -u root -e "create database ${TABLE_SCHEMA} character set utf8 COLLATE utf8_unicode_ci"
mysql -u root -e "show databases"

$mysql_table_schema < create_procedures.sql
$mysql_table_schema < version.sql
$mysql_table_schema < UMLS_abbreviations.sql
$mysql_table_schema < keywords.sql
$mysql_table_schema < expand_rules.sql
echo '#############################################'
$mysql_table_schema -e "call mem"
echo '#############################################'




