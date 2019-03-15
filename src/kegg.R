require(clusterProfiler)
require(pathview)
require(dplyr)
require(plyr)
if (species == "hsapiens") {
  require(org.Hs.eg.db)
}
if (species == "mmusculus") {
  require(org.Mm.eg.db)
}

gene.set <- read.delim("~/Bureau/NIHMS862425_trans.tsv", header = T)
gene.set <- gene.set[, c(1, 5)]

KEGG <- function (gene.set,
                  id.source = "ensembl",
                  species = "mmusculus",
                  method = "sea",
                  threshold = 0.05,
                  correction = "bonferroni") {
  if (species == "hsapiens") {
    kegg.species <- "hsa"
    organism.database <- "org.Hs.eg.db"
  } else if (species == "mmusculus") {
    kegg.species <- "mmu"
    organism.database <- "org.Mm.eg.db"
  }
  if (id.source == "ensembl") {
    species.dataset <- paste0(species, "_gene_ensembl")
    ensembl <-
      useMart(biomart = "ensembl", dataset = species.dataset)
    id.conversion <- getBM(
      attributes = c("entrezgene", "ensembl_gene_id"),
      filters = "ensembl_gene_id",
      values = gene.set[, 1],
      mart = ensembl
    )
    gene.set <- filter(gene.set, ID %in% id.conversion[, 2])
    gene.set[, 1] <-
      mapvalues(gene.set[, 1],
                from = id.conversion[, 2],
                to = id.conversion[, 1])
  }
  
  if (method == "sea") {
    kegg.output <- enrichKEGG(
      gene         = gene.set[, 1],
      organism     = kegg.species,
      pvalueCutoff = threshold,
      pAdjustMethod = correction
    )
  } else if (method == "gsea") {
    gene.list <- gene.set[, 2]
    names(gene.list) <- as.character(gene.set[, 1])
    gene.list = sort(gene.list, decreasing = TRUE)
    kegg.output <- gseKEGG(
      geneList     = gene.list,
      organism     = "mmu",
      keyType = "ncbi-geneid",
      exponent = 1,
      nPerm = 10000,
      minGSSize = 10,
      maxGSSize = length(gene.list),
      pvalueCutoff = threshold,
      pAdjustMethod = correction,
      verbose = T,
      use_internal_data = F
    )
  }
  complete.list <- as.data.frame(kegg.result@result)
  complete.list <- complete.list[, 1:7]
  
  random.string <- gsub(".*file", "", tempfile())
  temp.folder <- tempdir()
  outfile <-
    paste0(temp.folder, "/", pathID, ".", random.string, ".png")
  pathview.graph <- pathview(
    gene.data  = gene.list,
    pathway.id = kegg.output@result$ID[1],
    kegg.dir = temp.folder,
    out.suffix = random.string,
    species    = kegg.species,
    kegg.native = T,
    limit      = list(gene = max(abs(gene.list)), cpd = 1)
  )
  pathway.image.filename <- list(
    src = outfile,
    contentType = 'image/png',
    width = "100%",
    height = "100%",
    alt = "KEGG pathway image."
  )
  
  return(list("table" = complete.list, "visualization.filename" = pathway.image.filename))
}
