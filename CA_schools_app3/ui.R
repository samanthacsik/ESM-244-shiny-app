# SAM

##############################
# install packages
##############################

library(tidyverse)
library(shiny)
library(shinythemes)
library(sf)
library(leaflet)

##############################
# load data
##############################

# complete district data with enrollment by district (includes polygons and lat long)
COUNTY_INCOME_DATA <- st_read("/Users/samanthacsik/Repositories/ESM-244-shiny-app/CA_schools_app3/COUNTY_INCOME_DATA.shp")

# complete district data with enrollment by district (includes polygons and lat long)
DISTRICT_DATA <- st_read("/Users/samanthacsik/Repositories/ESM-244-shiny-app/CA_schools_app3/DISTRICT_DATA.shp")

##############################
# build ui
##############################

 # Define UI for application and choose theme
 shinyUI(fluidPage(
   theme = shinytheme("flatly"),

   tags$head(
     tags$link(rel = "stylesheet", type = "text/css", href = "my_app.css")
   ),
   
   # Application title
   titlePanel("Assessing the need for academic outreach initiatives across California school districts"),
   
   tabsetPanel(
         # panel 1 (instructions)
         tabPanel("Instructions",
           mainPanel(
             h3("Academic outreach in California"),
             p("Academic outreach programs are often recognized as important initiatives for improving the rates of student retention (Quigley & Leon 2003) as well as increasing the percentage of students from underrepresented groups that advance through the academic pipeline (Cooper et al. 2002, Gullatt & Jan 2003, Loza 2003). The University of California's Student Academic Preparation and Educational Partnership (SAPEP) is just one example and comprises a variety of programs to prepare CA students for postsecondary education, including students from socioeconomically disadvantaged backgrounds."),
	     p("This application is intented to be used as a tool for outreach coordinators in CA to target districts that could effectively utilize additional or continued educational program support to advance the academic success of their students. We explore data on race and gender composition across CA school districts and develop a model for predicting college preparedness based on both currently available resources and socioeconomic variables."),
	     h3("Data sources"),
	     p("Education data is made publically available by the California Department of Education (CA DoE). Original data can be accessed using the links below:"),
	     tags$a(href = "https://www.cde.ca.gov/ds/sd/sd/filesenr.asp", "Enrollment by School"),
	     br(),
	     tags$a(href = "https://www.cde.ca.gov/ds/sd/sd/filessp.asp", "Free or Reduced Meal Program"),
	     br(),
	     tags$a(href = "https://www.cde.ca.gov/ds/sd/sd/filesgradaf.asp", "Graduates Meeting UC/CSU Requirements"),
	     br(),
	     p("Income data is from I have no clue..."),
	     p("Spatial data is available from CA.gov and the United States Census Bureau."),
	     tags$a(href = "https://data.ca.gov/dataset/ca-geographic-boundaries", "CA County Boundaries"),
	     br(),
	     tags$a(href = "https://www.census.gov/geo/maps-data/data/cbf/cbf_sd.html", "CA District Boundaries (Elementary, Secondary & Unified School Districts)"),
	     h3("Academic resources"),
	     p("Cooper. Catherine R., Cooper, Jr., Robert G., Azmitia, Margarita, Chavira, Gabriela, Gullatt, Yvette (2002) Bridging multiple worlds: How African Americans and Latino youth in academic outreach programs navigate math pathways to college.",
	       em("Applied Developmental Science. 6:73-87.")),
	     p("Gullatt, Yvette (2003) How do pre-collegiate acadmic outreach programs impact college-going among underrepresented students?",
	       em("Pathways to College Network.")),
	     p("Loza, Pete P. (2003) A system at risk: College outreach programs and the educational neglect of underachieving latino high school students.",
	       em("The Urban Review. 35:43-57.")),
	     p("Quigley, Denise D. & Leon, Seth. (2003) The early academic outreach program (EAOP) and its impact on high school students' completion of the University of California's prepatory coursework.",
	       em("CSE Tech Report 589."))
	     )
         ),
         
         # panel 2 (map of income and enrollment by district)
         tabPanel("Population, Income & District Statistics",
                  sidebarLayout(
                    sidebarPanel(
                      
                      # display text about selectInputs
                      helpText("Select a county to highlight the location and display median family income."),
                      
                      # select counties widget # https://shiny.rstudio.com/reference/shiny/1.2.0/selectInput.html
                      #selectizeInput("county", label = "Select County", c("", COUNTY_INCOME_DATA$NAME), COUNTY_INCOME_DATA$NAME), 
                      selectInput("county", label = "Select County", COUNTY_INCOME_DATA$NAME),
                      
                      # display text about district selectInputs
                      helpText("Select a district to highlight the location and display total student enrollment and number of students in the Free and Reduced Lunch Program."),
                      
                      # select districts widget
                      #selectizeInput("district", label = "Select District", c("", DISTRICT_DATA$NAME), DISTRICT_DATA$NAME),
                      selectInput("district", label = "Select District", DISTRICT_DATA$DISTRIC)
                    ),
                    
                    # create main panel for map to poplate
                    mainPanel(
                      column(8,
                      
                        p("Select different California counties and districts to learn more about median family income and student enrollment throughout the state."),
                        
                        p("*Note: Some information may be missing. If a county or district is not highlighted upon selection, spatial data is not currently available."),
                        
                        # create output for map
                        leafletOutput("CA_Map", width = 600, height = 700)
                      ),

                      column(4,
                        tags$div(class="right-section",
                          # you selected ___ county
                          textOutput("selected_county"),
                        
                          # county population
                          textOutput("county_population"),
                        
                          # county median family income
                          textOutput("county_income")
                        ),

                        tags$div(class="right-section",
                          # you selected ___ district
                          textOutput("selected_district"),
                        
                          # total enrollment
                          textOutput("district_enrollment"),
                        
                          # percentage FRMP
                          textOutput("district_lunches"),
                        
                         # percentage meeting UC requirements
                          textOutput("district_requirement")
                        )
                      )
                    )
                  )),
         
         # panel 3 (table and barplot of enrollment broken down by race and gender)
         tabPanel("Enrollment by Race & Gender",
                  fluidRow(
                    column(2, "widgets here"),
                    column(5, "table here"),
                    column(5, "stacked column here")
                  ))
     
     )
   
   # # Sidebar with a slider input for number of bins 
   # sidebarLayout(
   #   sidebarPanel("our inputs will go here"),
   #   mainPanel("the results will go here")
   #   ) 
 ))
