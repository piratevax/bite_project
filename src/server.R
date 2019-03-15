#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#d  
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

require(shiny)
require(shinythemes)
require(org.Hs.eg.db)
require(clusterProfiler)
require(pathview)
source("some_functions.R")

shinyServer(function(session, input, output) {
  DEBUG.var = TRUE
  
  # output$orgName <- renderPrint({
  #   ncount <- input$org
  #   paste(ncount)
  # })
  #input$goButton
  rv <- reactiveValues()
  rv$null <- "File must be loaded"
  rv$queue <- NULL
  rv$queue.lastSize <- 0
  
  #### Sidebar #####
  file <- reactive({
    if (!is.null(input$file1)) {
      # validate(
      #   need(!is.null(input$file1), rv$null)
      # )
      if (DEBUG.var)
        cat(paste("#D# -> file: ", input$file1$datapath, "\n", sep = ""))
      ### TODO : ne pas avoir le header en dure
      readFile(input$file1$datapath, header = T)
    } else {
      NULL
    }
  })
  organismSelected <- reactive({
    input$db
  })
  idSource <- reactive({
    if (DEBUG.var)
      cat(paste("#D# -> ID source: ", input$IDsource, "\n", sep =""))
    input$IDsource
  })
  
  observeEvent(
    input$goButton, {
      rv$read <- file()
      if (DEBUG.var)
        cat(paste("#D# -> ", rv$read, "\n", sep = ""))
      rv$organismSelected <- organismSelected()
      if (DEBUG.var)
        cat(paste("#D# -> ", rv$organismSelected, "\n", sep = ""))
      if (is.null(rv$read)) {
        session$sendCustomMessage(type = 'testmessage',
                                  message = 'You have to select a file')
        if (DEBUG.var)
          cat(paste("#D# -> ", rv$null, "\n"), sep = "")
      }
      rv$organism <- organismSelected()
      if(DEBUG.var)
        cat(paste("#D# -> rv$organism", rv$organism, "\n"), sep = "")
      
      ### WDI
      if (DEBUG.var)
        cat(paste("#D# rv$wdi: ", rv$wdi, "\n", sep = ""))
      if (rv$wdi) {
        rv$absoluteValue <- absoluteValue()
        if (rv$volcanoPlot) {
          output$plotVulcanoPlot <- renderPlot({
            generateVolcanoPlot(rv$read, alpha = rv$pvalue, l2FC = rv$l2FC, absolute = rv$absoluteValue)
          })
        }
        if (rv$MAPlot) {
          output$plotMAPlot <- renderPlot({
            generateMAPlot(rv$read, alpha = rv$pvalue, l2FC = rv$l2FC, absolute = rv$absoluteValue)
          })
        }
      }
      output$tableWDI <- DT::renderDataTable({
        getSignificativeGene(rv$read, alpha = rv$pvalue, l2FC = rv$l2FC, absolute = rv$absoluteValue)
      })
      
      ### GOE
      if (DEBUG.var)
        cat(paste("#D# rv$goe: ", rv$goe, "\n", sep = ""))
      if (rv$goe) {
        if (DEBUG.var)
          cat(paste("#D# pval: ", typeof(rv$pvalue), "\n", sep = ""))
        if (DEBUG.var)
          cat(paste("#D# GOE ontology:\n\tall", rv$allGO, "\n\tMF: ", rv$MF, "\n\tCC: ", rv$CC, "\n\tBP: ", rv$BP, "\n", sep = ""))
        if (rv$checkboxGOE == "gsea") {
          if (rv$allGO) {
            rv$gseaGO <- gseaGO(getGeneListClusterProfiler(rv$read, organism = rv$organism),
                                rv$pvalue, adjustMethod = rv$AMGO, organism =  rv$organism)
          } else {
            if (rv$MF) {
              rv$gseaGO <- gseaGO(getGeneListClusterProfiler(rv$read, organism = rv$organism),
                                  rv$pvalue, adjustMethod = rv$AMGO, ont = "MF", organism = rv$organism)
            } else if (rv$CC) {
              rv$gseaGO <- gseaGO(getGeneListClusterProfiler(rv$read, organism = rv$organism),
                                  rv$pvalue, adjustMethod = rv$AMGO, ont = "CC", organism =rv$organism)
            } else if (rv$BP) {
              rv$gseaGO <- gseaGO(getGeneListClusterProfiler(rv$read, organism = rv$organism),
                                  rv$pvalue, adjustMethod = rv$AMGO, ont = "BP", organism = rv$organism)
            }
          }
        } else {
          if (rv$MF) {
            rv$gseaGO <- enrichmentGO(read = rv$read, alpha = rv$pvalue,
                                      ont = "MF", adjustMethod = rv$AMGO, organism = rv$organism)
          } else if (rv$CC) {
            rv$gseaGO <- enrichmentGO(read = rv$read, alpha = rv$pvalue,
                                      ont = "CC", adjustMethod = rv$AMGO, organism =rv$organism)
          } else if (rv$BP) {
            rv$gseaGO <- enrichmentGO(read = rv$read, alpha = rv$pvalue,
                                      ont = "BP", adjustMethod = rv$AMGO, organism = rv$organism)
          }
        }
        if (dim(rv$gesaGO )[1] > 0){
          output$tableGOE <- DT::renderDataTable({
            GOList(rv$gseaGO)
          })
          rv$plotGOE <- dotplot(rv$gseaGO)
          output$plotGO <- renderPlot({
            rv$plotGOE
          })
        }
      }
      
      ### Pathway
      if (rv$pathway) {
        
      }
      
      ### Protein domain
      if (rv$protein) {
         rv$proteinRes <- ORA(
           gene.set = rv$read$ID,
           database = rv$dbprotein,
           species = rv$organism,
           test = rv$statisticalMethod,
           threshold = rv$pvalue,
           enrichment = rv$updownProteinDomain,
           correction = rv$AMprotein
         )
         output$tableProtein <- DT::renderDataTable({
           rv$proteinRes[["table"]]
         })
         output$plotProtein <- renderPlot({
           rv$proteinRes[["graph"]]
         })
      }
      
      ### Epuisement de la queue
      rv$queue <- NULL
      rv$queue.lastSize <- 0
      output$queue <- DT::renderDataTable({
        NULL
      })
    })
  
  
  #### Whole Data Inspection  ####
  rv$wdi <- FALSE
  absoluteValue <- reactive({
    input$absoluteValue
  })
  wdi.radiobutton <- reactive({
    if (DEBUG.var)
      cat(paste("#D# -> wdi.radiobutton: ", input$outputWDI, "\n", sep =""))
    input$outputWDI
  })
  

  wdi.log2FoldChange <- reactive({
    input$lFC
  })
  wdi.pvalue <- reactive({
    input$pvalue
  })
  
  observe({
    rv$absolute <- absoluteValue()
    if (rv$absolute)
      updateSliderInput(session, "lFC", min = 0)
    else
      updateSliderInput(session, "lFC", min = -10)
  })
  
  observeEvent(
    input$submitWDI, {
      rv$volcanoPlot <- FALSE
      rv$MAPlot <- FALSE
      rv$wdi <- TRUE
      rv$pvalue <- wdi.pvalue()
      rv$l2FC <- wdi.log2FoldChange()
      tmp <- wdi.radiobutton()
      for (i in tmp) {
        if (i == "volcano") {
          rv$volcanoPlot <- TRUE
          rv$queue <- c(rv$queue, list("WDI", "Volcano plot"))
        }
        if (i == "MAplot") {
          rv$MAPlot <- TRUE
          rv$queue <- c(rv$queue, list("WDI", "MA-plot"))
        }
        if (i == "both") {
          rv$MAPlot <- TRUE
          rv$queue <- c(rv$queue, list("WDI", "MA-plot"))
          rv$volcanoPlot <- TRUE
          rv$queue <- c(rv$queue, list("WDI", "Volcano plot"))
        }
      }
      if (DEBUG.var)
        cat(paste("#D# volcano plot: ", rv$volcanoPlot, "\n", "#D# MA-plot: ", rv$MAPlot, "\n", sep = ""))
      tmp <- length(rv$queue) / 2
      if (tmp != rv$queue.lastSize) {
        rv$queue.lastSize <- tmp
        output$queue <- DT::renderDataTable({
          `colnames<-`(matrix(cbind(rv$queue), ncol = 2, byrow = T), c("tab", "job"))
        })
      }
    })
  
  
  #### GO-enrichment ####
  rv$goe <- FALSE
  goe.db <- reactive({
    input$dbGOE
  })
  goe.checkbox <- reactive({
    input$checkboxGOE
  })
  goe.enrichmentAnalysis <- reactive({
    input$enrichmentAlgorithmGOE
  })
  goe.statisticalMethod <- reactive({
    input$methodGOE
  })
  goe.adjustMethod <- reactive({
    input$AMGO
  })
  
  observe({
    rv$statisticalMethod <- goe.enrichmentAnalysis()
    cat(paste("#D# obs: ", rv$statisticalMethod, "\n", sep = ""))
    if (rv$statisticalMethod == "gsea")
      updateRadioButtons(session, "checkboxGOE",
                         choices = list("All"="all",
                                        "Molecular function"="MF",
                                        "Cellular component"="CC",
                                        "Biological process"="BP"),
                         selected = "all")
    else
      updateRadioButtons(session, "checkboxGOE",
                         choices = list(#"All"="all",
                                        "Molecular function"="MF",
                                        "Cellular component"="CC",
                                        "Biological process"="BP"),
                         selected = "MF")
  })
  
  observeEvent(
    input$submitGOE, {
      rv$goe <- TRUE
      rv$MF <- FALSE
      rv$CC <- FALSE
      rv$BP <- FALSE
      rv$allGO <- FALSE
      rv$checkboxGOE <- goe.enrichmentAnalysis()
      rv$statisticalMethod <- goe.enrichmentAnalysis()
      rv$AMGO <- goe.adjustMethod()
      
      tmp <- goe.checkbox()
      if (tmp == "all") {
        rv$allGO <- TRUE
        rv$queue <- c(rv$queue, list("GOE", "all"))
      } else if (tmp == "MF") {
        rv$MF <- TRUE
        rv$queue <- c(rv$queue, list("GOE", "MF"))
      } else if (tmp == "CC") {
        rv$CC <- TRUE
        rv$queue <- c(rv$queue, list("GOE", "CC"))
      } else if (tmp == "BP") {
        rv$BP <- TRUE
        rv$queue <- c(rv$queue, list("GOE", "BP"))
      }
      # if (rv$MF && rv$CC && rv$BP) rv$allGO = TRUE
      # if (rv$allGO) {
      #   rv$queue <- c(rv$queue, list("GOE", "all"))
      # } else {
      #   if (rv$MF) rv$queue <- c(rv$queue, list("GOE", "MF"))
      #   if (rv$CC) rv$queue <- c(rv$queue, list("GOE", "CC"))
      #   if (rv$BP) rv$queue <- c(rv$queue, list("GOE", "BP"))
      # }
      tmp <- length(rv$queue) / 2
      if (tmp != rv$queue.lastSize) {
        rv$queue.lastSize <- tmp
        output$queue <- DT::renderDataTable({
          `colnames<-`(matrix(cbind(rv$queue), ncol = 2, byrow = T), c("tab", "job"))
        })
      }
    }
  )
  
  #### Pathway ####
  rv$pathway <- FALSE
  pathway.db <- reactive({
    input$dbPathway
  })
  pathway.enrichmentAnalysis <- reactive({
    input$enrichmentAlgorithmPathway
  })
  pathway.statisticalMethod <- reactive({
    input$methodPathway
  })
  
  observeEvent(
    input$submitProtein, {
      rv$pathway = TRUE
      
      tmp <- length(rv$queue) / 2
      if (tmp != rv$queue.lastSize) {
        rv$queue.lastSize <- tmp
        output$queue <- DT::renderDataTable({
          `colnames<-`(matrix(cbind(rv$queue), ncol = 2, byrow = T), c("tab", "job"))
        })
      }
    }
  )
  
  #### Protein Domain ####
  rv$protein <- FALSE
  protein.dbprotein <- reactive({
    input$dbprotein
  })
  protein.enrichmentAlgorithmProtein <- reactive({
    input$enrichmentAlgorithmProtein
  })
  protein.statisticalMethod <- reactive({
    input$methodProtein
  })
  protein.updownProteinDomain <- reactive({
    input$updownProteinDomain
  })
  protein.AMprotein <- reactive({
    input$AMprotein
  })
  
  observeEvent(
    input$submitProtein, {
      rv$protein <- TRUE
      rv$dbprotein <- protein.dbprotein()
      rv$enrichmentAlgorithmProtein <- protein.enrichmentAlgorithmProtein()
      rv$statisticalMethod <- protein.methodProtein()
      rv$updownProteinDomain <- protein.updownProteinDomain()
      rv$AMprotein <- protein.AMprotein()
      
      rv$queue <- c(rv$queue, list("Prot", rv$enrichmentAlgorithmProtein))      
      
      tmp <- length(rv$queue) / 2
      if (tmp != rv$queue.lastSize) {
        rv$queue.lastSize <- tmp
        output$queue <- DT::renderDataTable({
          `colnames<-`(matrix(cbind(rv$queue), ncol = 2, byrow = T), c("tab", "job"))
        })
      }
    }
  )
})