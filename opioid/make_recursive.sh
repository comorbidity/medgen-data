#!/bin/bash
set -e

# clear; rm -rf tsv; rm -f infile/*expand_rxcui*; rm -f curated.tsv; $custom_rxcui_str ; rm -f infile/$CURATED.tsv
# clear; rm -rf tsv; rm -f infile/*expand_rxcui*; rm -f curated.tsv; $medrt ; rm -f infile/$CURATED.tsv

source db.config
source env_table_schema.sh

rm -f infile/$CURATED.tsv curated.tsv
ln -s infile/$CURATED.tsv curated.tsv

####
ORIG=$CURATED.curated.tsv
# ls -lah infile/$CURATED.tsv

cp infile/$ORIG infile/$CURATED.tsv

echo '///////////////////////////////'
echo " ORIG  = $ORIG"
echo " CURATED  = $CURATED"
echo '///////////////////////////////'
ls -lah infile/$CURATED.tsv

./make.sh

##################################################################################################################

TSV=$CURATED.expand_rxcui_str.tsv
TSV2=$CURATED.expand_rxcui2_str2.tsv

cp  tsv/$TSV infile/$TSV2
cat tsv/$TSV tsv/$ORIG > infile/$CURATED.tsv

echo '///////////////////////////////'
echo " ORIG  = $ORIG"
echo " TSV   = $TSV"
echo " TSV2  = $TSV2"
echo " CURATED  = $CURATED"
echo '///////////////////////////////'
ls -lah infile/$CURATED.tsv

./make.sh

#################################################################################################################
TSV3=$CURATED.expand_rxcui3_str3.tsv

cp  tsv/$TSV infile/$TSV3
cat tsv/$TSV infile/$TSV2 infile/$ORIG > infile/$CURATED.tsv

echo '///////////////////////////////'
echo " ORIG  = $ORIG"
echo " TSV   = $TSV"
echo " TSV2  = $TSV2"
echo " TSV3  = $TSV3"
echo " CURATED  = $CURATED"
echo '///////////////////////////////'
ls -lah infile/$CURATED.tsv

./make.sh


#################################################################################################################
TSV4=$CURATED.expand_rxcui4_str4.tsv

cp  tsv/$TSV infile/$TSV4
cat tsv/$TSV infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/$CURATED.tsv
./make.sh

echo "$TSV4 done"

echo ##################################################################################################################
TSV5=$CURATED.expand_rxcui5_str5.tsv

cp  tsv/$TSV infile/$TSV5
cat tsv/$TSV infile/$TSV4 infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/$CURATED.tsv
./make.sh

echo "$TSV5 done"

echo ##################################################################################################################
TSV6=$CURATED.expand_rxcui6_str6.tsv

cp  tsv/$TSV infile/$TSV6
cat tsv/$TSV infile/$TSV5 infile/$TSV4 infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/$CURATED.tsv
./make.sh

echo "$TSV6 done"

echo ##################################################################################################################
TSV7=$CURATED.expand_rxcui7_str7.tsv

cp  tsv/$TSV infile/$TSV7
cat tsv/$TSV infile/$TSV6 infile/$TSV5 infile/$TSV4 infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/$CURATED.tsv
./make.sh

echo "$TSV7 done"

echo ##################################################################################################################
TSV8=$CURATED.expand_rxcui8_str8.tsv

cp  tsv/$TSV infile/$TSV8
cat tsv/$TSV infile/$TSV7 infile/$TSV6 infile/$TSV5 infile/$TSV4 infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/$CURATED.tsv
./make.sh

echo "$TSV8 done"

echo ##################################################################################################################
TSV9=$CURATED.expand_rxcui9_str9.tsv

cp  tsv/$TSV infile/$TSV9
cat tsv/$TSV infile/$TSV8 infile/$TSV7 infile/$TSV6 infile/$TSV5 infile/$TSV4 infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/$CURATED.tsv
./make.sh

echo "$TSV9 done"

####
TSV10=$CURATED.expand_rxcui10_str10.tsv

cp  tsv/$TSV infile/$TSV10
cat tsv/$TSV infile/$TSV9 infile/$TSV8 infile/$TSV7 infile/$TSV6 infile/$TSV5 infile/$TSV4 infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/$CURATED.tsv
./make.sh

echo "$TSV10 done"

####
TSV11=$CURATED.expand_rxcui11_str11.tsv

cp  tsv/$TSV infile/$TSV11
cat tsv/$TSV infile/$TSV10 infile/$TSV9 infile/$TSV8 infile/$TSV7 infile/$TSV6 infile/$TSV5 infile/$TSV4 infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/$CURATED.tsv
./make.sh

echo "$TSV11 done"

####
TSV12=$CURATED.expand_rxcui12_str12.tsv

cp  tsv/$TSV infile/$TSV12
cat tsv/$TSV infile/$TSV11 infile/$TSV10 infile/$TSV9 infile/$TSV8 infile/$TSV7 infile/$TSV6 infile/$TSV5 infile/$TSV4 infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/$CURATED.tsv
./make.sh

echo "$TSV12 done"

####
TSV13=$CURATED.expand_rxcui13_str13.tsv

cp  tsv/$TSV infile/$TSV13
cat tsv/$TSV infile/$TSV12 infile/$TSV11 infile/$TSV10 infile/$TSV9 infile/$TSV8 infile/$TSV7 infile/$TSV6 infile/$TSV5 infile/$TSV4 infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/$CURATED.tsv
./make.sh

echo "$TSV13 done"

####
TSV14=$CURATED.expand_rxcui14_str14.tsv

cp  tsv/$TSV infile/$TSV14
cat tsv/$TSV infile/$TSV13 infile/$TSV12 infile/$TSV11 infile/$TSV10 infile/$TSV9 infile/$TSV8 infile/$TSV7 infile/$TSV6 infile/$TSV5 infile/$TSV4 infile/$TSV3 infile/$TSV2 infile/$ORIG > infile/$CURATED.tsv
./make.sh

echo "$TSV14 done"

########################################################
mkdir -p infile/$CURATED
cp infile/$CURATED.curated.tsv    infile/$CURATED/$CURATED.curated.tsv
mv infile/$CURATED.expand_rxcui*  infile/$CURATED/.
mv infile/$CURATED.tsv            infile/$CURATED/$CURATED.cat.tsv
