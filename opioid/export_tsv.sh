#!/bin/bash

set -e

if [ -z "$CURATED" ]; then
  echo "CURATED is not set. Exiting..."
  exit 1
fi

source  db.config
export DB_TABLE=$1

if [ "$#" -lt 1 ]; then
    echo "no DB_TABLE was specified to export"
    exit 1
else
    export TSV_FILENAME="$CURATED.$DB_TABLE.tsv"
    export TSV_FILEPATH="/Users/andy/umls/opioid/tsv/$TSV_FILENAME"
fi

echo '##########################'
echo " CURATED  = $CURATED"
echo " DB_TABLE = $DB_TABLE"
echo " TSV_FILENAME  = $TSV_FILENAME "
echo " TSV_FILEPATH  = $TSV_FILEPATH "
echo '##########################'

rm -f $TSV_FILEPATH

$mysql_table_schema -e "call log('export_tsv.sh', 'begin')"

$mysql_table_schema -e 'SET GLOBAL local_infile=1'

$mysql_table_schema -e "select * into outfile '$TSV_FILEPATH' FIELDS TERMINATED BY '\t' from $DB_TABLE"

$mysql_table_schema -e "call log('export_tsv.sh', 'done')"

echo '##########################'
