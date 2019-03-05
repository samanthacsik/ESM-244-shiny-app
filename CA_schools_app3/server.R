# SAM

##############################
# install packages
##############################

library(shiny)
library(tidyverse)

##############################
# load data
##############################

ca_counties <- read_csv("/Users/samanthacsik/Repositories/ESM-244-shiny-app/CA_schools_app3/ca_counties.csv") 
county_names <- setNames(ca_counties$NAME, ca_counties$NAME) # was ca_counties#county_name
district_enr <- st_read("/Users/samanthacsik/Repositories/ESM-244-shiny-app/CA_schools_app3/district_enr_spatial.shp")
district_names <- as.character(setNames(district_enr$DISTRICT, district_enr$DISTRICT)) 

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
  
  # output$districtSelection = renderDataTable({
  #   subset(district_enr, DISTRICT=input$district)
  # })

  output$CA_Map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("OpenStreetMap") %>%
      addPolygons(data = district_enr, fillOpacity = 0.1, weight = 2) %>%
      addMarkers(lng = -119.4179,
                 lat = 36.7783,
                 popup = "You are here.",
                 options = markerOptions(draggable = TRUE, riseOnHover = TRUE)) %>%
      setView(lng = -119.4179,
              lat = 36.7783,
              zoom = 6)
  })

 

 })

