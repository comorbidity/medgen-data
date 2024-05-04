#!/bin/bash
set -e
export CURATED="opioid"

source db.config
source env_table_schema.sh

rm -f infile/opioid.tsv curated.tsv
ln -s infile/opioid.tsv curated.tsv

####
ORIG=medrt.curated.tsv

cp tsv/$ORIG infile/$ORIG
cp tsv/$ORIG infile/opioid.tsv
./make.sh

####
TSV=opioid.expand_rxcui_str.tsv
TSV2=opioid.expand_rxcui2_str2.tsv

cp  tsv/$TSV infile/$TSV2
cat tsv/$TSV tsv/$ORIG > infile/opioid.tsv
./make.sh

####
TSV3=opioid.expand_rxcui3_str3.tsv

cp  tsv/$TSV infile/$TSV3
cat tsv/$TSV infile/$TSV2 infile/$ORIG > infile/opioid.tsv
./make.sh

####
TSV4=opioid.expand_rxcui4_str4.tsv

cp  tsv/$TSV infile/$TSV4
cat tsv/$TSV infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/opioid.tsv
./make.sh

####
TSV5=opioid.expand_rxcui5_str5.tsv

cp  tsv/$TSV infile/$TSV5
cat tsv/$TSV infile/$TSV4 infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/opioid.tsv
./make.sh

####
TSV6=opioid.expand_rxcui6_str6.tsv

cp  tsv/$TSV infile/$TSV6
cat tsv/$TSV infile/$TSV5 infile/$TSV4 infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/opioid.tsv
./make.sh

####
TSV7=opioid.expand_rxcui7_str7.tsv

cp  tsv/$TSV infile/$TSV7
cat tsv/$TSV infile/$TSV6 infile/$TSV5 infile/$TSV4 infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/opioid.tsv
./make.sh

####
TSV8=opioid.expand_rxcui8_str8.tsv

cp  tsv/$TSV infile/$TSV8
cat tsv/$TSV infile/$TSV7 infile/$TSV6 infile/$TSV5 infile/$TSV4 infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/opioid.tsv
./make.sh

####
TSV9=opioid.expand_rxcui9_str9.tsv

cp  tsv/$TSV infile/$TSV9
cat tsv/$TSV infile/$TSV8 infile/$TSV7 infile/$TSV6 infile/$TSV5 infile/$TSV4 infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/opioid.tsv
./make.sh

####
TSV10=opioid.expand_rxcui9_str9.tsv

cp  tsv/$TSV infile/$TSV10
cat tsv/$TSV infile/$TSV9 infile/$TSV8 infile/$TSV7 infile/$TSV6 infile/$TSV5 infile/$TSV4 infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/opioid.tsv
./make.sh
