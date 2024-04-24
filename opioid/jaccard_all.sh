source db.config

$mysql_dataset -e "call log('jaccard_all.sh', 'https://en.wikipedia.org/wiki/Jaccard_index')"
$mysql_dataset -e "call log('jaccard_all.sh', 'begin')"

################################################################################
export CURATED="opium_rxcui_str"
source jaccard.sh

###############################################################################
export CURATED="all_rxcui_str"
source jaccard.sh

###############################################################################
export CURATED="VSAC_Mathematica"
source jaccard.sh

###############################################################################
export CURATED="bioportal"
source jaccard.sh

###############################################################################
export CURATED="bioportal_to_umls"
source jaccard.sh

################################################################################
export CURATED="umls_reviewed_april7"
source jaccard.sh

################################################################################
$mysql_dataset < jaccard_all.sql

$mysql_dataset -e "call log('jaccard_all.sh', 'done')"




