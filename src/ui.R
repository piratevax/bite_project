#
# AppliShiny project
# run the application by clicking 'Run App' above.
#
# Author :
#   Sophia ACHAIBOU
#   Joris ARGENTIN
#   Xavier BUSSELL
#   Hatim EL JAZOULI



require(shiny)
require(shinythemes)
require(DT)
source("some_functions.R")
source("ora.R")

# Define UI for data upload app ----
ui <- fluidPage( 
  
  # App title ----
  titlePanel("Bioinformatics Interactive Toolbox for Enrichment analysis"),
  
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
      
      tags$hr(),
      
      
      # Input: Select ID gene source ----
      radioButtons("IDsource", "ID gene source",
                   choices = list("GeneNCBI" = "ncbi",
                                  "Ensembl" = "ensembl"),
                   
                   selected = "ncbi"),
      
      # Horizontal line ----
      tags$hr(),
      selectInput("db", "Species :",
                  #choices = getBiomartDataset()),
                  choices = list("hsapiens"="hsapiens",
                                 "mmusculus"="mmusculus")),
      
      tags$hr(),
      sliderInput("pvalue", "p-value:",
                  min = 0, max = 0.1,
                  value = 0.05, step = 0.01),
      
      tags$hr(),
      tabsetPanel(
        id = 'queue',
        tabPanel("Submitted jobs", DT::dataTableOutput("queue"))
      ),
      
      
      actionButton("goButton", "GO !"),
      
      actionButton("resetButton", "Reset"),
      
      singleton(
        tags$head(tags$script(src = "message-handler.js"))
      )
      
    ),
    
    
    
    # Main panel for displaying outputs ----
    mainPanel(
      tabsetPanel(
        tabPanel("Whole Data Inspection",
                 
                 tags$hr(),
                 
                 radioButtons("outputWDI", "Output:",
                              choices = list("Volcano plot" = "volcano",
                                             "MA plot" = "maplot",
                                             "Both" = "both")),
                 tags$hr(),
                 
                 div(style="display:inline-block",
                     sliderInput("lFC", "log Fold-change:",
                                 min = -10, max = 10,
                                 value = 0, step = 1)
                 ),
                 
                 div(style="display:inline-block",
                     checkboxInput("absoluteValue", "Absolute value", FALSE)
                 ),
                 
                 tags$hr(),
                 # radioButtons("Am", "Adjustment method:",
                 #              choices = list("Bonferroni" = "bonf",
                 #                             "Benjamini-Hochberg" = "benja"
                 #              ), 
                 #              selected = 1),
                 actionButton("submitWDI", "Submit"),
                 
                 tags$hr(),
                 plotOutput("plotVulcanoPlot"),
                 
                 tags$hr(),
                 plotOutput("plotMAPlot"),
                 
                 tags$hr(),
                 tabPanel("Raw data", DT::dataTableOutput("tableWDI"))
        ),
        
        tabPanel("GO-Enrichment",
                 #textInput("database", label = h3("Database"), value = "Enter database..."),
                 #tags$hr(),
                 # selectInput("dbGOE", "Database :", 
                 #             choices=list("GO"="GO",
                 #                          "autre"="autre banque ?"
                 #             )),
                 # tags$hr(),
                 radioButtons("checkboxGOE", "GO term ontology :",
                              choices = list(#"All"="all",
                                      "Molecular function"="MF",
                                      "Cellular component"="CC",
                                      "Biological process"="BP"),
                              selected = "MF"),
                 tags$hr(),
                 radioButtons("enrichmentAlgorithmGOE", "Enrichment algorithm :",
                              choices = list("SEA" = "sea",
                                             "GSEA" = "gsea"
                              ), 
                              selected = "sea"),
                 # tags$hr(),
                 # radioButtons("methodGOE", "Statistical methods :",
                 #              choices = list("chi-test" = "chi",
                 #                             "Fisher's exact test" = "fisher",
                 #                             "Binomial test" = "binom",
                 #                             "Hypergeometric test" = "hypergeo"), 
                 #              selected = "chi"),
                 tags$hr(),
                 radioButtons("AMGO", "Adjustment method:",
                              choices = list("Bonferroni" = "bonferroni",
                                             "Benjamini-Hochberg" = "BH"
                              ), 
                              selected = "BH"),
                 tags$hr(),
                 actionButton("submitGOE", "Submit"),
                 
                 tags$hr(),
                 tabPanel("Table GO", DT::dataTableOutput("tableGOE")),
                 
                 tags$hr(),
                 plotOutput("plotGO")
        ),
        
        
        tabPanel("Pathway",
                 # selectInput("dbPathway", "Database :", 
                 #             choices=list("GO"="GO",
                 #                          "autre"="autre banque ?"
                 #             )),
                 # tags$hr(),
                 radioButtons("enrichmentAlgorithmPathway", "Enrichment algorithm :",
                              choices = list("SEA" = "sea",
                                             "GSEA" = "gsea"
                              ), 
                              selected = "gsea"),
                 tags$hr(),
                 radioButtons("AMPathway", "Adjustment method:",
                              choices = list("Bonferroni" = "bonferroni",
                                             "Benjamini-Hochberg" = "BH"
                              ), 
                              selected = "BH"),
                 tags$hr(),
                 actionButton("submitPathway", "Submit"),
                 
                 tags$hr(),
                 tabPanel("Table Pathway", DT::dataTableOutput("tablePathway")),
                 
                 tags$hr(),
                 plotOutput("plotPathway")
        ),
        
        
        tabPanel("Protein domains",
                 selectInput("dbprotein", "Database :", 
                             choices=list("PFAM"="pfam",
                                          "Interpro"="interpro"
                             )),
                 # tags$hr(),
                 # radioButtons("enrichmentAlgorithmProtein", "Enrichment algorithm :",
                 #              choices = list("SEA"="sea",
                 #                             "GSEA" = "gsea"),
                 #              selected = "sea"),
                 tags$hr(),
                 
                 radioButtons("methodProtein", "Statistical methods :",
                              choices = list("chi-test" = "chi-squared",
                                             "Fisher's exact test" = "fisher",
                                             "Binomial test" = "binomial",
                                             "G-test" = "g-test",
                                             "Hypergeometric test" = "hypergeometric"), 
                              selected = "g-test"),
                 
                 tags$hr(),
                 radioButtons("AMprotein", "Adjustment method:",
                              choices = list("Bonferroni" = "bonferroni",
                                             "Benjamini-Hochberg" = "BH"
                               ), 
                              selected = "bonferroni"),
                 
                 tags$hr(),
                 radioButtons("updownProteinDomain", "Enrichment direction:",
                              choices = list("Up" = "over",
                                             "Down" = "under",
                                             "Both" = "both"),
                              selected = "over"),
                 actionButton("submitProtein", "Submit"),
                 
                 tags$hr(),
                 tabPanel("Table of Protein domain", DT::dataTableOutput("tableProtein")),
                 
                 tags$hr(),
                 plotOutput("plotProtein")
                 
        )
        
        
      )
    )
  )
)

