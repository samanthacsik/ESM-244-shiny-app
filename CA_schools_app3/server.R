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
COUNTY_INCOME_DATA <- st_read("/Users/samanthacsik/Repositories/ESM-244-shiny-app/CA_schools_app3/COUNTY_INCOME_DATA_transform_latlong.shp")

# complete district data with enrollment by district (includes polygons and lat long)
DISTRICT_DATA <- st_read("/Users/samanthacsik/Repositories/ESM-244-shiny-app/CA_schools_app3/DISTRICT_DATA_LUNCH.shp")
#DISTRICT_DATA2 <- st_read("/Users/samanthacsik/Repositories/ESM-244-shiny-app/CA_schools_app3/DISTRICT_DATA.shp")

##############################
# Define server logic
##############################

shinyServer(function(input, output) {

  output$CA_Map <- renderLeaflet({
   
    # include map aspects here that won't need to be dynamic 
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>% #OpenStreetMap
      addPolygons(data = DISTRICT_DATA, fillOpacity = 0.05, weight = 1, color = "blue") %>% 
      addPolygons(data = COUNTY_INCOME_DATA, fillOpacity = 0.05, weight = 2.5, color = "black") %>% 
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
  proxy <- leafletProxy("CA_Map") 
  observe({
    
    # define
    # district_polygon <- subset(DISTRICT_DATA, DISTRICT_DATA$DISTRICT == input$district)
    # county_polygon <- subset(COUNTY_INCOME_DATA, COUNTY_INCOME_DATA$NAME == input$county)
    # dist_latitude <- district_polygon$Latitude
    # dist_longitude <- district_polygon$Longitude
    # county_latitude <- county_polygon$Latitude
    # county_longitude <- county_polygon$Longitude
    # enrollment <- district_polygon$total_enr
    # population <- county_polygon$Population
    # income <- county_polygon$MedFamilyIncome
    
    if(input$county!="") {}
      
    if(input$district!=""){
      
      # define
      # district_polygon <- subset(DISTRICT_DATA, DISTRICT_DATA$DISTRICT == input$district) 
      # county_polygon <- subset(COUNTY_INCOME_DATA, COUNTY_INCOME_DATA$NAME == input$county)
      # dist_latitude <- district_polygon$Latitude
      # dist_longitude <- district_polygon$Longitude
      # county_latitude <- county_polygon$Latitude
      # county_longitude <- county_polygon$Longitude
      # enrollment <- district_polygon$total_enr
      # lunches <- district_polygon$total_lunch
      # population <- county_polygon$Population
      # income <- county_polygon$MedFamilyIncome
      
      district_polygon <- subset(DISTRICT_DATA, DISTRICT_DATA$DISTRIC == input$district) #DISTRICT
      county_polygon <- subset(COUNTY_INCOME_DATA, COUNTY_INCOME_DATA$NAME == input$county)
      dist_latitude <- district_polygon$Latitud #Latitude
      dist_longitude <- district_polygon$Longitd #Longitude
      county_latitude <- county_polygon$Latitud #Latitude
      county_longitude <- county_polygon$Longitd #Longitude
      enrollment <- district_polygon$totl_nr #total_enr
      lunches <- district_polygon$totl_lnc #total_lunch
      population <- county_polygon$Popult #Population
      income <- county_polygon$MdFmlyI #MedFamilyIncome

      # remove any previously highlighted polygon
      proxy %>% clearGroup("highlighted_polygon")
      
      # center the view on the county polygon
      proxy %>% setView(lng = county_longitude, lat = county_latitude, zoom = 7)
      
      # add slightly thicker yellow polygon on top of the selected one
      proxy %>% addPolylines(stroke = TRUE, weight = 4, color="yellow", data = county_polygon, group = "highlighted_polygon")
      
      # output "you have selected county"
      output$something1 <- renderText(sprintf("You have selected: %s County", input$county))
      # output median family income
      output$something2 <- renderText(sprintf("Median Family Income (USD): %s", polygon$income))
      
      # center the view on the district polygon 
      proxy %>% setView(lng = dist_longitude, lat = dist_latitude, zoom = 7) 
      
      #add a slightly thicker red polygon on top of the selected one
      proxy %>% addPolylines(stroke = TRUE, weight = 4, color="red", data = district_polygon, group = "highlighted_polygon")
      
      # output "you have selected district"
      output$something_here <- renderText(sprintf("You have selected: %s School District", input$district))
      # output total enrollment
      output$something_else <- renderText(sprintf("Total Enrollment: %s", polygon$enrollment))
    }
    
  })
 })
