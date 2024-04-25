#!/bin/bash
set -e
source db.config
source env_table_schema.sh

./create_database.sh
./results.sh
./backup_database.sh
./clone_database.sh
