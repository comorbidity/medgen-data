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
./make_recursive.sh

export CURATED="vsac_math"
./make_recursive.sh

export CURATED="medrt"
./make_recursive.sh

export CURATED="bioportal"
./make_recursive.sh

#  export CURATED="bioportal_to_umls"
#  ./make_recursive.sh

export CURATED="wasz_april7"
./make_recursive.sh

#  export CURATED="all_rxcui_str"
#  ./make_recursive.sh