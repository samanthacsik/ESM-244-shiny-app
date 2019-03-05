library(shiny)
ca_counties <- read_csv("ca_counties.csv")


# # Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # output$result <- renderText({
  #    paste("You chose", input$state)
  #   })
  
  output$countySelection = renderDataTable({
    subset(ca_counties, NAME=input$county)
    
    
  })


 })

