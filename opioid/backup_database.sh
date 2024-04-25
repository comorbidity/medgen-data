#!/bin/bash
set -e
source db.config
source env_table_schema.sh

if [ "$#" -lt 1 ]; then
    export DB_FILE="$TABLE_SCHEMA.mysqldump"
else
    export DB_FILE="$TABLE_SCHEMA.$DB_TABLE.mysqldump"
fi

export DB_DUMP="mysqldump --skip-lock-tables -u $DB_USER -p$DB_PASS -h $DB_HOST --port $DB_PORT  $TABLE_SCHEMA $DB_TABLE"
mkdir -p mysqldump
$DB_DUMP > mysqldump/$DB_FILE

echo '##########################'
