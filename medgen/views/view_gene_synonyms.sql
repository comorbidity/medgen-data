-- ###################################################
call log('view_gene_synonyms', 'refresh');

drop   table if exists medgen.view_gene_synonyms;
create table           medgen.view_gene_synonyms
select distinct '        ' as MedGenCUI, GeneID, Symbol, Synonyms
from   gene.gene_info G
where G.tax_id ='9606'
order by Symbol, GeneID;

update view_gene_synonyms set Synonyms = '' where Synonyms = '-';  
update view_gene_synonyms G, gene.mim2gene_medgen M set G.MedGenCUI = M.MedGenCUI where G.GeneID = M.GeneID;

call utf8_unicode('medgen.view_gene_synonyms');

-- ###################################################
call log('bsv_medgen_gene', 'done');

drop   table if exists medgen.bsv_medgen_gene;
CREATE TABLE          medgen.bsv_medgen_gene(
  CUI varchar(20)  NOT NULL,
  TUI char(4)  NOT NULL,
  TTY varchar(40)  NOT NULL,
  CODE varchar(100)  NOT NULL,
  SAB varchar(40)  NOT NULL,
  STR varchar(255)  DEFAULT NULL,
  PREF varchar(255)  DEFAULT NULL,
  KEY CUI (CUI),
  KEY TUI (TUI),
  KEY SAB (SAB,CODE),
  KEY STR (STR(100)),
  KEY PREF (PREF(100))
);

call utf8_unicode('medgen.bsv_medgen_gene');

