#!/bin/bash 

source ../common.sh 
source db.config

echo ======================================================
echo "ClinicalGenomics begin" 

$mysql_dataset -e "call DATASET(DATABASE())"

$mysql_dataset -e "call log('readme','DATABASE()')" 
$mysql_dataset -e "call log('DATABASE()','load')" 

echo ======================================================

$mysql_dataset -e "call log('load_tables.sh','refresh')" 

load_table tsv gene2condition       CGD.txt
