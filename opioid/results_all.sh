#!/bin/bash

source db.config

$mysql_dataset -e "call log('results_all.sh', 'begin')"

export CURATED="custom_rxcui_str"
./results.sh

export CURATED="all_rxcui_str"
./results.sh

export CURATED="VSAC_Mathematica"
./results.sh

export CURATED="bioportal"
./results.sh

export CURATED="bioportal_to_umls"
./results.sh

export CURATED="wasz_april7"
./results.sh

$mysql_dataset -e "call log('results_all.sh', 'done')"

############################################################