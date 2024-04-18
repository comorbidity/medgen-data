#!/bin/bash

source common.sh 

require   $1 "pick a dataset like ./drop_database.sh clinvar" 

dbconfig="$1/db.config"

require $dbconfig "DATASET/db.config not found" 
source  $dbconfig

require $DATASET  "which dataset?" 

$mysql_dataset -e "drop database if exists $DATASET" 
