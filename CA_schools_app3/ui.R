library(tidyverse)
library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("flatly"),
  
  # Application title
  titlePanel("Assessing the need for academic outreach initiatives across CA school districts"),
  
  # Add navbar 
  mainPanel(
    tabsetPanel(
        tabPanel("Instructions"),
        tabPanel("Population & Income",
                 fluidRow(
                   column(4, "outputs go here"),
                   column(8, "map goes here")
                 )),
        tabPanel("Enrollment by Race & Gender",
                 fluidRow(
                   column(2, "widgets here"),
                   column(5, "table here"),
                   column(5, "stacked column here")
                 )),
        tabPanel("College Preparedness Model")
    )
  
  # # Sidebar with a slider input for number of bins 
  # sidebarLayout(
  #   sidebarPanel("our inputs will go here"),
  #   mainPanel("the results will go here")
  #   ) 
  )
))

