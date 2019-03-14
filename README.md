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
\[Tuto ultra-rapide : comment qu'on fait des trucs]

# Input files
## Format
Input format is either .csv or .tsv

## Content
Input file must containt, *in that particular order*
* Gene ID either an Ensembl or a NCBI ID
* Base mean (average read count)
* Log2 of the Fold Change (log2 of ratio between condition A and B)
* Adjusted p-value


# Parameters
## Common parameters
* ID Gene source
* Species
* Enrichment algorimth
  * GSEA
  * SEA
* Statistical test supported for all analyses
  * Chi-squared test
  * Fisher test
  * Binomial test
  * Hypergeometric test
* p-value adjustment
  * Bonferroni
  * Benjamini-Hochberg
  
## Data inspection
Cutoffs for log2 Fold-change and p-value can be applied


## GO terms
All three levels of the Gene Ontology can be investigated using the following databases :
* GO

## Pathways
Molecular pathways can be investigated using the following databases :
* GO

## Protein domains
Protein domains can be investigated using the following databases :
* PFam
* InterPro

# Output
## Data inspection
Whole data inspection outputs a volcano plot, a MA plot, and a sortable table of the raw data.

## GO terms
GO terms enrichement analysis results ni a \[A voir avec Xavier\]

## Pathways


## Protein domains



# Packages used and dependencies
\[Faire le session.info() en dernier, ajouter une courte description si possible]

# Troobleshooting and FAQ
SInce no user have reported any kind of problem with the app, I'll go straight to the FAQ.

### How are you ?
Fine, thanks.

### What are the species currently supported ?
As of right now, only the human genome and the mouse genome are supported, and it will not be expanded whatsoever.

### Star Wars movies in order of preference ?
II, I, VII IV, VI, VII, III, V.

### How do you think you handled that project ?
F\**k that s\**t.

### Language !
That's not a question.

### My rabbit is getting agressive towards knights, what do I do ?
Do you have a Saint Grenade of Antioch ? Otherwise run.

### Third favorite dinosaur ?
Triceratops.

### 5 341 325 x 15 132 ?
80 824 929 900.

### Who's the best in the team ?
You are. <3

### Next project ?
Don't know yet but f\**k that s\**t too.
