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
library(DT)

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
                   choices = list("GeneNCBI" = 1,
                               "Ensembl" = 2),
                   selected = 1),
      
      # Horizontal line ----
      tags$hr(),
      selectInput("db", "Species :", 
                choices=list("Human"="Human",
                             "Mouse"="Mouse", 
                             "Other"="Other extracted from BioMart"
                  )),
      tags$hr(),

      tabsetPanel(
        id = 'queue',
        tabPanel("Submitted jobs", DT::dataTableOutput("queue"))
      ),

     
        actionButton("goButton", "GO !")
      
    ),
   
      
      
      # Main panel for displaying outputs ----
      mainPanel(
        tabsetPanel(
          tabPanel("Whole Data Inspection",
                  
                   tags$hr(),
              
                  checkboxGroupInput("checkbox", "Output :",
                                     c("Volcano plot"="volcano",
                                       "MA plot"="MAplot")),
                  tags$hr(),
                  
                  div(style="display:inline-block",
                      sliderInput("FC", "log Fold-change:",
                                  min = 0, max = 10,
                                 value = 2, step = 1)
                  ),
                  
                  div(style="display:inline-block",
                     checkboxGroupInput("cbAdjust", "",
                                     c("Absolute value"="Absolute value"))
                  ),
          
                  tags$hr(),
                  sliderInput("p-value", "p-value:",
                              min = 0, max = 0.1,
                              value = 0.05, step = 0.01),
                  tags$hr(),
                  radioButtons("Am", "Adjustment method:",
                               choices = list("Bonferroni" = 1,
                                              "Benjamini-Hochberg" = 2
                               ), 
                               selected = 1),
                  actionButton("submitWDI", "Submit")
                  ),
          
          tabPanel("GO-Enrichment",
                   #textInput("database", label = h3("Database"), value = "Enter database..."),
                   #tags$hr(),
                   selectInput("db", "Database :", 
                               choices=list("GO"="GO",
                                            "autre"="autre banque ?"
                               )),
                   tags$hr(),
                   checkboxGroupInput("checkbox", "GO term ontology :",
                                      c("Molecular function"="F",
                                        "Cellular component"="C",
                                        "Biological process"="P")),
                   tags$hr(),
                   radioButtons("EA", "Enrichment algorithm :",
                                choices = list("SEA" = 1,
                                               "GSEA" = 2
                                              ), 
                                selected = 1),
                   tags$hr(),
                   radioButtons("methode", "Statistical methods :",
                                choices = list("X²-test" = 1,
                                               "Fisher's exact test" = 2,
                                               "Binomial test" = 3,
                                               "Hypergeometric test" = 4), 
                                selected = 1),
                   tags$hr(),
                   actionButton("submitGOE", "Submit")
                   
                   
                   ),
          tabPanel("Pathway",
                   selectInput("db", "Database :", 
                               choices=list("GO"="GO",
                                            "autre"="autre banque ?"
                               )),
                   tags$hr(),
                   radioButtons("EA", "Enrichment algorithm :",
                                choices = list("SEA" = 1,
                                               "GSEA" = 2
                                               ), 
                                selected = 1),
                   tags$hr(),
                   radioButtons("methode", "Statistical methods :",
                                choices = list("X²-test" = 1,
                                               "Fisher's exact test" = 2,
                                               "Binomial test" = 3,
                                               "Hypergeometric test" = 4), 
                                selected = 1),
                   tags$hr(),
                   actionButton("submitPathway", "Submit")
                   
                   
                   ),
          tabPanel("Protein domains",
                   #selectInput("db", "Database :", 
                   #           choices=list("GO"="GO",
                   #                          "autre"="autre banque ?"
                   #            )),
                   tags$hr(),
                   radioButtons("EA", "Enrichment algorithm :",
                                choices = list("SEA"=1,
                                "GSEA" = 2),
                                selected = 1),
                   tags$hr(),
                 
                   radioButtons("methode", "Statistical methods :",
                                choices = list("X²-test" = 1,
                                               "Fisher's exact test" = 2,
                                               "Binomial test" = 3,
                                               "Hypergeometric test" = 4), 
                                selected = 1),
                   actionButton("submitProtein", "Submit"),
                   tags$hr()
                   
                   )

          
        )
      )
    )
  )

  