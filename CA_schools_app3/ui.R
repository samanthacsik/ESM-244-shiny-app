# SAM

##############################
# install packages
##############################

library(tidyverse)
library(shiny)
library(shinythemes)
library(sf)
library(ggmap)

##############################
# load data
##############################

# complete district data with enrollment by district (includes polygons and lat long)
COUNTY_INCOME_DATA <- st_read("/Users/samanthacsik/Repositories/ESM-244-shiny-app/CA_schools_app3/COUNTY_INCOME_DATA_transform.shp")

# complete district data with enrollment by district (includes polygons and lat long)
DISTRICT_DATA <- st_read("/Users/samanthacsik/Repositories/ESM-244-shiny-app/CA_schools_app3/DISTRICT_DATA.shp")

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
                  sidebarLayout(
                    sidebarPanel(
                      # select counties widget
                      selectInput("county", "Select County", COUNTY_INCOME_DATA$NAME), 
                      # dataTableOutput(outputId = 'selectedCounty'),
                    
                      # select districts widget
                      selectInput("district", label = "Select District", DISTRICT_DATA$DISTRICT) # can remove inputID
                    ),
                    mainPanel(
                      textOutput("something_here"),
                      textOutput("something_else"),
                      # create output for map
                      leafletOutput("CA_Map", width = 600, height = 700)

                    )
                )),
         
         # panel 3 ()
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




