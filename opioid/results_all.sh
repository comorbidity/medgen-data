#!/bin/bash

source db.config

################################################################################
$mysql_table_schema < umls_abbreviations.sql
$mysql_table_schema < keywords.sql
$mysql_table_schema < version.sql

$mysql_table_schema -e "call log('results_all.sh', 'begin')"

export CURATED="custom_rxcui_str"
./results.sh

export CURATED="all_rxcui_str"
./results.sh

export CURATED="vsac_math"
./results.sh

export CURATED="bioportal"
./results.sh

export CURATED="bioportal_to_umls"
./results.sh

export CURATED="wasz_april7"
./results.sh

$mysql_table_schema -e "call log('results_all.sh', 'done')"

################################################################################