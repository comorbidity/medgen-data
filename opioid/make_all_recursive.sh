#!/bin/bash
set -e
source db.config
source env_table_schema.sh

#echo ################################################################################
#echo 'MEDRT building (1x only)'
#export CURATED=medrt
#./create_database.sh medrt
#$mysql_table_schema < medrt.sql

echo ################################################################################
./create_database.sh opioid

export CURATED="custom_rxcui_str"
./make.sh

export CURATED="vsac_math"
./make.sh

export CURATED="bioportal"
./make.sh

export CURATED="bioportal_to_umls"
./make.sh

export CURATED="wasz_april7"
./make.sh

export CURATED="all_rxcui_str"
./make.sh

