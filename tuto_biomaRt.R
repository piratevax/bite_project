library(biomaRt)

ensembl=useMart("ensembl")
listDatasets(ensembl)
ensembl = useDataset("hsapiens_gene_ensembl",mart=ensembl) #ensembl = useMart("ensembl",dataset="hsapiens_gene_ensembl")

filters = listFilters(ensembl)
filters[1:5,]
attributes = listAttributes(ensembl)
attributes[1:5,]
affyids=c("202763_at","209310_s_at","207500_at")
getBM(attributes=c('affy_hg_u133_plus_2', 'entrezgene'), 
      filters = 'affy_hg_u133_plus_2', 
      values = affyids, 
      mart = ensembl)

searchDatasets(mart = ensembl, pattern = "hsapiens")
searchAttributes(mart = ensembl, pattern = "hgnc")
searchFilters(mart = ensembl, pattern = "ensembl.*id")

#  Annotate a set of Affymetrix identifiers with HUGO symbol and chromosomal locations of corresponding genes
affyids=c("202763_at","209310_s_at","207500_at")
getBM(attributes = c('affy_hg_u133_plus_2', 'hgnc_symbol', 'chromosome_name',
                     'start_position', 'end_position', 'band'),
      filters = 'affy_hg_u133_plus_2', 
      values = affyids, 
      mart = ensembl)

#  Annotate a set of EntrezGene identifiers with GO annotation
entrez=c("673","837")
goids = getBM(attributes = c('entrezgene', 'go_id'), 
              filters = 'entrezgene', 
              values = entrez, 
              mart = ensembl)
head(goids)

#  Retrieve all HUGO gene symbols of genes that are located on chromosomes 17,20 or Y, and are associated with specific GO terms
go=c("GO:0051330","GO:0000080","GO:0000114","GO:0000082")
chrom=c(17,20,"Y")
getBM(attributes= "hgnc_symbol",
      filters=c("go","chromosome_name"),
      values=list(go, chrom), mart=ensembl)

#  Annotate set of idenfiers with INTERPRO protein domain identifiers
refseqids = c("NM_005359","NM_000546")
ipro = getBM(attributes=c("refseq_mrna","interpro","interpro_description"), 
             filters="refseq_mrna",
             values=refseqids, 
             mart=ensembl)
ipro

#  Select all Affymetrix identifiers on the hgu133plus2 chip and Ensembl gene identifiers for genes located on chromosome 16 between basepair 1100000 and 1250000.
getBM(attributes = c('affy_hg_u133_plus_2','ensembl_gene_id'), 
      filters = c('chromosome_name','start','end'),
      values = list(16,1100000,1250000), 
      mart = ensembl)

#  Retrieve all entrezgene identifiers and HUGO gene symbols of genes which have a “MAP kinase activity” GO term associated with it.
getBM(attributes = c('entrezgene','hgnc_symbol'), 
      filters = 'go', 
      values = 'GO:0004707', 
      mart = ensembl)

# Given a set of EntrezGene identifiers, retrieve 100bp upstream promoter sequences
entrez=c("673","7157","837")
getSequence(id = entrez, 
            type="entrezgene",
            seqType="coding_gene_flank",
            upstream=100, 
            mart=ensembl) 
#  Retrieve all 5’ UTR sequences of all genes that are located on chromosome 3 between the positions 185,514,033 and 185,535,839
utr5 = getSequence(chromosome=3, start=185514033, end=185535839,
                   type="entrezgene",
                   seqType="5utr", 
                   mart=ensembl)
utr5

#  Retrieve protein sequences for a given list of EntrezGene identifiers
protein = getSequence(id=c(100, 5728),
                      type="entrezgene",
                      seqType="peptide", 
                      mart=ensembl)
protein

#  Retrieve known SNPs located on the human chromosome 8 between positions 148350 and 148612
snpmart = useMart(biomart = "ENSEMBL_MART_SNP", dataset="hsapiens_snp")
getBM(attributes = c('refsnp_id','allele','chrom_start','chrom_strand'), 
      filters = c('chr_name','start','end'), 
      values = list(8,148350,148612), 
      mart = snpmart)

#  Given the human gene TP53, retrieve the human chromosomal location of this gene and also retrieve the chromosomal location and RefSeq id of its homolog in mouse.
human = useMart("ensembl", dataset = "hsapiens_gene_ensembl")
mouse = useMart("ensembl", dataset = "mmusculus_gene_ensembl")
getLDS(attributes = c("hgnc_symbol","chromosome_name", "start_position"),
       filters = "hgnc_symbol", values = "TP53",mart = human,
       attributesL = c("refseq_mrna","chromosome_name","start_position"), martL = mouse)

exportFASTA()
