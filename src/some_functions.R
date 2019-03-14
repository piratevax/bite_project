require(stringr)
require(ggplot2)
require(biomaRt)
require(org.Hs.eg.db)
library(org.Mm.eg.db)
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

generateVolcanoPlot <- function(x, alpha = 0.05, l2FC = 0, absolute = TRUE) {
  if (absolute) {
    x$limits <- as.factor(abs(x$log2FoldChange) > l2FC & x$padj < alpha)
  } else {
    x$limits <- as.factor(x$log2FoldChange > l2FC & x$padj < alpha)
  }
  levels(x$limits) <- c("N", "S")
  g <- ggplot(x, aes(x=log2FoldChange, y=-log10(padj), colour=limits)) +
    geom_point(alpha=0.8, size=2) +
    xlab("log2 fold change") + ylab("-log10 p-value adjusted")
  return(g)
}

generateMAPlot <- function(x, alpha = 0.05, l2FC = 0, absolute = TRUE) {
  if (absolute) {
    x$limits <- as.factor(abs(x$log2FoldChange) > l2FC & x$padj < alpha)
  } else {
    x$limits <- as.factor(x$log2FoldChange > l2FC & x$padj < alpha)
  }
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

getSignificativeGene <- function(x, alpha = 0.05, l2FC = 0, absolute = TRUE) {
  if (absolute) {
    return(x[which(abs(x$log2FoldChange) > l2FC & x$padj < alpha),])
  } else {
    return(x[which(x$log2FoldChange > l2FC & x$padj < alpha),])
  }
}

retreiveFoldChange <- function(l2FC) {
  return(2^l2FC)
}

getGeneListClusterProfiler <- function(read, analysis = "GO", organism) {
  if (organism == "hsapiens") {
    orgDB <- org.Hs.eg.db
  } else if (organism == "mmusculus") {
    orgDB <- org.Mm.eg.db
  }
  geneList <- sapply(read$log2FoldChange, retreiveFoldChange)
  if (analysis == "GO") {
    names(geneList) <- read$ID
  } else {
    names(geneList) <- convertType(read$ID, organism = organism, to = "UNIPROT")
  }
  geneList <- sort(geneList, decreasing = TRUE)
  return(geneList)
}

gseaGO <- function(geneList, alpha = 0.05, ont = "ALL", adjustMethod = "BH", organism) {
  if (organism == "hsapiens") {
    orgDB <- org.Hs.eg.db
  } else if (organism == "mmusculus") {
    orgDB <- org.Mm.eg.db
  }
  ego <- gseGO(geneList = geneList,
    OrgDb = orgDB,
    ont = ont, # one of "BP", "MF", "CC" or "ALL"
    nPerm = 10000,
    minGSSize = 10,
    maxGSSize = 500,
    pAdjustMethod = adjustMethod,
    pvalueCutoff = alpha)
  return(ego)
}

enrichmentGO <- function(read, alpha = 0.05, ont, adjustMethod = "BH", organism) {
  if (organism == "hsapiens") {
    orgDB <- org.Hs.eg.db
  } else if (organism == "mmusculus") {
    orgDB <- org.Mm.eg.db
  }
  ego <- enrichGO(gene = read$ID,
               OrgDb = orgDB,
               ont = ont, # one of "BP", "MF" or "CC"
               keyType = "ENTREZID",
               pAdjustMethod = adjustMethod,
               pvalueCutoff = alpha)
  return(ego)
}

convertType <- function(ids, from = "ENTREZID", to, organism) {
  if (organism == "hsapiens") {
    orgDB <- org.Hs.eg.db
  } else if (organism == "mmusculus") {
    orgDB <- org.Mm.eg.db
  }
  conv <- bitr(ids, fromType=from, toType=to, OrgDb=orgDB)
  return(conv[,2])
}

GOLink <- function(x) {
  return(HTML(paste("<a href='http://amigo.geneontology.org/amigo/term/", x, "'>", x, "</a>", sep = "")))
}

GOList <- function(x) {
  return(list("ID"=as.vector(sapply(x$ID, GOLink)), "Description"=x$Description, "p.adjust"=x$p.adjust))
}

gseaKegg <- function(geneList, alpha = 0.05, organism) {
  if (organism == "hsapiens") {
    org <- "hsa"
  } else if (organism == "mmusculus") {
    org <- "mmu"
  }
  kk <- gseKEGG(geneList     = geneList,
                 organism     = org,
                 nPerm        = 10000,
                 minGSSize    = 120,
                 pvalueCutoff = alpha,
                 keyType = "uniprot",
                 verbose      = FALSE)
  return(kk)
}

enrichmentKegg <- function(read, alpha = 0.05, organism) {
  if (organism == "hsapiens") {
    org <- "hsa"
  } else if (organism == "mmusculus") {
    org <- "mmu"
  }
  kk <- enrichKEGG(gene         = convertType(gene$ID, to = "UNIPROT", organism = organism),
                   organism     = org,
                   pvalueCutoff = alpha)
  return(kk)
}

DEBUG <- function() {
  path <- "NIHMS862425_trans.tsv"#"small.tsv"
  read <- readFile(path, TRUE)
  pvalFilter <- 0.05
  l2FC <- 1
  getFilteredSet(read, pvalFilter, l2FC)
  generateVolcanoPlot(read, l2FC = l2FC)
  generateMAPlot(read, l2FC = l2FC)
  
  sort(as.numeric(bitr(as.vector(read[,1]), fromType = "SYMBOL", toType = "ENTREZID", OrgDb="org.Hs.eg.db")[,2]), decreasing = TRUE)
}

#DEBUG()
