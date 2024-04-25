if [ -z "$CURATED" ]; then
  echo "CURATED is not set. Exiting..."
  exit 1
fi

pushd .
cd mysqldump

$mysql_table_schema -e "call log('jaccard.sh', 'begin')"
echo "###############################################################################"
$mysql_table_schema -e "call log('jaccard.sh', '$CURATED')"

$mysql_table_schema -e "drop table if exists RXNCONSO_curated_$CURATED, curated_$CURATED, expand_$CURATED"

$mysql_table_schema < opioid.RXNCONSO_curated.$CURATED.mysqldump
$mysql_table_schema -e "rename table RXNCONSO_curated to RXNCONSO_curated_$CURATED"

$mysql_table_schema < opioid.curated.$CURATED.mysqldump
$mysql_table_schema -e "rename table curated to curated_$CURATED"

$mysql_table_schema < opioid.expand.$CURATED.mysqldump
$mysql_table_schema -e "rename table expand to expand_$CURATED"
echo "###############################################################################"
$mysql_table_schema -e "call log('jaccard.sh', 'done')"

popd
