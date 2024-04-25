#!/bin/bash
source db.config

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
    export TSV_FILEPATH="/Users/andy/code/medgen-umls/opioid/tsv/$TSV_FILENAME"
fi

export mysql_table_schema="mysql  --auto-rehash -D $CURATED -u $DB_USER -p$DB_PASS -h $DB_HOST --port $DB_PORT --local-infile --auto-rehash"

echo '##########################'
echo " CURATED  = $CURATED"
echo " DB_TABLE = $DB_TABLE"
echo " TSV_FILENAME  = $TSV_FILENAME "
echo " TSV_FILEPATH  = $TSV_FILEPATH "
echo  "$mysql_table_schema"
echo '##########################'

rm -f $TSV_FILEPATH
mkdir -p tsv
# mysql -u root -e "SHOW VARIABLES LIKE 'secure_file_priv'"
mysql -u root -e 'SET GLOBAL local_infile=1'

$mysql_table_schema -e "select * into outfile '$TSV_FILEPATH' FIELDS TERMINATED BY '\t' from $CURATED.$DB_TABLE"

echo '##########################'
