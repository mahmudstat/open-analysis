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

# Count district frequency and fetch this to dataframe. 

geocode_47b <- geocode_47b %>% 
  separate(original_address, c("Address", "District")) 
geocode_47b <- geocode_47b %>% 
  left_join(geocode_47b %>% count(District), by = "District")

View(geocode_47b)

ggplot() +
  geom_polygon(data = map_bd, 
               aes(x=long, y = lat, group = group, fill = "red", alpha = 0.9)) +
  geom_point(data=geocode_47b, shape = 1, 
             aes(x=lon, y=lat, size = 3), color = "green")+
  geom_jitter()+
  coord_equal()+
  theme(legend.position = "none")
  

