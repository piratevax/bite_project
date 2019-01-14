#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

function(input, output) {
  
  output$orgName <- renderPrint({
    ncount <- input$org
    paste(ncount)
  })
  #input$goButton

}
