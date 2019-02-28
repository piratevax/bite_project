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
  rv$null <- "Files must be loaded"
  
  file1 <- reactive({
    if (!is.null(input$file1)) {
      readFile(input$file1$datapath, header = input$header)
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
      rv$organismSelected <- organismSelected()
      if (is.null(rv$read)) {
        ### TODO : update n'apparait pas
        updateSelectInput(session, "file1", choices="Files must be loaded")
        if (DEBUG.var)
          cat("Files must be loaded\n")
      }
    })
})