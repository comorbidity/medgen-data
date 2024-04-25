if [ -z "$CURATED" ]; then
  echo "CURATED is not set. Exiting..."
  exit 1
fi

pushd .
cd mysqldump

$mysql_dataset -e "call log('jaccard.sh', 'begin')"
echo "###############################################################################"
$mysql_dataset -e "call log('jaccard.sh', '$CURATED')"

$mysql_dataset -e "drop table if exists RXNCONSO_curated_$CURATED, curated_$CURATED, expand_$CURATED"

$mysql_dataset < opioid.RXNCONSO_curated.$CURATED.mysqldump
$mysql_dataset -e "rename table RXNCONSO_curated to RXNCONSO_curated_$CURATED"

$mysql_dataset < opioid.curated.$CURATED.mysqldump
$mysql_dataset -e "rename table curated to curated_$CURATED"

$mysql_dataset < opioid.expand.$CURATED.mysqldump
$mysql_dataset -e "rename table expand to expand_$CURATED"
echo "###############################################################################"
$mysql_dataset -e "call log('jaccard.sh', 'done')"

popd
