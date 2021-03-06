# Bioinformatics Interactive Toolbox for Enrichment analysis

BITE Analysis Shiny app that provides a graphical interface to perform enrichment analysis for RNA-Seq gene sets (and associated values).

Bioinformatics Interactive Toolbox for Enrichment analysis, or BITE Analysis, is developed as an assignment in the 'Bioinformatics in omic sciences : genomic and transcriptomic analysis' subject area. This is a subject of the Master's degree in Bioinformatics, statistics and modeling done at the Rouen-Normandie University, France.


# Summary

[Overview](https://github.com/piratevax/bite_project#overview)

[Input files](https://github.com/piratevax/bite_project#input-files)

[Parameters](https://github.com/piratevax/bite_project#parameters)

[Output](https://github.com/piratevax/bite_project#output)

[Packages used and dependencies](https://github.com/piratevax/bite_project#packages-used-and-dependencies)

[Troobleshooting and FAQ](https://github.com/piratevax/bite_project/blob/master/README.md#troobleshooting-and-faq)


# Overview
* Upload a differential expression file
* Select an analysis using tabs
* Set the parameters of your choosing
* Add the analysis to the queue using the 'Submit' button
* Release the queue using the 'GO' button on the sidebar

[Return to summary](https://github.com/piratevax/bite_project#summary)

# Input files
## Format
Input format is either .csv or .tsv

## Content
Input file must containt, *in that particular order*
* Gene ID either an Ensembl or a NCBI ID
* Base mean (average read count)
* Log2 of the Fold Change (log2 of ratio between condition A and B)
* Adjusted p-value


[Return to summary](https://github.com/piratevax/bite_project#summary)

# Parameters
## Common parameters
* ID Gene source
* Species
* Enrichment algorimth
  * GSEA
  * SEA
* Statistical test supported for all analyses
  * Chi-squared test
  * Fisher's exact test
  * G-test
  * Binomial test
  * Hypergeometric test
* p-value adjustment
  * Bonferroni
  * Benjamini-Hochberg
  
## Data inspection
Cutoffs for log2 Fold-change and p-value can be applied.

## GO terms
All three levels of the Gene Ontology are investigated using the GO database.

## Pathways
Pathways are enriched using the KEGG database.

## Protein domains
Protein domains can be investigated using the following databases :
* PFam
* InterPro

[Return to summary](https://github.com/piratevax/bite_project#summary)


# Output
## Data inspection
Whole data inspection outputs : 
* A volcano plot
* A MA plot
* A sortable table of the raw data.

## GO terms
GO terms enrichement analysis results in :
* Table containing the GO ID, its description and the adjusted p-value 
* A plot aggregating significant metrics such as the p-value or the ratio between condition A and B.

## Pathways
The output of the pathway enrichment is : 
* Table containing the pathway ID, its name and the associated metrics.
* Graph of the pathway containing the over/under-expressed genes.

## Protein domains
The output of the protein domain enrichment is : 
* A table containing the protein domain ID, its name and the associated metrics.
* A bar plot of most significaltly enriched / empoverished protein domains

[Return to summary](https://github.com/piratevax/bite_project#summary)

# Packages used and dependencies

### Main packages
pathview_1.22.3

PFAM.db_3.7.0

DescTools_0.99.27

dplyr_0.8.0.1

clusterProfiler_3.10.1

org.Mm.eg.db_3.7.0

org.Hs.eg.db_3.7.0

AnnotationDbi_1.44.0

IRanges_2.16.0

S4Vectors_0.20.1      

Biobase_2.42.0

BiocGenerics_0.28.0

biomaRt_2.38.0

ggplot2_3.1.0

stringr_1.3.1         

DT_0.5

shinythemes_1.1.2

shiny_1.2.0

### Main packages dependencies

fgsea_1.8.0

colorspace_1.4-0

ggridges_0.5.1

qvalue_2.14.1

XVector_0.22.0

farver_1.1.0

urltools_1.7.2   

ggrepel_0.8.0

bit64_0.9-7

manipulate_1.0.1

mvtnorm_1.0-10

xml2_1.2.0

splines_3.5.2

GOSemSim_2.8.0

polyclip_1.10-0

jsonlite_1.5

GO.db_3.7.0

png_0.1-7

graph_1.60.0

ggforce_0.2.1

BiocManager_1.30.4

compiler_3.5.2

httr_1.4.0

rvcheck_0.1.3

assertthat_0.2.0

Matrix_1.2-15

lazyeval_0.2.1

later_0.8.0

tweenr_1.0.1

htmltools_0.3.6

prettyunits_1.0.2

tools_3.5.2

igraph_1.2.4

gtable_0.2.0

glue_1.3.0

reshape2_1.4.3

DO.db_2.9

fastmatch_1.1-0

Rcpp_1.0.0

enrichplot_1.2.0

Biostrings_2.50.2

crosstalk_1.0.0

ggraph_1.0.2

mime_0.6

XML_3.98-1.19

DOSE_3.8.2

zlibbioc_1.28.0

europepmc_0.3

MASS_7.3-51.1

scales_1.0.0

hms_0.4.2

promises_1.0.1

KEGGgraph_1.42.0

expm_0.999-3

RColorBrewer_1.1-2

yaml_2.2.0

memoise_1.1.0

gridExtra_2.3

UpSetR_1.3.3

triebeard_0.3.0

stringi_1.2.4

RSQLite_2.1.1

boot_1.3-20

BiocParallel_1.16.6

rlang_0.3.1

pkgconfig_2.0.2

bitops_1.0-6

lattice_0.20-38

purrr_0.3.1

labeling_0.3

htmlwidgets_1.3

cowplot_0.9.4

bit_1.1-14

tidyselect_0.2.5

plyr_1.8.4

magrittr_1.5

R6_2.3.0

DBI_1.0.0

pillar_1.3.1

foreign_0.8-71

withr_2.1.2

KEGGREST_1.22.0

RCurl_1.95-4.11

tibble_2.0.1

crayon_1.3.4

viridis_0.5.1

progress_1.2.0

grid_3.5.2

data.table_1.11.8

blob_1.1.1

Rgraphviz_2.26.0

digest_0.6.18

xtable_1.8-3

tidyr_0.8.3

httpuv_1.4.5.1

gridGraphics_0.3-0

munsell_0.5.0

viridisLite_0.3.0

ggplotify_0.0.3

[Return to summary](https://github.com/piratevax/bite_project#summary)


