library(DOSE)
data(geneList)
de <- names(geneList)[abs(geneList) > 2]

# over representation analysis
edo <- enrichDGN(de)

# gene set enrichment analysis
edo2 <- gseNCG(geneList, nPerm=10000)

# barplot
barplot(edo, showCategory=20)

# dotplot
p1 <- dotplot(edo, showCategory=30) + ggtitle("dotplot for ORA")
p2 <- dotplot(edo2, showCategory=30) + ggtitle("dotplot for GSEA")
plot_grid(p1, p2, ncol=2)

N <- as.numeric(sub("\\d+/", "", edo[1, "BgRatio"]))
N

dotplot(edo, showCategory=15, x = ~Count/N) + ggplot2::xlab("Rich Factor")

# convert gene id to symbol
## convert gene ID to Symbol
edox <- setReadable(edo, 'org.Hs.eg.db', 'ENTREZID')
cnetplot(edox, foldChange=geneList)
cnetplot(edox, foldChange=geneList, circular = TRUE, colorEdge = TRUE)

# upsetplot
upsetplot(edo)

# enrichment plot
emapplot(edo)
