#!/bin/bash
set -e
source db.config
source env_table_schema.sh

export DB_FILE="$TABLE_SCHEMA.mysqldump"

export DB_DUMP="mysqldump --skip-lock-tables -u $DB_USER -p$DB_PASS -h $DB_HOST --port $DB_PORT  $TABLE_SCHEMA"
mkdir -p mysqldump
$DB_DUMP > mysqldump/$DB_FILE

echo '##########################'
