source db.config
$mysql_dataset < drop_tables.sql

pushd . 
cd mysqldump

$mysql_dataset -e "call log('jaccard.sh', 'https://en.wikipedia.org/wiki/Jaccard_index')"

###############################################################################
export CURATED="VSAC_Mathematica"

$mysql_dataset -e "drop table if exists curated_$CURATED, expand_$CURATED"

$mysql_dataset < opioid.curated.$CURATED.mysqldump
$mysql_dataset -e "rename table curated to curated_$CURATED"

$mysql_dataset < opioid.expand.$CURATED.mysqldump
$mysql_dataset -e "rename table expand to expand_$CURATED"

###############################################################################
export CURATED="bioportal"

$mysql_dataset -e "drop table if exists curated_$CURATED, expand_$CURATED"

$mysql_dataset < opioid.curated.$CURATED.mysqldump
$mysql_dataset -e "rename table curated to curated_$CURATED"

$mysql_dataset < opioid.expand.$CURATED.mysqldump
$mysql_dataset -e "rename table expand to expand_$CURATED"

###############################################################################
export CURATED="bioportal_to_umls"

$mysql_dataset -e "drop table if exists curated_$CURATED, expand_$CURATED"

$mysql_dataset < opioid.curated.$CURATED.mysqldump
$mysql_dataset -e "rename table curated to curated_$CURATED"

$mysql_dataset < opioid.expand.$CURATED.mysqldump
$mysql_dataset -e "rename table expand to expand_$CURATED"

################################################################################
#export CURATED="umls_reviewed_march26"
#
#$mysql_dataset -e "drop table if exists curated_$CURATED, expand_$CURATED"
#
#$mysql_dataset < opioid.curated.$CURATED.mysqldump
#$mysql_dataset -e "rename table curated to curated_$CURATED"
#
#$mysql_dataset < opioid.expand.$CURATED.mysqldump
#$mysql_dataset -e "rename table expand to expand_$CURATED"
#
################################################################################
export CURATED="umls_reviewed_april7"

$mysql_dataset -e "drop table if exists curated_$CURATED, expand_$CURATED"

$mysql_dataset < opioid.curated.$CURATED.mysqldump
$mysql_dataset -e "rename table curated to curated_$CURATED"

$mysql_dataset < opioid.expand.$CURATED.mysqldump
$mysql_dataset -e "rename table expand to expand_$CURATED"
################################################################################
