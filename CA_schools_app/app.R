library(tidyverse)
library(shiny)
library(shinythemes)
library(leaflet)

# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = shinytheme("flatly"),
   
   # Application title
   titlePanel("Assessing the need for academic outreach initiatives across CA school districts "),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("bins",
                     "Number of bins:",
                     min = 1,
                     max = 50,
                     value = 30)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         tabsetPanel(
           type = "tab",
           tabPanel("Instructions",
                    leafletOutput("mymap",height = 1000)),
           tabPanel("Enrollment by Race & Gender"),
           tabPanel("College Preparedness Model"),
           tabPanel("Data Explorer")
         )
      )
   )
)

######################################################################
# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$mymap <- renderLeaflet({
    m <- leaflet() %>% # creates map widget
      addTiles() %>% # adds the default OpenStreet map tiles
      setView(lng=-73.935242, lat=40.730610 , zoom=10) # sets view to provided coordinates
    m
    
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

