#!/bin/bash
set -e
source db.config
source env_table_schema.sh

DUMP_FILE="mysqldump/$TABLE_SCHEMA.mysqldump"

echo '#############################################'
echo " DUMP_FILE  = $DUMP_FILE"
echo '#############################################'

mysql_table_schema="mysql  --auto-rehash -D $TABLE_SCHEMA -u $DB_USER -p$DB_PASS -h $DB_HOST --port $DB_PORT --local-infile --auto-rehash"

$mysql_table_schema < $DUMP_FILE

$mysql_table_schema -e "call mem"

$mysql_table_schema -e "show databases"
echo '##########################'
