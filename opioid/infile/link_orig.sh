CURATED="vsac_math"
rm $CURATED.tsv
ln -s $CURATED/$CURATED.curated.tsv $CURATED.tsv

CURATED="medrt"
rm $CURATED.tsv
ln -s $CURATED/$CURATED.curated.tsv $CURATED.tsv

CURATED="bioportal"
rm $CURATED.tsv
ln -s $CURATED/$CURATED.curated.tsv $CURATED.tsv

CURATED="custom_rxcui_str"
rm $CURATED.tsv
ln -s $CURATED/$CURATED.curated.tsv $CURATED.tsv

CURATED="bioportal_to_umls"
rm $CURATED.tsv
ln -s $CURATED/$CURATED.curated.tsv $CURATED.tsv

CURATED="wasz_april7"
rm $CURATED.tsv
ln -s $CURATED/$CURATED.curated.tsv $CURATED.tsv