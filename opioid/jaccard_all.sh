source db.config

$mysql_table_schema -e "call log('jaccard_all.sh', 'https://en.wikipedia.org/wiki/Jaccard_index')"
$mysql_table_schema -e "call log('jaccard_all.sh', 'begin')"

################################################################################
export CURATED="custom_rxcui_str"
source jaccard.sh

###############################################################################
export CURATED="all_rxcui_str"
source jaccard.sh

###############################################################################
export CURATED="vsac_math"
source jaccard.sh

###############################################################################
export CURATED="bioportal"
source jaccard.sh

###############################################################################
export CURATED="bioportal_to_umls"
source jaccard.sh

################################################################################
export CURATED="wasz_april7"
source jaccard.sh

################################################################################
$mysql_table_schema < jaccard_all.sql

$mysql_table_schema -e "call log('jaccard_all.sh', 'done')"




