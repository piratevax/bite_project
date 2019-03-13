require(stringr)
require(ggplot2)
require(biomaRt)
require(org.Hs.eg.db)
require(clusterProfiler)


readFile <- function(path, header) {
  # if (! (str_detect(path, ".csv$") || str_detect(path, ".tsv$"))) {
  #   stop("File not csv or tsv!")
  # }
  if (str_detect(path, ".csv$")) {
    return(read.csv(path, header = header))
  } else {
    return(read.table(path, header = header, sep = "\t"))
  }
}

getFilteredSet <- function(tab, pval, l2FC) {
  read <- read[c(which(read[,3] > l2FC),which(read[,3] < -l2FC)),]
  read <- read[which(read[,7] < pvalFilter),]
  return(read)   
}

getBiomartDataset <- function() {
  ensembl <- useMart("ensembl")
  ensemblDataset <- listDatasets(ensembl)$dataset
  listDataset <- as.list(ensemblDataset)
  names(listDataset) <- str_extract(ensemblDataset, "^[a-zA-Z0-9]+")
  return(listDataset)
}

generateVolcanoPlot <- function(x, alpha = 0.05, l2FC = 0) {
  x$limits <- as.factor(abs(x$log2FoldChange) > l2FC & x$padj < alpha/dim(x)[1])
  levels(x$limits) <- c("N", "S")
  g <- ggplot(x, aes(x=log2FoldChange, y=-log10(padj), colour=limits)) +
    geom_point(alpha=0.8, size=2) +
    xlab("log2 fold change") + ylab("-log10 p-value adjusted")
  return(g)
}

generateMAPlot <- function(x, alpha = 0.05, l2FC = 0) {
  x$limits <- as.factor(abs(x$log2FoldChange) > l2FC & x$padj < alpha/dim(x)[1])
  levels(x$limits) <- c("N", "S")
  g <- ggplot(x, aes(x=baseMean, y=log2FoldChange, colour=limits)) +
    geom_point(alpha=0.8, size=2) +
    xlab("Means of normalized counts") + ylab("log2 fold change")
  return(g)
}

writePlot <- function(graph, name = "default.png", width = 1000, height = 1000) {
  png(name, width, height, bg = "transparent")
  print(graph)
  void <- dev.off()
}

getSignificativeGene <- function(x, alpha = 0.05, l2FC = 0) {
  return(x[which(abs(x$log2FoldChange) > 2 & x$padj < 0.05),])
}

gseaGO <- function(geneList, background, alpha = 0.05, ont, adjustMethod = "ALL") {
  ego <- gseGO(geneList = geneList,
    OrgDb = org.Hs.eg.db,
    ont = ont, # one of "BP", "MF", "CC" or "ALL"
    nPerm = 1000,
    minGSSize = 100,
    maxGSSize = 500,
    pAdjustMethod = adjustMethod,
    pvalueCutoff = alpha)
  return(ego)#list(ego$ID, ego$Description, ego$p.adjust))
}

DEBUG <- function() {
  path <- "DE2.TH_ccRCC_checkpoints_from_all.csv"
  read <- readFile(path, TRUE)
  pvalFilter <- 0.05
  l2FC <- 1
  getFilteredSet(read, pvalFilter, l2FC)
  generateVolcanoPlot(read, l2FC = l2FC)
  generateMAPlot(read, l2FC = l2FC)
}

#DEBUG()
