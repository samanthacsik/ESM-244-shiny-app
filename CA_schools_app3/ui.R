library(tidyverse)
library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("darkly"),
  
  # Application title
  titlePanel("Assessing the need for academic outreach initiatives across CA school districts"),
  
  # Add navbar 
  navbarPage("MENU",
        tabPanel("Instructions",
                 fluidRow(
                   column(6, "summary & data go here"),
                   column(6, "instructions go here"))
                 ),
        tabPanel("Population & Income",
                 fluidRow(
                   column(4, "outputs go here"),
                   column(8, "map goes here")
                 )),
        tabPanel("Enrollment by Race & Gender",
                 fluidRow(
                   column(5, "table here"),
                   column(5, "stacked column here")
                 )),
        tabPanel("College Preparedness Model")
        
  
  # # Sidebar with a slider input for number of bins 
  # sidebarLayout(
  #   sidebarPanel("our inputs will go here"),
  #   mainPanel("the results will go here")
  #   ) 
  )
))

