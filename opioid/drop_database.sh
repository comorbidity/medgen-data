#!/bin/bash
set -e
source db.config
source env_table_schema.sh

mysql -u root -e "drop database if exists ${TABLE_SCHEMA}"
mysql -u root -e "show databases"



