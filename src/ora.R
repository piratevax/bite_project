        ###############################################################
       ## SINGULAR ENRICHMENT ANALYSIS / OVER REPRESENTATION ANALYSIS ##
        ###############################################################

        # Args:
        #   gene.set: (list, array) gene IDs to enrich
        #   database: (character) database for fetching domain IDs
        #   species: (character) species for querying biomaRt
        #   test: (character) statistical test to use
        #         "g-test", "chi-squared", "fisher", "hypergeometric",
        #         "binomial"
        #   enrichment: (character) directionality of the enrichment
        #   threshold! (numeric) threshold for tests and selection of
        #                        significant domains
        #   correction: (character) multiple comparison correction method
        #               "bonferonni", "BH"
        #
        # Returns:
        #   (dataframe) list of significantly enriched domains
        #   (plot) plot of top 10 significantly enriched domains
        

# Chargement des bibliothèques
require(biomaRt)                                                                # requêtes Ensembl + conversion ID Interpro
require(dplyr)                                                                  # manipulation données
require(DescTools)                                                              # g-test
require(PFAM.db)                                                                # conversion ID Pfam
require(ggplot2)

################################ MAIN FUNCTION ################################

ORA <- function (gene.set,
                 database = "interpro",
                 species = "hsapiens",
                 test = "g-test",
                 enrichment = "both",
                 threshold = 0.05,
                 correction = "BH")
{
  background <- GetBackgroundGenes(database, species)
  annotated.gene.set <-
    filter(background, ensembl_gene_id %in% gene.set)
  filtered.background <-
    filter(background, !ensembl_gene_id %in% gene.set)
  domains <- unique(annotated.gene.set[database][, 1])
  contingency.tables <-
    lapply(domains,
           GenerateContingencyTables,
           gene.set = annotated.gene.set,
           background = filtered.background)
  over.or.underrepresented <-
    lapply(contingency.tables,
           RunTest,
           test = test,
           enrichment = enrichment)
  col.names <- c("ID", "gene count (set)", "gene count (background)", "jaccard", "p-value")
  tmp <- as.data.frame(over.or.underrepresented, stringsAsFactors = F)
  tmp2 <- matrix(tmp[1,], ncol = 5, byrow = T)
  metrics <- as.data.frame(tmp2, col.names = col.names)
  colnames(metrics) <- col.names
  enriched <-
    CorrectAndSelect(metrics, correction)
  complete.output <- FromIDtoName(enriched, database, species)
  ordered.list <- complete.output[order(complete.output[7], decreasing = T),]
  rownames(ordered.list) <- 1:nrow(ordered.list)
  
  if (enrichment == "both") {
    plot.title = ggtitle("Top 10 over/underrepresented protein domains")
  } else if (enrichment == "over") {
    plot.title = ggtitle("Top 10 overrepresented protein domains")
  } else if (enrichment == "under") {
    plot.title = ggtitle("Top 10 underrepresented protein domains")
  }
  
  bar.plot <-
    ggplot(ordered.list[1:10, ], aes(
      x = reorder(ordered.list[1:10, 2],-log10(ordered.list[1:10, 7])),
      y = -log10(ordered.list[1:10, 7])
    )) +
    ggtitle("Top 10 over/underrepresented protein domains") +
    ylab("- log10 (adjusted p-value)") + xlab("") +
    geom_bar(stat = 'identity') +
    coord_flip()
  
  return(list("table" = complete.output, "graph" = bar.plot))
}

################################################################################

GetBackgroundGenes <-
  function (database = "pfam", species = "hsapiens") {
    # Get list of protein-coding genes and associated domains
    #
    # Args:
    #   database: (character) database for fetching domain IDs
    #   species: (character) species for querying biomaRt
    #
    # Returns:
    #   (dataframe) filtered background (unannotated genes)
    
    #    domain.start <- paste0(database, "_start")
    #    domain.end <- paste0(database, "_end")
    species.dataset <- paste0(species, "_gene_ensembl")
    ensembl <-
      useMart(biomart = "ensembl", dataset = species.dataset)
    if (database == "pfam" || database == "interpro") {
      queried.attributes <-
        c("ensembl_gene_id", database)
    } else {
      stop("Misspecified protein domain database !")
    }
    background.genes <-
      getBM(
        attributes = queried.attributes,
        filters = "biotype",
        values = "protein_coding",
        mart = ensembl
      )
    not.annotated <-
      which(background.genes[database] == "")                                   # TODO: find a way to generalize to all empty cases (NA, NULL)
    background.genes <- background.genes[-not.annotated,]
    
    return(background.genes)
  }

