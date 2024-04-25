#!/bin/bash

set -e

if [ -z "$CURATED" ]; then
  echo "CURATED is not set. Exiting..."
  exit 1
fi

source db.config
export DB_TABLE=$1

if [ "$#" -lt 1 ]; then
    export DB_FILE="$CURATED.mysqldump"
else
    export DB_FILE="$CURATED.$DB_TABLE.mysqldump"
fi 

export DB_DUMP="mysqldump --skip-lock-tables -u $DB_USER -p$DB_PASS -h $DB_HOST --port $DB_PORT  $DATASET $DB_TABLE" 

echo '##########################' 
echo " CURATED  = $CURATED"
echo " DB_TABLE = $DB_TABLE" 
echo " DB_FILE  = $DB_FILE " 
echo " DB_DUMP  = $DB_DUMP " 
echo '##########################'

$DB_DUMP > $DATASET/mysqldump/$DB_FILE

echo '##########################'
