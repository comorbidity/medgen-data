#!/bin/bash
set -e
source db.config
source env_table_schema.sh

./create_database.sh opioid

export CURATED="vsac_math"
./make.sh

export CURATED="bioportal"
./make.sh

export CURATED="bioportal_to_umls"
./make.sh

export CURATED="wasz_april7"
./make.sh

export CURATED="custom_rxcui_str"
./make.sh

export CURATED="all_rxcui_str"
./make.sh