GenerateContingencyTables <-
  function (domain, gene.set, background) {
    # Compute a contingency table for a given domain
    #
    # Args:
    #   domain: (character) domain for which to compute the contingency table
    #   gene.set: (character) genes of interest without associated domain IDs
    #   background: (data.frame) background genes with associated domain IDs
    #
    # Returns:
    #   (dataframe) a contingency table
    
    nb.background <- length(background[, 1])
    nb.gene.set <-
      length(gene.set[, 1])
    domain.in.set <-
      length(which(gene.set[database] == domain))
    domain.in.background <-
      length(which(background[database] == domain))
    one.one <- domain.in.set
    one.two <- domain.in.background
    two.one <- nb.gene.set - domain.in.set
    two.two <- nb.background - domain.in.background
    contingency.table <-
      data.frame(rbind(c(one.one, one.two), c(two.one, two.two)))
    rownames(contingency.table)[1] <- domain
    return(contingency.table)
  }

RunTest <-
  function (contingency.table,
            test = "g-test",
            enrichment = "over") {
    success.in.sample <- contingency.table[1, 1]
    sample.size <- sum(contingency.table[, 1])
    success.in.population <- sum(contingency.table[1, ])
    alt <- "two.sided"
    if (enrichment == "over") {
      low.tail <- F
      alt <- "greater"
    } else if (enrichment == "under") {
      low.tail <- T
      alt <- "less"
    }
    if (test == "g-test") {
      test.results <- GTest(contingency.table)
      p.value <- test.results$p.value
    } else if (test == "chi-squared") {
      test.results <- chisq.test(contingency.table)
      p.value <- test.results$p.value
    } else if (test == "fisher") {
      test.results <-
        fisher.test(contingency.table,
                    conf.level = 1 - threshold,
                    alternative = alt)
      p.value <- test.results$p.value
    } else if (test == "hypergeometric") {
      failure.in.population <- sum(contingency.table[2, ])
      p.value <-
        phyper(
          success.in.sample,
          success.in.population,
          failure.in.population,
          sample.size,
          lower.tail = low.tail
        )
    } else if (test == "binomial") {
      succes.out.sample <- contingency.table[1, 2]
      out.sample.size <- sum(contingency.table[, 2])
      test.results <-
        binom.test(
          success.in.sample,
          sample.size,
          p = succes.out.sample / out.sample.size,
          conf.level = 1 - threshold,
          alternative = alt
        )
      p.value <- test.results$p.value
    } else {
      stop("Misspecified statistical test!")
    }
    jaccard.index <-
      success.in.sample / (sample.size + success.in.population - success.in.sample)
    metrics <-
      list(
        "ID" = rownames(contingency.table)[1],
        "gene count (set)" = contingency.table[1, 1],
        "gene count (background)" = contingency.table[1, 2],
        "jaccard" = jaccard.index,
        "p-value" = p.value
      )
    return(metrics)
  }

CorrectAndSelect <- function (metrics, correction) {
  metrics[, 6] <- p.adjust(metrics$`p-value`, method = correction)
  colnames(metrics)[6] <- "adjusted p-value"
  keep <- which(metrics$`adjusted p-value` < threshold)
  selected.terms <- metrics[keep, ]
  rownames(selected.terms) <- 1:nrow(selected.terms)
  
  return(selected.terms)
}

FromIDtoName <-
  function (enrichment.list,
            database = "pfam",
            species = "hsapiens") {
    ids <- as.character(enrichment.list$ID)
    if (database == "pfam") {
      correspondance <- data.frame(PFAMDE)
      rownames(correspondance) <- correspondance$ac
      new.col <- data.frame(correspondance[ids, 2])
      names(new.col) <- "pfam_description"
      complete.list <-
        data.frame(cbind(enrichment.list[1], new.col, enrichment.list[2:6]))
    } else if (database == "interpro") {
      species.dataset <- paste0(species, "_gene_ensembl")
      ensembl <-
        useMart(biomart = "ensembl", dataset = species.dataset)
      queried.attributes <-
        c("interpro", "interpro_short_description")
      correspondance <- getBM(
        attributes = queried.attributes,
        filters = "interpro",
        values = ids,
        mart = ensembl
      )
      rownames(correspondance) <- correspondance$interpro
      new.col <- data.frame(correspondance[ids, 2])
      names(new.col) <- "interpro_description"
      complete.list <-
        data.frame(cbind(enrichment.list[1], new.col, enrichment.list[2:6]))
    }
    
    return(complete.list)
  }
