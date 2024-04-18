#!/bin/bash

source db.config

#export CURATED="all_rxcui_str"
#./results.sh

export CURATED="VSAC_Mathematica"
./results.sh

export CURATED="bioportal"
./results.sh

export CURATED="bioportal_to_umls"
./results.sh

#export CURATED="umls_reviewed_march26"
#./results.sh

#export CURATED="umls_reviewed_april7"
#./results.sh

############################################################