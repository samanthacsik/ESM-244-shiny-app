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

ca_secondary_districts <- st_read(dsn = ".", layer = "cb_2017_06_scsd_500k")  %>% 
  rename(CODE = SCSDLEA)

ca_unified_districts <- st_read(dsn = ".", layer = "cb_2017_06_unsd_500K") %>% 
  rename(CODE = UNSDLEA)

ca_districts <- rbind(ca_secondary_districts, ca_unified_districts)

##############################
# use geom_sf to make a map in ggplot
##############################

ca_districts <- ggplot(ca_districts) +
  geom_sf(lty = 1)  

ca_districts

ca_df_transform <- st_transform(ca_districts, crs = 4326)

leaflet(ca_df_transform) %>% 
  addTiles() %>% 
  addPolygons()
