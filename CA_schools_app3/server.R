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
COUNTY_INCOME_DATA <- st_read("/Users/samanthacsik/Repositories/ESM-244-shiny-app/CA_schools_app3/COUNTY_INCOME_DATA.shp")

# complete district data with enrollment by district (includes polygons and lat long)
DISTRICT_DATA <- st_read("/Users/samanthacsik/Repositories/ESM-244-shiny-app/CA_schools_app3/DISTRICT_DATA.shp")
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
  
  # interact with data
  proxy <- leafletProxy("CA_Map") 
  observe({
    if(input$county!="") {
      county_polygon <- subset(COUNTY_INCOME_DATA, COUNTY_INCOME_DATA$NAME == input$county)
      county_latitude <- county_polygon$Latitud
      county_longitude <- county_polygon$Longitd
      county_population <- county_polygon$Popultn
      county_income <- county_polygon$MdFmlyI
      
      # print("----- County info------------")
      # print(sprintf("lat: %s", county_latitude))
      # print(sprintf("long: %s", county_longitude))
      # print(sprintf("pop: %s", county_population))
      # print(sprintf("inc: %s", county_income))
      
      # ------ Map Stuff -----
      # remove any previously highlighted polygon
      proxy %>% clearGroup("highlighted_county_polygon")
      
      # center the view on the county polygon
      proxy %>% setView(lng = county_longitude, lat = county_latitude, zoom = 7)
      
      # add slightly thicker yellow polygon on top of the selected one
      proxy %>% addPolylines(stroke = TRUE, weight = 4, color="yellow", data = county_polygon, group = "highlighted_county_polygon")
      
      # output "you have selected county"
      output$selected_county <- renderText(sprintf("You have selected: %s County", input$county))
      # output median family income
      output$county_income <- renderText(sprintf("Median Family Income (USD): %s", county_income))
    }
  })
  observe({
    if(input$district!=""){
      # get all the district information
      district_polygon <- subset(DISTRICT_DATA, DISTRICT_DATA$DISTRIC == input$district) 
      district_latitude <- district_polygon$Latitud
      district_longitude <- district_polygon$Longitd
      district_enrollment <- district_polygon$totl_nr
      district_lunches <- district_polygon$prc_lnc
      district_requirement <- district_polygon$prc_rqr

      # print("----- District shit------------")
      # print(sprintf("lat: %s", district_latitude))
      # print(sprintf("long: %s", district_longitude))
      # print(sprintf("enr: %s", district_enrollment))
      # print(sprintf("lunches: %s", district_lunches))
      # print(sprintf("req: %s", district_requirement))
      
      # ------ Map Stuff -----
      # remove any previously highlighted polygon
      proxy %>% clearGroup("highlighted_district_polygon") 
      # center the view on the county polygon
      proxy %>% setView(lng = district_longitude, lat = district_latitude, zoom = 7)
      # add a slightly thicker red polygon on top of the selected one
      proxy %>% addPolylines(stroke = TRUE, weight = 4, color="red", data = district_polygon, group = "highlighted_district_polygon")
      # output "you have selected district"
      output$selected_district <- renderText(sprintf("You have selected: %s School District", input$district))
      # output total enrollment
      output$district_enrollment <- renderText(sprintf("Total Enrollment: %s", district_enrollment))
    }
  })
 })
