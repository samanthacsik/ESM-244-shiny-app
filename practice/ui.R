# AN

##############################
# install packages
##############################

library(tidyverse)
library(shiny)
library(shinythemes)
library(sf)

##############################
# load data
##############################

##############################
# build ui
##############################

# Define UI for application and choose theme
shinyUI(fluidPage(
  theme = shinytheme("flatly"),
  
  # Application title
  titlePanel("Assessing the need for academic outreach initiatives across California school districts"),
  
  # Add main panel
  mainPanel(
    tabsetPanel(
      
      # panel 1 (instructions)
      tabPanel("Instructions",
               h3("Academic outreach in California"),
               p("Academic outreach programs are often recognized as important initiatives for improving the rates of student retention (Quigley & Leon 2003) as well as increasing the percentage of students from underrepresented groups that advance through the academic pipeline (Cooper et al. 2002, Gullatt & Jan 2003, Loza 2003). The University of California's Student Academic Preparation and Educational Partnership (SAPEP) is just one example and comprises a variety of programs to prepare CA students for postsecondary education, including students from socioeconomically disadvantaged backgrounds. This application is intented to be used as a tool for outreach coordinators in CA to target districts that could effectively utilize additional or continued educational program support to advance the academic success of their students. We explore data on race and gender composition across CA school districts and develop a model for predicting college preparedness based on both currently available resources and socioeconomic variables."),
               h3("Data sources"),
               p("Data is made publically available by the California Department of Education"),
               tags$a(href = "https://www.cde.ca.gov/ds/dd/index.asp", "Click here to access data")
      ),
      
      # panel 2 (map of income and enrollment by district)
      tabPanel("Population, Income & Enrollment",
               fluidRow(
                 
               )),
      
      # panel 3 ()
      tabPanel("Enrollment by Race & Gender",
               fluidRow(
                 column(4, 
                        selectizeInput("county", 
                                       "Select County", 
                                       choices = unique(sc_en_tri$COUNTY)),
                        selectInput("district", "Select District", choices = ""),
                        selectInput("school", "Select School", choices = ""),
                        hr(),
                        fluidRow(column(3, verbatimTextOutput("value")))
                        ),
                 # column(5, htmlOutput("school_table"))
                 column(12, plotOutput("column_plot"))
               )
               ),
      
      # tab 4
      tabPanel("College Preparedness Model")
    )
    
    # # Sidebar with a slider input for number of bins 
    # sidebarLayout(
    #   sidebarPanel("our inputs will go here"),
    #   mainPanel("the results will go here")
    #   ) 
  )
))
