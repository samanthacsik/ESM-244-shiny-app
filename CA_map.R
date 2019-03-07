#############################
# load libraries
##############################

library(tidyverse)
library(sf)
library(leaflet)
library(tmap)

##############################
# plot & color code by income using sf
##############################
# use geom_sf to make a map in ggplot

# ca_income <- ggplot(ca_df) +
#   geom_sf(aes(fill = MedFamilyIncome))
# 
# ca_income
# 
# ca_df_transform <- st_transform(ca_df, crs = 4326)
# 
# leaflet(ca_df_transform) %>% 
#   addTiles() %>% 
#   addPolygons()

##############################
# CA counties & med income using spatial data (data from lab 1)
##############################

# ca_counties <- st_read(dsn = ".", layer = "CA_Counties_TIGER2016") %>%  # "." means we're already in our wd; layer = "first common string name of each file used"
#   arrange(NAME)

# write_csv(ca_counties, "ca_counties.csv")

# view county data in easy plot
# ca_land <- ca_counties %>% 
#   dplyr::select(NAME, ALAND)
# 
# # Read pop/income data, then make sure county names column matches
# ca_pop_inc <- read_csv("ca_pop_inc.csv") %>% 
#   rename(NAME = COUNTY)
  #select(NAME)

# Join the two: 
# ca_df <- full_join(ca_land, ca_pop_inc) %>% 
#   dplyr::select(NAME, MedFamilyIncome)
# 
# # Make a map: 
# ca_income <- ggplot(ca_df) +
#   geom_sf(aes(fill = MedFamilyIncome), color = "white", size = 0.2) +
#   scale_fill_gradientn(colors = c("blue","mediumorchid1","orange")) +
#   theme_minimal()

##############################
# Load county spatial data & transform crs
##############################

# https://data.ca.gov/dataset/ca-geographic-boundaries (county data)
ca_counties <- st_read(dsn = ".", layer = "CA_Counties_TIGER2016") %>%
  arrange(NAME)

# set crs to 4326 for county data
ca_counties_transform <- st_transform(ca_counties, crs = 4326) 

##############################
# Load lat long data for counties
##############################

# import county lat long data
county_latlong <- read_csv("county_latlong.csv") 

# join county geometry data with lat long data
# ca_counties_latlong <- full_join(ca_counties_transform, county_latlong) %>% 
#   st_transform(crs = 4326)
 
##############################
# Load income by county data
##############################

# # median income data
ca_pop_inc <- read_csv("ca_pop_inc.csv") %>%
  rename(NAME = COUNTY) %>%
  select(NAME, Population, MedFamilyIncome)

##############################
# Join income and latlong data (no geometries yet)
##############################

# join population and income data with latlong data
ca_pop_inc_latlong <- full_join(ca_pop_inc, county_latlong)

##############################
# Join income/latlong data with county spatial data -- FINAL DATA SET TO USE IN SHINY
##############################

COUNTY_INCOME_DATA <- full_join(ca_counties, ca_pop_inc_latlong) %>% 
  st_transform(crs = 4326)

#st_write(COUNTY_INCOME_DATA, "COUNTY_INCOME_DATA_transform_latlong.shp")

##############################
# Load district spatial data (elementary, secondar, unified), bind all 3 together, set crs, and remove the string 'School District' from the end of each district name so that it matches the names from enrollment, free meals, and dropout data from CA DoE
##############################

# https://www.census.gov/geo/maps-data/data/cbf/cbf_sd.html (2017)

ca_elementary_districts <- st_read(dsn = ".", layer = "cb_2017_06_elsd_500k") %>% 
  rename(CODE = ELSDLEA)

ca_secondary_districts <- st_read(dsn = ".", layer = "cb_2017_06_scsd_500k")  %>%
   rename(CODE = SCSDLEA)

ca_unified_districts <- st_read(dsn = ".", layer = "cb_2017_06_unsd_500K") %>%
   rename(CODE = UNSDLEA)

ca_districts <- rbind(ca_elementary_districts, ca_secondary_districts, ca_unified_districts)

# set coordinate sysstem to 4326 for all ca_districts
ca_districts_transform <- st_transform(ca_districts, crs = 4326) %>% 
  rename(DISTRICT = NAME) %>% 
  arrange(DISTRICT)

# coerce NAME from factor to character
ca_districts_transform$DISTRICT <- as.character(ca_districts_transform$DISTRICT)

# remove "School District" from NAME
ca_districts_removed <- str_remove(ca_districts_transform$DISTRICT, " School District") 

# combine ca_districts_removed back with ca_districts_transform
ca_districts_binded <- cbind(ca_districts_transform, ca_districts_removed) 

