#!/bin/bash 

source ../common.sh 
source db.config

echo ======================================================
echo "medgen begin" 

$mysql_dataset -e "call DATASET(DATABASE())"

$mysql_dataset -e "call log('readme','DATABASE()')" 
$mysql_dataset -e "call log('DATABASE()','load')" 

echo ======================================================

$mysql_dataset -e "call log('load_tables.sh','refresh')" 

load_table tsv  omim_pubmed	 pubmed_cited
load_table rrf  MGCONSO  MGCONSO.RRF
load_table rrf  MGDEF    MGDEF.RRF
load_table rrf  MGREL    MGREL.RRF
load_table rrf  MGSAT    MGSAT.RRF 
load_table rrf  MGSTY    MGSTY.RRF
load_table rrf  NAMES    NAMES.RRF
load_table rrf  MGMERGED   MERGED.RRF
# load_table rrf  MGHISTORY  MedGen_CUI_history.txt
# load_table rrf  medgen_hpo       MedGen_HPO_Mapping.txt 
load_table rrf  medgen_hpo_omim  MedGen_HPO_OMIM_Mapping.txt 
#load_table rrf  medgen_pubmed    medgen_pubmed_lnk.txt
