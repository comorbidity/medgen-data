#!/bin/bash
set -e
source db.config
source env_table_schema.sh

#if [ "$#" -lt 1 ]; then
#  TABLE_SCHEMA=$CURATED
#  echo "no TABLE_SCHEMA name was provided, trying CURATED *** [${CURATED}] ***"
#else
#    TABLE_SCHEMA=$1
#fi
#
#if [ -z "$TABLE_SCHEMA" ]; then
#  TABLE_SCHEMA=$DATASET
#  echo "CURATED was not set, using default db.config *** [${DATASET}] ***"
#fi
#
#if [ -z "$TABLE_SCHEMA" ]; then
#  echo "no TABLE_SCHEMA name was found, abort."
#fi

DUMP_FILE="mysqldump/$TABLE_SCHEMA.mysqldump"

echo '#############################################'
echo " DATASET  = $DATASET"
echo " CURATED  = $CURATED"
echo " TABLE_SCHEMA  = $TABLE_SCHEMA"
echo " DUMP_FILE  = $DUMP_FILE"
echo '#############################################'

mysql_table_schema="mysql  --auto-rehash -D $TABLE_SCHEMA -u $DB_USER -p$DB_PASS -h $DB_HOST --port $DB_PORT --local-infile --auto-rehash"

$mysql_table_schema < $DUMP_FILE

$mysql_table_schema -e "call mem"

$mysql_table_schema -e "show databases"
echo '##########################'
