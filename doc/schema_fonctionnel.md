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
    9[GO term ontology]
    10[Enrichment algorithm]
    11[Statistical methods]
  end

  subgraph Pathway
    12[Enrichment algorithm]
    13[Statistical methods]
    14[Pathway list]
  end

  subgraph Domain
  end

  subgraph Dev
    A((readFile))
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
  end

  1-->A
  2-->A
  3-->b
  a-->4
  4-->b
  b-->c
  A-->c
  c-->e