select curated, count(distinct RXCUI) cnt
from RXNCONSO_curated_jaccard
group by curated
order by cnt desc;