#!/bin/bash

source db.config

echo "start clean"
$mysql_dataset -e "call log('refresh', 'begin')"

$mysql_dataset < drop_tables.sql
$mysql_dataset < create_tables.sql

#export CURATED="VSAC_Mathematica"
#export CURATED="curated_from_bioportal"
#export CURATED="expanded_from_bioportal"
export CURATED="curated_from_expanded_march26"

echo "Using $CURATED.tsv"
$mysql_dataset -e "call log('${CURATED}', 'begin')"

rm -f curated.tsv
ln -s $CURATED.tsv curated.tsv

$mysql_dataset < curated.sql
$mysql_dataset < stats.sql

pushd .
cd ..
./backup_curated.sh opioid curated
./backup_curated.sh opioid curated

./export_tsv.sh opioid stats_sab
./export_tsv.sh opioid stats_tty
./export_tsv.sh opioid stats_tui
./export_tsv.sh opioid stats_rel
./export_tsv.sh opioid stats_rela

cd opioid

$mysql_dataset -e "call log('${CURATED}', 'done')"

# ./export_bsv.sh rxnorm expand
# ./export_bsv.sh rxnorm expand_consists
# ./export_bsv.sh rxnorm expand_doseform
# ./export_bsv.sh rxnorm expand_form
# ./export_bsv.sh rxnorm expand_ingredient
# ./export_bsv.sh rxnorm expand_ingredients
# ./export_bsv.sh rxnorm expand_isa
# ./export_bsv.sh rxnorm expand_tradename
# ./export_bsv.sh rxnorm expand_cui
# ./export_bsv.sh rxnorm expand_cui_str
# ./export_bsv.sh rxnorm expand_cui_rela_cui
# ./export_bsv.sh rxnorm expand_cui_rela_str
