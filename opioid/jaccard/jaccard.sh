#!/bin/bash
set -e
source db.config
export CURATED='opioid'

$mysql_dataset -e "show databases"
####################################################
$mysql_dataset < jaccard_self.sql
####################################################
$mysql_dataset < jaccard_vsac_math.sql
#
./export_tsv.sh bioportal_DIFF_vsac_math
./export_tsv.sh vsac_math_SUB_bioportal
####################################################
$mysql_dataset < jaccard_bioportal.sql
#$mysql_dataset < jaccard_bioportal_to_umls.sql

./export_tsv.sh all_keywords_DIFF_bioportal
####################################################
$mysql_dataset < jaccard_wasz_april7.sql

./export_tsv.sh all_keywords_DIFF_wasz_april7

####################################################
# ./export_tsv.sh RXNCONSO_curated_rela__all_keywords_DIFF_bioportal
# ./export_tsv.sh RXNCONSO_curated_rela__all_keywords_DIFF_wasz_april7
# ./export_tsv.sh RXNCONSO_curated_rela__vsac_math_DIFF_bioportal


opioid.RXNCONSO_curated_rela__vsac_math_DIFF_bioportal