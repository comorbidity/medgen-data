#!/bin/bash
set -e
source db.config
source env_table_schema.sh

$mysql_table_schema -e "call log('results.sh', 'begin')"

# export CURATED="custom_rxcui_str"
# export CURATED="all_rxcui_str"
# export CURATED="vsac_math"
# export CURATED="bioportal"
# export CURATED="bioportal_to_umls"
# export CURATED="wasz_april7"

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

#./export_tsv.sh stats_expand
#./export_tsv.sh stats_keywords
#./export_tsv.sh stats_sab
#./export_tsv.sh stats_tty
#./export_tsv.sh stats_tui
#./export_tsv.sh stats_rel
#./export_tsv.sh stats_rela

$mysql_table_schema -e "call version('${CURATED}', 'results.sh:done')"
$mysql_table_schema -e "call log('results.sh', 'done')"
$mysql_table_schema -e "call mem"
