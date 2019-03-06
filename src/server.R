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
  
  file1 <- reactive({
    if (!is.null(input$file1)) {
      # validate(
      #   need(!is.null(input$file1), rv$null)
      # )
      if (DEBUG.var)
        cat(paste("#D# -> file:", input$file1$datapath, "\n", sep = " "))
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
        cat(paste("#D# ->", rv$read, "\n"), sep = " ")
      rv$organismSelected <- organismSelected()
      if (DEBUG.var)
        cat(paste("#D# ->", rv$organismSelected, "\n"), sep = " ")
      if (is.null(rv$read)) {
        session$sendCustomMessage(type = 'testmessage',
                                  message = 'You have to select a file')
        if (DEBUG.var)
          cat(paste("#D# ->", rv$null, "\n"), sep = " ")
      }
    })
})