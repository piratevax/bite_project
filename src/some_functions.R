library(stringr)

readFile <- function(path) {
  if (! (str_detect(path, ".csv$") || str_detect(path, ".tsv$"))) {
    stop("File not csv or tsv!")
  }
  if (str_detect(path, ".csv$")) {
    return(read.csv(path, header = TRUE))
  } else {
    return(read.table(path, header = TRUE, sep = "\t"))
  }
}

getFilteredSet <- function(tab, pval, l2FC) {
  read <- read[c(which(read[,3] > l2FC),which(read[,3] < -l2FC)),]
  read <- read[which(read[,7] < pvalFilter),]
  return(read)   
}

DEBUG <- function() {
  path <- "DE2.TH_ccRCC_checkpoints_from_all.csv"#kidney_tumour_ppl_stage.csv"
  read <- readFile(path)
  pvalFilter <- 0.05
  l2FC <- 1
  getFilteredSet(read, pvalFilter, l2FC)
}

#DEBUG()
