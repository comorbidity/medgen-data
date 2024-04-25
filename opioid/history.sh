#!/bin/bash
set -e
source db.config
source env_table_schema.sh

echo '##########################'
$mysql_table_schema -e "call history"
echo '##########################'
$mysql_table_schema -e "call mem"
echo '##########################'
$mysql_table_schema -e "show databases"
echo '##########################'
