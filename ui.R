#
# AppliShiny project
# run the application by clicking 'Run App' above.
#
# Author :
#   Sophia ACHAIBOU
#   Joris ARGENTIN
#   Xavier BUSSEL
#   Hatim EL JAZOULI



library(shiny)
library(shinythemes)

# Define UI for data upload app ----
ui <- fluidPage( 

  # App title ----
  titlePanel("Annotation Enrichment Analysis"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select a file ----
      fileInput("file1", "Choose CSV File",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      # Input: Checkbox if file has header ----
      checkboxInput("header", "Header", TRUE),
      
      tags$hr(),
      
      # Input: Select organism ----
      radioButtons("org", "Organism name :",
                   choices = list("BiomaRt" = 1,
                               "ClusterProfiler" = 2,
                               "Pathview" = 3 ), 
                   selected = 1),
                
      tags$hr(), 
      
      # Input: Select ID gene source ----
      radioButtons("IDsource", "ID gene source",
                   choices = list("GeneNCBI" = 1,
                               "Ensembl" = 2),
                   selected = 1),
      
      # Horizontal line ----
      tags$hr(),
      
      actionButton("goButton", "Go!")
    ),
   
      
      
      # Main panel for displaying outputs ----
      mainPanel(
        tabsetPanel(
          tabPanel("WDI",
                  
                   verbatimTextOutput("orgName"), #a retirer
                   radioButtons("EA", "Enrichment algorithm :",
                       choices = list("SEA" = 1,
                                      "GSEA" = 2,
                                      "MEA" = 3 ), 
                       selected = 1),
                  tags$hr(),
                  checkboxGroupInput("checkbox", "Output :",
                                     c("Vulcano plot"="vulcano",
                                       "MA plot"="MAplot")),
                  tags$hr(),
                  actionButton("submitWDI", "SUBMIT")
                  ),
          tabPanel("GOE",
                   #textInput("database", label = h3("Database"), value = "Enter database..."),
                   #tags$hr(),
                   selectInput("db", "Database :", 
                               choices=list("DAVID" = "david",
                                            "Gene Ontology" = "go",
                                            "KEGG" = "kegg",
                                            "MSigDB" = "msig",
                                            "PANTHER" = "pant",
                                            "Reactome" = "react",
                                            "RegulonDB" = "regul",
                                            "STRINGDB" = "string"
                               )),
                   tags$hr(),
                   checkboxGroupInput("checkbox", "GO term level :",
                                      c("Molecular function"="F",
                                        "Cellular component"="C",
                                        "Biological process"="P")),
                   tags$hr(),
                   radioButtons("EA", "Enrichment algorithm :",
                                choices = list("SEA" = 1,
                                               "GSEA" = 2,
                                               "MEA" = 3 ), 
                                selected = 1),
                   tags$hr(),
                   radioButtons("methode", "Statistical methods :",
                                choices = list("X²-test" = 1,
                                               "Fisher's exact test" = 2,
                                               "Binomial probability" = 3,
                                               "Hypergeometric test" = 4), 
                                selected = 1),
                   tags$hr(),
                   actionButton("submitGOE", "SUBMIT")
                   
                   
                   ),
          tabPanel("Pathway",
                   selectInput("db", "Database :", 
                               choices=list("DAVID" = "david",
                                            "Gene Ontology" = "go",
                                            "KEGG" = "kegg",
                                            "MSigDB" = "msig",
                                            "PANTHER" = "pant",
                                            "Reactome" = "react",
                                            "RegulonDB" = "regul",
                                            "STRINGDB" = "string"
                               )),
                   tags$hr(),
                   radioButtons("EA", "Enrichment algorithm :",
                                choices = list("SEA" = 1,
                                               "GSEA" = 2,
                                               "MEA" = 3 ), 
                                selected = 1),
                   tags$hr(),
                   radioButtons("methode", "Statistical methods :",
                                choices = list("X²-test" = 1,
                                               "Fisher's exact test" = 2,
                                               "Binomial probability" = 3,
                                               "Hypergeometric test" = 4), 
                                selected = 1),
                   tags$hr(),
                   actionButton("submitPathway", "SUBMIT")
                   
                   
                   ),
          tabPanel("Protein",
                   selectInput("db", "Database :", 
                               choices=list("DAVID" = "david",
                                            "Gene Ontology" = "go",
                                            "KEGG" = "kegg",
                                            "MSigDB" = "msig",
                                            "PANTHER" = "pant",
                                            "Reactome" = "react",
                                            "RegulonDB" = "regul",
                                            "STRINGDB" = "string"
                               )),
                   tags$hr(),
                   radioButtons("methode", "Statistical methods :",
                                choices = "SEA"),
                   tags$hr(),
                   actionButton("submitProtein", "SUBMIT")
                   
                   )
        )
      )
    )
  )

  