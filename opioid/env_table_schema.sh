#!/bin/bash
set -e
source db.config

####################################################
# CURATED:
# export CURATED="custom_rxcui_str"
# export CURATED="all_rxcui_str"
# export CURATED="vsac_math"
# export CURATED="bioportal"
# export CURATED="bioportal_to_umls"
# export CURATED="wasz_april7"
####################################################

if [ "$#" -lt 1 ]; then
  TABLE_SCHEMA=$CURATED
  echo "no TABLE_SCHEMA name was provided, trying CURATED *** [${CURATED}] ***"
else
    TABLE_SCHEMA=$1
fi

if [ -z "$TABLE_SCHEMA" ]; then
  TABLE_SCHEMA=$DATASET
  echo "CURATED was not set, using default db.config *** [${DATASET}] ***"
fi

if [ -z "$TABLE_SCHEMA" ]; then
  echo "no TABLE_SCHEMA name was found, abort."
fi

mysql_table_schema="mysql  --auto-rehash -D $TABLE_SCHEMA -u $DB_USER -p$DB_PASS -h $DB_HOST --port $DB_PORT --local-infile --auto-rehash"

echo '##########################'
echo " DATASET  = $DATASET"
echo " CURATED  = $CURATED"
echo " TABLE_SCHEMA  = $TABLE_SCHEMA"
echo '##########################'

