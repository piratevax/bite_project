graph LR
  subgraph GUI Parameters
    1[choose file]
    2[header]
    3[ID source]
    4[organism list]
  end

  subgraph Whole Data Inspection
    5[cursor p-adj]
    6[cursor FC]
    7[plot]
    8[data tab]
  end

  subgraph Gene Ontology
    9[GO terms ontology]
    15[GO level]
    10[Enrichment algorithm]
    11[Statistical methods]
    16[Results]
  end

  subgraph Pathway
    12[Enrichment algorithm]
    13[Statistical methods]
    14[Pathway list]
  end

  subgraph Protein Domain
    17[Enrichment algorithm]
    18[Statistical methods]
    19[Domain list]
  end

  subgraph Dev
    A((readFile))
    B((extractGeneID))
  end

  subgraph Biomarts
    a((listDatasets))
    b((useDataset))
    c((getBM<br>getGene<br>getSequence))
    d((exportFASTA))
  end

  subgraph ClusterProfiler
    e((bitr))
    f((groupGO))
    g((enrichGO))
    h((gseGO))
    i((dropGO))
    j((gofilter))

    k((search_kegg_organism))
    l((enrichKEGG))
    m((gseKEGG))
  end

  go{Gene<br>Ontology}
  pd{Protein<br>Domain}

  1-->A
  2-->A
  A-->B

  3-->b
  a-->4
  k-->4
  4-->b
  b-->c
  B-->c
  c-->e

  B-->e
  B-->h
  9-->e
  15-->e
  e-->f
  e-->g
  i-->g
  j-->g
  10-->go
  11-->go
  go-->h
  f-->16
  h-->16
  g-->16

  B-->l
  B-->m
  17-->pd
  18-->pd
  pd-->m
  l-->19
  m-->19
