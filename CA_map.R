#############################
# load libraries
##############################
library(tidyverse)
library(sf)
library(leaflet)
library(tmap)

##############################
# CA counties using spatial data
##############################
# ca_counties <- st_read(dsn = ".", layer = "CA_Counties_TIGER2016") # "." means we're already in our wd; layer = "first common string name of each file used"
# 
# ca_land <- ca_counties %>% 
#   select(NAME, ALAND)
# 
# ca_pop_inc <- read_csv("ca_pop_inc.csv")  %>% 
#   rename(NAME = COUNTY) 
# 
# ca_df <- full_join(ca_land, ca_pop_inc) %>% # merge ca_pop_inc to ca_land; full_join will keep every row, even if there isn't a match
#   select(NAME, MedFamilyIncome)

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
# CA counties using spatial data
##############################
ca_counties <- st_read(dsn = ".", layer = "CA_Counties_TIGER2016") # "." means we're already in our wd; layer = "first common string name of each file used"

# write_csv(ca_counties, "ca_counties.csv")

# https://www.census.gov/geo/maps-data/data/cbf/cbf_sd.html

ca_elementary_districts <- st_read(dsn = ".", layer = "cb_2017_06_elsd_500k") %>% 
  rename(CODE = ELSDLEA)

ca_secondary_districts <- st_read(dsn = ".", layer = "cb_2017_06_scsd_500k")  %>%
   rename(CODE = SCSDLEA)

ca_unified_districts <- st_read(dsn = ".", layer = "cb_2017_06_unsd_500K") %>%
   rename(CODE = UNSDLEA)

ca_districts <- rbind(ca_elementary_districts, ca_secondary_districts, ca_unified_districts)


##############################
# use geom_sf to make a map in ggplot
##############################

# ca_counties_map <- ggplot(ca_counties) +
#   geom_sf(lty = 1)

ca_df_transform <- st_transform(ca_districts, crs = 4326)

# leaflet(ca_df_transform) %>%
#   addTiles() %>%
#   addPolygons()

#######################
######################

# create empty widget
# map <- leaflet(width = 400, height = 400) %>% 
#   addTiles(map) %>% 
#   #addPolygons() %>% 
#   setView(map, lng = 119.418,
#                lat = 36.778,
#                zoom = 5)
# 
# # select provider baselayers
# maptypes <- c("MapQuestOpen.Aerial",
#               "OpenStreetMap")
# 
# # use provider tiles
# map <- leaflet() %>% 
#   addProviderTiles(maptypes[1])

# add  spatial data polygons and marker that can be clicked, dragged, or hovered over.
map <- leaflet() %>% 
  addProviderTiles("OpenStreetMap") %>% 
  addPolygons(data = ca_df_transform, fillOpacity = 0.1, weight = 2) %>% 
  addMarkers(lng = -119.4179,
             lat = 36.7783, 
             popup = "You are here.",
             options = markerOptions(draggable = TRUE, riseOnHover = TRUE)) %>% 
  setView(lng = -119.4179,
          lat = 36.7783,
          zoom = 6)
