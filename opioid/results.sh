#!/bin/bash

source db.config

echo "start clean"
$mysql_dataset -e "call log('refresh', 'begin')"

$mysql_dataset < drop_tables.sql
$mysql_dataset < create_tables.sql

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
$mysql_dataset -e "call log('$CURATED', ''${CURATED}'')"
$mysql_dataset -e "call log('${CURATED}', 'begin')"

rm -f curated.tsv
ln -s $CURATED.tsv curated.tsv

$mysql_dataset < curated.sql
$mysql_dataset < stats.sql

pushd .
cd ..
./backup_curated.sh opioid curated
./backup_curated.sh opioid expand

./export_tsv.sh opioid stats_expand
./export_tsv.sh opioid stats_keywords
./export_tsv.sh opioid stats_sab
./export_tsv.sh opioid stats_tty
./export_tsv.sh opioid stats_tui
./export_tsv.sh opioid stats_rel
./export_tsv.sh opioid stats_rela

cd opioid

$mysql_dataset -e "call log('${CURATED}', 'done')"
