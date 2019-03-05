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

ca_counties <- st_read(dsn = ".", layer = "CA_Counties_TIGER2016") %>%  # "." means we're already in our wd; layer = "first common string name of each file used"
  arrange(NAME)

write_csv(ca_counties, "ca_counties.csv")

# view county data in easy plot
ca_land <- ca_counties %>% 
  dplyr::select(NAME, ALAND)

# Read pop/income data, then make sure county names column matches
ca_pop_inc <- read_csv("ca_pop_inc.csv") %>% 
  rename(NAME = COUNTY)

# Join the two: 
ca_df <- full_join(ca_land, ca_pop_inc) %>% 
  dplyr::select(NAME, MedFamilyIncome)

# Make a map: 
ca_income <- ggplot(ca_df) +
  geom_sf(aes(fill = MedFamilyIncome), color = "white", size = 0.2) +
  scale_fill_gradientn(colors = c("blue","mediumorchid1","orange")) +
  theme_minimal()

ca_income

##############################
# CA districts using spatial data
##############################

# https://www.census.gov/geo/maps-data/data/cbf/cbf_sd.html

ca_elementary_districts <- st_read(dsn = ".", layer = "cb_2017_06_elsd_500k") %>% 
  rename(CODE = ELSDLEA)

ca_secondary_districts <- st_read(dsn = ".", layer = "cb_2017_06_scsd_500k")  %>%
   rename(CODE = SCSDLEA)

ca_unified_districts <- st_read(dsn = ".", layer = "cb_2017_06_unsd_500K") %>%
   rename(CODE = UNSDLEA)

ca_districts <- rbind(ca_elementary_districts, ca_secondary_districts, ca_unified_districts)

# set coordinate sysstem to 4326 for all ca_districts
ca_districts_transform <- st_transform(ca_districts, crs = 4326) 

# coerce NAME from factor to character
ca_districts_transform$NAME <- as.character(ca_districts_transform$NAME)

# remove "School District" from NAME
ca_districts_removed <- str_remove(ca_districts_transform$NAME, " School District") 

# combine ca_districts_removed back with ca_districts_transform
ca_districts_binded <- cbind(ca_districts_transform, ca_districts_removed) 

# revised district names + geometry data
ca_districts_final <- ca_districts_binded %>% 
  rename(DISTRICT = ca_districts_removed) %>% 
  dplyr::select(DISTRICT)

##############################
# load in enrollment data and wrangle
##############################

school_enrollment <- read_csv("school_enrollment.csv") %>% 
  gather("grade", "students", 7:21) %>%
  mutate(race_eth_name = case_when(
    ETHNIC == "0" ~ "Not reported",
    ETHNIC == "1" ~ "AIAN",
    ETHNIC == "2" ~ "Asian",
    ETHNIC == "3" ~ "PIsl",
    ETHNIC == "4" ~ "Filipino",
    ETHNIC == "5" ~ "Latino",
    ETHNIC == "6" ~ "AfricanAm",
    ETHNIC == "7" ~ "White",
    ETHNIC == "9" ~ "Multiple"),
    gender = case_when(
      GENDER == "F" ~ "female",
      GENDER == "M" ~ "male"
    ))

# summarize enrollment by district
sc_en_dist <- school_enrollment %>% 
  filter(grade != "NA") %>% 
  group_by(DISTRICT) %>% 
  summarise(total_enr = sum(ENR_TOTAL))

# summarize enrollment by county
# sc_en_county <- school_enrollment %>% 
#   filter(grade != "NA") %>% 
#   mutate(grade_num = case_when(
#     grade == "KDGN" ~ 0,
#     grade == "GR_1" ~ 1, 
#     grade == "GR_2" ~ 2,
#     grade == "GR_3" ~ 3,
#     grade == "GR_4" ~ 4,
#     grade == "GR_5" ~ 5, 
#     grade == "GR_6" ~ 6, 
#     grade == "GR_7" ~ 7, 
#     grade == "GR_8" ~ 8, 
#     grade == "GR_9" ~ 9, 
#     grade == "GR_10" ~ 10, 
#     grade == "GR_11" ~ 11, 
#     grade == "GR_12" ~ 12
#   )) %>% 
#   group_by(COUNTY) %>% 
#   summarise(total_enr = sum(ENR_TOTAL))

# summarize enrollment by cds code
# sc_en_cds <- school_enrollment %>% 
#   filter(grade != "NA") %>% 
#   mutate(grade_num = case_when(
#     grade == "KDGN" ~ 0,
#     grade == "GR_1" ~ 1, 
#     grade == "GR_2" ~ 2,
#     grade == "GR_3" ~ 3,
#     grade == "GR_4" ~ 4,
#     grade == "GR_5" ~ 5, 
#     grade == "GR_6" ~ 6, 
#     grade == "GR_7" ~ 7, 
#     grade == "GR_8" ~ 8, 
#     grade == "GR_9" ~ 9, 
#     grade == "GR_10" ~ 10, 
#     grade == "GR_11" ~ 11, 
#     grade == "GR_12" ~ 12
#   )) %>% 
#   group_by(CDS_CODE) %>% 
#   summarise(total_enr = sum(ENR_TOTAL))

# grades <- c("KDGN", "GR_1", "GR_2", "GR_3", "GR_4", "GR_5", "GR_6", "GR_7", "GR_8", "GR_9", "GR_10", "GR_11", "GR_12")
# 
# sc_en$grade <- factor(sc_en$grade, levels = grades)

##############################
# join district geometries (ca_districts_final) with enrollment data by districts (sc_en_dist)
##############################

district_enr_spatial <- full_join(ca_districts_final, sc_en_dist)

# write otu spatial data to call in shiny app
#st_write(district_enr_spatial, "district_enr_spatial.shp")

#write.csv(district_enr_spatial, "district_enr_spatial.csv")

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

##############################
# load in coordinate data
##############################

# latlong <- read_csv("pubschls.csv") %>%
#   dplyr::select(CDSCode, County, School, Latitude, Longitude) %>%
#   rename(CDS_CODE = CDSCode)


