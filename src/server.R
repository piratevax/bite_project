#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#d  
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
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
  rv$wdi <- FALSE
  
  #### Sidebar #####
  file1 <- reactive({
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
  
  observeEvent(
    input$goButton, {
      rv$read <- file1()
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
      
      if (DEBUG.var)
        cat(paste("#D# rv$wdi: ", rv$wdi, "\n", sep = ""))
      if (rv$wdi) {
        if (rv$volcanoPlot) {
        output$plotVulcanoPlot <- renderPlot({
            generateVolcanoPlot(rv$read, alpha = rv$pvalue, l2FC = rv$l2FC)
          })
        }
        if (rv$MAPlot) {
        output$plotMAPlot <- renderPlot({
            generateMAPlot(rv$read, alpha = rv$pvalue, l2FC = rv$l2FC)
          })
        }
      }
      rv$queue <- NULL
      rv$queue.lastSize <- 0
      output$queue <- DT::renderDataTable({
        NULL
      })
    })
  
  
  #### Whole Data Inspection  ####
  absoluteValue <- reactive({
    input$absoluteValue
  })
  wdi.checkbox <- reactive({
    if (DEBUG.var)
      cat(paste("#D# -> wdi.checkbox: ", input$checkbox, "\n", sep =""))
    input$checkbox
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
  
  ### TODO : prendre en compte pval et lfc
  observeEvent(
    input$submitWDI, {
      rv$volcanoPlot <- FALSE
      rv$MAPlot <- FALSE
      rv$wdi <- TRUE
      rv$pvalue <- wdi.pvalue()
      rv$l2FC <- wdi.log2FoldChange()
      tmp <- wdi.checkbox()
      for (i in tmp) {
        if (i == "volcano") {
          rv$volcanoPlot <- TRUE
          rv$queue <- c(rv$queue, list("WDI", "Volcano plot"))
        }
        if (i == "MAplot") {
          rv$MAPlot <- TRUE
          rv$queue <- c(rv$queue, list("WDI", "MA-plot"))
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
})