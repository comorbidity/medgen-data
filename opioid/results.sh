#!/bin/bash
set -e
source db.config
source env_table_schema.sh

$mysql_table_schema -e "call log('results.sh', 'begin')"

# export CURATED="vsac_math"
# export CURATED="bioportal"
# export CURATED="bioportal_to_umls"
# export CURATED="custom_rxcui_str"
# export CURATED="wasz_april7"
# export CURATED="all_rxcui_str"

if [ -z "$CURATED" ]; then
  echo "CURATED is not set. Exiting..."
  exit 1
fi

echo "Using $CURATED.tsv"
$mysql_table_schema -e "call version('${CURATED}', 'results.sh:begin')"

rm -f curated.tsv
ln -s $CURATED.tsv curated.tsv

$mysql_table_schema < curated.sql
$mysql_table_schema < expand.sql
$mysql_table_schema < stats.sql

./export_tsv.sh version

./export_tsv.sh stats_keywords
./export_tsv.sh stats_sab
./export_tsv.sh stats_tty
./export_tsv.sh stats_tui
./export_tsv.sh stats_expand
./export_tsv.sh stats_expand_rel
./export_tsv.sh stats_expand_rela
./export_tsv.sh stats_expand_rela_tty

./export_tsv.sh RXNCONSO_curated
./export_tsv.sh keywords
./export_tsv.sh expand
./export_tsv.sh expand_tradename
./export_tsv.sh expand_consists
./export_tsv.sh expand_isa
./export_tsv.sh expand_ingredient
./export_tsv.sh expand_doseform
./export_tsv.sh expand_form
./export_tsv.sh expand_other






$mysql_table_schema -e "call version('${CURATED}', 'results.sh:done')"
$mysql_table_schema -e "call log('results.sh', 'done')"
$mysql_table_schema -e "call mem"
