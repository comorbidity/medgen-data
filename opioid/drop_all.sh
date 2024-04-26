#!/bin/bash
set -e
source db.config
source env_table_schema.sh

export CURATED="vsac_math"
./drop_database.sh

export CURATED="bioportal"
./drop_database.sh

export CURATED="bioportal_to_umls"
./drop_database.sh

export CURATED="wasz_april7"
./drop_database.sh

export CURATED="custom_rxcui_str"
./drop_database.sh

export CURATED="all_rxcui_str"
./drop_database.sh

export CURATED="opioid"
./drop_database.sh
