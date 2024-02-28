# Download RxNorm

*requires UMLS license*
* https://download.nlm.nih.gov/umls/kss/rxnorm/RxNorm_full_02052024.zip

# RxNorm

* [Source Representation](https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/RXNORM/sourcerepresentation.html)
* [Prescribable Drugs](https://www.nlm.nih.gov/research/umls/rxnorm/docs/prescribe.html) 
* [Technical Doc](https://www.nlm.nih.gov/research/umls/rxnorm/docs/techdoc.html) 
* [Relationships](https://www.nlm.nih.gov/research/umls/rxnorm/docs/appendix1.html)
* [Dose Forms](https://www.nlm.nih.gov/research/umls/rxnorm/docs/appendix2.html)
* [Dose Form Groups](https://www.nlm.nih.gov/research/umls/rxnorm/docs/appendix3.html)
* [Term Types](https://www.nlm.nih.gov/research/umls/rxnorm/docs/appendix5.html)

# Makefile

cd medgen-umls

    ./unpack.sh rxnorm
    ./create_database.sh rxnorm
    ./load_database.sh rxnorm
    ./index_database.sh rxnorm

# Schema
| Table | Description|
|------------------|----------|
| RXNATOMARCHIVE   | Archive|
| RXNCONSO         | [Concept Names, IDs, and sources](https://www.nlm.nih.gov/research/umls/rxnorm/docs/techdoc.html#conso)|
| RXNCUI           | Concept Unique Identifiers|
| RXNCUICHANGES    | Changes|
| RXNDOC           | [Documentation](https://www.nlm.nih.gov/research/umls/rxnorm/docs/techdoc.html#doc)|
| RXNREL           | [Relationships](https://www.nlm.nih.gov/research/umls/rxnorm/docs/techdoc.html#rel)|
| RXNSAB           | [Source Medical Vocabs](https://www.nlm.nih.gov/research/umls/rxnorm/docs/techdoc.html#s12_0)|
| RXNSAT           | [Attributes](https://www.nlm.nih.gov/research/umls/rxnorm/docs/techdoc.html#s12_0)|
| RXNSTY           | [Semantic Types](https://www.nlm.nih.gov/research/umls/rxnorm/docs/techdoc.html#s12_0)|