# revised district names + geometry data
ca_districts_final <- ca_districts_binded %>% 
  dplyr::select(ca_districts_removed) %>% 
  rename(DISTRICT = ca_districts_removed) # %>%
  # dplyr::select(DISTRICT)

##############################
# load in enrollment data and wrangle
##############################

# school_enrollment <- read_csv("school_enrollment.csv") %>% 
#   gather("grade", "students", 7:21) %>%
#   mutate(race_eth_name = case_when(
#     ETHNIC == "0" ~ "Not reported",
#     ETHNIC == "1" ~ "AIAN",
#     ETHNIC == "2" ~ "Asian",
#     ETHNIC == "3" ~ "PIsl",
#     ETHNIC == "4" ~ "Filipino",
#     ETHNIC == "5" ~ "Latino",
#     ETHNIC == "6" ~ "AfricanAm",
#     ETHNIC == "7" ~ "White",
#     ETHNIC == "9" ~ "Multiple"),
#     gender = case_when(
#       GENDER == "F" ~ "female",
#       GENDER == "M" ~ "male"
#     ))
# 
# # summarize enrollment by district
# sc_en_dist <- school_enrollment %>% 
#   filter(grade != "NA") %>% 
#   group_by(DISTRICT) %>% 
#   summarise(total_enr = sum(students))


##############################
# Load & wrangle free or reduced meal program data, which also includes enrollment data (year 16-17)
##############################

lunch <- read_csv("free_reduced_lunch.csv") %>% 
  select(county_name, district_name, enrollment_K12, FRPM_count_K12) %>% 
  rename(DISTRICT = district_name) %>% 
  group_by(DISTRICT) %>% 
  summarise(total_lunch = sum(FRPM_count_K12),
            total_enr = sum(enrollment_K12))

##############################
# Load & wrangle dropout data (year 16-17)
##############################

dropouts <- read_csv("dropouts1617.csv")


##############################
# Load & wrangle meet UC/CSU requirements (year 16-17)
##############################

requirements <- read_csv("meet_uc_requirements1617")

##############################
# join district geometries (ca_districts_final) with enrollment & lunch data by districts (sc_en_dist)
##############################

district_enr_spatial <- full_join(ca_districts_final, lunch) %>% 
  arrange(DISTRICT)

#st_write(district_enr_spatial, "district_enr_spatial.shp")

# district_names <- district_enr_spatial %>% 
#   pull(DISTRICT)

#write.csv(district_enr_spatial, "district_enr_spatial.csv")

##############################
# load in coordinate data
##############################

latlong <- read_csv("CA_schools_app3/pubdistricts.csv") %>%
  rename(DISTRICT = District) %>% 
  arrange(DISTRICT) %>% 
  dplyr::select(DISTRICT, Latitude, Longitude) 

# remove " District" from end of each school district name
latlong_district_removed <- str_remove(latlong$DISTRICT, " District")

# combine ca_districts_removed back with ca_districts_transform
latlong_binded <- cbind(latlong, latlong_district_removed) %>% 
  select(latlong_district_removed, Latitude, Longitude) %>% 
  rename(DISTRICT = latlong_district_removed)

# combine latlong data with district_enr_spatial
DISTRICT_DATA <- full_join(district_enr_spatial, latlong_binded) %>% 
  arrange(DISTRICT)

st_write(DISTRICT_DATA, "DISTRICT_DATA_LUNCH3.shp")
# write_csv(DISTRICT_DATA, "DISTRICT_DATA.csv")

# DISTRICT_DATA2 <- st_read("/Users/samanthacsik/Repositories/ESM-244-shiny-app/CA_schools_app3/DISTRICT_DATA.shp")

# a <- subset(DISTRICT_DATA2, DISTRICT_DATA2$DISTRICT=='ABC Unified')

##############################
# use geom_sf to make a map in ggplot
##############################

# add  spatial data polygons and marker that can be clicked, dragged, or hovered over.
map_districts <- leaflet() %>% 
  addProviderTiles("OpenStreetMap") %>% 
  addPolygons(data = ca_districts_transform, fillOpacity = 0.1, weight = 2) %>% 
  addMarkers(lng = -119.4179,
             lat = 36.7783, 
             popup = "You are here.",
             options = markerOptions(draggable = TRUE, riseOnHover = TRUE)) %>% 
  setView(lng = -119.4179,
          lat = 36.7783,
          zoom = 6)


observe({
  if(input$county != "") {
    
    polygon <- subset(COUNTY_INCOME_DATA, COUNTY_INCOME_DATA$NAME == input$county)
    
    # remove any previously highlighted polygons
    ca_county %>% clearGroup("highlighted_polygon")
    
    # center the view on the county polygon
  }
})

