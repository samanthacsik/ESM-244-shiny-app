# SAM

##############################
# install packages
##############################

library(shiny)
library(tidyverse)

##############################
# load data
##############################
# complete district data with enrollment by district (includes polygons and lat long)
COUNTY_INCOME_DATA <- st_read("/Users/samanthacsik/Repositories/ESM-244-shiny-app/CA_schools_app3/COUNTY_INCOME_DATA_transform.shp")

# complete district data with enrollment by district (includes polygons and lat long)
DISTRICT_DATA <- st_read("/Users/samanthacsik/Repositories/ESM-244-shiny-app/CA_schools_app3/DISTRICT_DATA.shp")

##############################
# Define server logic
##############################

shinyServer(function(input, output) {

  # output$result <- renderText({
  #    paste("You chose", input$state)
  #   })
  
  # output$countySelection = renderDataTable({
  #   subset(ca_counties, NAME=input$county) # not sure it matters what you put in place of "ca_counties" here
  #   
  # })
  
  # output$districtSelection = renderDataTable({
  #   subset(district_enr, DISTRICT=input$district)
  # })
  
# add data to map
 # filteredData <- reactive({
 #    DISTRICT_DATA[DISTRICT_DATA$total_enr = input$district]
 # })

  output$CA_Map <- renderLeaflet({
   
    # include map aspects here that won't need to be dynamic o
    leaflet() %>%
      addProviderTiles("OpenStreetMap") %>%
      addPolygons(data = DISTRICT_DATA, fillOpacity = 0.05, weight = 1) %>% # district_enr
      addPolygons(data = COUNTY_INCOME_DATA, fillOpacity = 0.05, weight = 3, color = "black") %>% 
      # addFeatures(data = district_enr) %>%
      # addMarkers(lng = -119.4179,
      #            lat = 36.7783,
      #            popup = "You are here.",
      #            options = markerOptions(draggable = TRUE, riseOnHover = TRUE)) %>%
      setView(lng = -119.4179,
              lat = 36.7783,
              zoom = 6)
  })
  # interact with county data
  # proxy1 <- leafletProxy("CA_Map")
  # observe({
  #   if(input$county != ""){
  #     
  #     # get the selected county polygon
  #     polygon <- subset(ca_counties, ca_counties$NAMELSAD == input$county)
  #     
  #     # remove any previously highlighted polygon
  #     proxy1 %>% clearGroup("highlighted_polygon")
  #   }
  # })
  
  # interact with district data
  ca_dist <- leafletProxy("CA_Map") 
  observe({
    if(input$district!=""){
      
      #get the selected district polygon and extract the label point 
      polygon <- subset(DISTRICT_DATA, DISTRICT_DATA$DISTRICT == input$district)
      county_polygon <- subset(COUNTY_INCOME_DATA, COUNTY_INCOME_DATA$NAME == input$county)
      latitude <- polygon$Latitude
      longitude <- polygon$Longitude
      enrollment <- polygon$total_enr

      # remove any previously highlighted polygon
      ca_dist %>% clearGroup("highlighted_polygon")
      
      # center the view on the polygon 
      ca_dist %>% setView(lng = longitude, lat = latitude, zoom = 7) #%>% 
        # addMarkers(lng = longitude,
        #          lat = latitude,
        #         popup = input$district,
        #          options = markerOptions(riseOnHover = TRUE)) # %>%
        # removeMarker(lng = longitude,
        #              lat = latitude)
      
      #add a slightly thicker red polygon on top of the selected one
      ca_dist %>% addPolylines(stroke = TRUE, weight = 4, color="red", data = polygon, group = "highlighted_polygon")
      output$something_here <- renderText(sprintf("You have selected: %s", input$district))
      output$something_else <- renderText(sprintf("Total Enrollment: %s", polygon$total_enr))
      
      ca_dist %>% addPolylines(stroke = TRUE, weight = 4, color="yellow", data = county_polygon, group = "highlighted_polygon")
      }
  })
 })
