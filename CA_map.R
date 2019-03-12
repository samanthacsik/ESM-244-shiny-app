#############################
# load libraries
##############################

library(tidyverse)
library(sf)
library(leaflet)
library(tmap)

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

county_latlong <- read_csv("county_latlong.csv") 

##############################
# Load income by county data
##############################

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

#st_write(COUNTY_INCOME_DATA, "COUNTY_INCOME_DATA.shp")

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
# Load & wrangle free or reduced meal program data, which also includes enrollment data (year 16-17)
##############################

lunch <- read_csv("free_reduced_lunch1617.csv") %>% 
  select(county_name, district_name, enrollment_K12, FRPM_count_K12) %>% 
  rename(DISTRICT = district_name) %>% 
  group_by(DISTRICT) %>% 
  summarise(total_lunch = sum(FRPM_count_K12),
            total_enr = sum(enrollment_K12))

##############################
# Load & wrangle dropout data (year 16-17)
##############################

# dropouts <- read_csv("dropouts1617.csv") %>% 
#   select(DISTRICT, TOTAL) %>% 
#   group_by(DISTRICT) %>% 
#   summarize(total_dropouts = sum(TOTAL))

##############################
# Load & wrangle meet UC/CSU requirements (year 16-17)
##############################

requirements <- read_csv("requirements1617.csv") %>% 
  select(COUNTY, DISTRICT, TOTAL) %>% 
  group_by(DISTRICT) %>% 
  summarize(total_requirements = sum(TOTAL))

##############################
# join lunch & requirements dfs
##############################

ca_schools_info <- full_join(lunch, requirements) %>% 
  mutate(perc_lunch1 = (total_lunch/total_enr)*100) %>% 
  mutate(perc_requirements1 = (total_requirements/total_enr)*100) %>% 
  mutate(perc_lunch = round(perc_lunch1, 2)) %>% 
  mutate(perc_requirements = round(perc_requirements1, 2)) %>% 
  select(DISTRICT, total_enr, perc_lunch, perc_requirements)

##############################
# join district geometry data with lunch/requirements data
##############################

district_school_info_spatial <- full_join(ca_districts_final, ca_schools_info) %>% 
  arrange(DISTRICT)

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

##############################
# join district geometries (ca_districts_final) with enrollment & lunch data by districts (sc_en_dist)
##############################

# combine latlong data with district_enr_spatial
DISTRICT_DATA <- full_join(district_school_info_spatial, latlong_binded) %>% 
  arrange(DISTRICT)

st_write(DISTRICT_DATA, "DISTRICT_DATA2.shp")
am_sum(sam_sum(4, 3), 10)
