./create_database.sh opioid

export CURATED="custom_rxcui_str"
./make.sh

export CURATED="custom_rxcui_str"
./make.sh

export CURATED="all_rxcui_str"
./make.sh

export CURATED="VSAC_Mathematica"
./make.sh

export CURATED="bioportal"
./make.sh

export CURATED="bioportal_to_umls"
./make.sh

export CURATED="wasz_april7"
./make.sh
