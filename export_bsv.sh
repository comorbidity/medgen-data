#!/bin/bash

MYSQL_OUTFILE=$(pwd)

set -e

export TODAY="$(date +%Y-%m-%d__h%Hm%Ms%S)"

source common.sh 

require   $1 "pick a database, example umls"
require   $2 "pick a table, example bsv_problem_syn" 

dbconfig="$1/db.config"

require $dbconfig "DATASET/db.config not found" 
source  $dbconfig

export DB_TABLE=$2
export BSV_FILE="$DB_TABLE.bsv"

echo '##########################' 
echo " DATASET  = $DATASET "
echo " TODAY    = $TODAY" 
echo " DB_TABLE = $DB_TABLE" 
echo " BSV_FILE  = $BSV_FILE " 
echo '##########################' 

mkdir -p $DATASET/bsv/$TODAY

$mysql_dataset -e "call log('export_bsv.sh', 'begin')"

export OUTFILE="$MYSQL_OUTFILE/$DATASET/bsv/$TODAY/$BSV_FILE"

rm -f $OUTFILE

$mysql_dataset -e "select * into outfile '$OUTFILE' FIELDS TERMINATED BY '|' from $DB_TABLE" 

$mysql_dataset -e "call log('export_bsv.sh', 'done')"

pushd .

cd $DATASET/bsv

rm -f $BSV_FILE
ln -s $TODAY/$BSV_FILE $BSV_FILE

ls -lh *.bsv

echo '    ' 
echo 'done' 
echo '##########################' 
