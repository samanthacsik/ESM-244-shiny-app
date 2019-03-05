# AN

##############################
# install packages
##############################

library(shiny)
library(tidyverse)

##############################
# load data
##############################



##############################
# Define server logic
##############################

shinyServer(function(input, output) {
  
  # output$result <- renderText({
  #    paste("You chose", input$state)
  #   })
  
  output$countySelection = renderDataTable({
    subset(ca_counties, NAME=input$county) # not sure it matters what you put in place of "ca_counties" here
    
  })
  
  
})
