library(tidyverse)
library(ggmap)
library(maps)
library(mapdata)

w2hr <- map_data("world2Hires")

ggplot() + geom_polygon(data = w2hr, aes(x=long, y = lat, group = group)) + 
  coord_fixed(1.1)

world <- map_data("world") # from maps package

class(world)

head(world)

View(world)

map_bd <- world %>% filter(region == "Bangladesh")

geocode_47b <- read_csv("data/geocodes_47b.csv")

# Count district frequency and fetch this to data frame.

geocode_47b <- geocode_47b %>% 
  separate_wider_delim(original_address, ",", names =  c("Address", "District")) 
geocode_47b <- geocode_47b %>% 
  left_join(geocode_47b %>% count(District), by = "District")

View(geocode_47b)

ggplot() +
  geom_polygon(data = map_bd, 
               aes(x=long, y = lat, group = group), fill = "grey", alpha = 0.5) +
 # geom_jitter()+
  geom_point(data=geocode_47b, shape = 16,
             aes(x=lon, y=lat, size = 10, alpha = 0.3, color = District))+
 # geom_text(data = geocode_47b, aes(lat, lon, label = District))+
  coord_equal()+
  theme(legend.position = "none")
  

# R: write unicodes this way: \u2600