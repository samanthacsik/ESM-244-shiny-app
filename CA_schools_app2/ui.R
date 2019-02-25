library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("flatly"),
  
  # Application title
  titlePanel("Assessing the need for academic outreach initiatives across CA school districts"),
  
  # create navbar
  navbarPage("Application Components",
             tabPanel("Instructions"),
             tabPanel("Enrollment by Race & Gender",
                sidebarLayout(
                  sidebarPanel(
                    selectInput("select", label = h3("Select Box"),
                                choices = list("Choice 1" = 1, "Choice 2 = 2", "Choice 3" = 3),
                                selected = 1),
                    hr(),
                    fluidRow(column(3, verbatimTextOutput("value")))
                  )
                )),
             tabPanel("College Preparedness Model")
  )
    
))



