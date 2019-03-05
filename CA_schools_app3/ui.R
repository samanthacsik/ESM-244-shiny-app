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

ca_counties <- read_csv("/Users/samanthacsik/Repositories/ESM-244-shiny-app/CA_schools_app3/ca_counties.csv") 
county_names <- setNames(ca_counties$NAME, ca_counties$NAME) # was ca_counties#county_name
district_enr <- st_read("/Users/samanthacsik/Repositories/ESM-244-shiny-app/CA_schools_app3/district_enr_spatial.shp")
district_names <- as.character(setNames(district_enr$DISTRICT, district_enr$DISTRICT)) 
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
         
         # panel 2 (map and income)
         tabPanel("Population, Income & Enrollment",
                  fluidRow(
                    
                    selectizeInput("county", "Select County", county_names),
                    dataTableOutput(outputId = 'selectedCounty'),
                    
                    selectizeInput("district", "Select District", district_names)

                    
                    # leafletOutput(outputID = "CA_Map")
                    
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




