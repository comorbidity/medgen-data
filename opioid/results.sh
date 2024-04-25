#!/bin/bash

source db.config

echo "start clean"
$mysql_dataset -e "call log('results.sh', 'begin')"

$mysql_dataset < drop_curated.sql

# export CURATED="custom_rxcui_str"
# export CURATED="all_rxcui_str"
# export CURATED="VSAC_Mathematica"
# export CURATED="bioportal"
# export CURATED="bioportal_to_umls"
# export CURATED="umls_reviewed_march26"
# export CURATED="curated_from_expanded_april7"

if [ -z "$CURATED" ]; then
  echo "CURATED is not set. Exiting..."
  exit 1
fi

echo "Using $CURATED.tsv"
$mysql_dataset -e "call version('${CURATED}', 'results.sh:begin')"

rm -f curated.tsv
ln -s $CURATED.tsv curated.tsv

$mysql_dataset < curated.sql
$mysql_dataset < expand.sql
$mysql_dataset < stats.sql

./backup_curated.sh

#./backup_database.sh curated
#./backup_database.sh RXNCONSO_curated
#
#./backup_database.sh expand
#
#./export_tsv.sh stats_expand
#./export_tsv.sh stats_keywords
#./export_tsv.sh stats_sab
#./export_tsv.sh stats_tty
#./export_tsv.sh stats_tui
#./export_tsv.sh stats_rel
#./export_tsv.sh stats_rela

$mysql_dataset -e "call version('${CURATED}', 'results.sh:done')"
$mysql_dataset -e "call log('results.sh', 'done')"
$mysql_dataset -e "call mem"
