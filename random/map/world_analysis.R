library(tidyverse)
library(ggmap)
library(maps)
library(mapdata)

world_coordinates <- map_data("world") 
options( scipen = 999 )
# Quakes Data

wquake <- read_csv("data/quakeworld.csv")

p1 <- ggplot() + 
  geom_map( 
    data = world_coordinates, map = world_coordinates, 
    aes(long, lat, map_id = region),
    fill = "green"
  )+
  theme(aspect.ratio = 0.6)

p1 + 
  geom_point(data = wquake, 
             aes(x = longitude, 
                 y = latitude,
                # size = mag,
                 color = mag))+
  scale_color_gradient(high = "red", low = "yellow")+
  labs(title = "Earthquakes around the World in 2024 (Jan to Sep)",
       color = "Magnitude")+
  theme(axis.text.x=ggplot2::element_blank(),
        axis.ticks.x=ggplot2::element_blank(),
        axis.text.y=ggplot2::element_blank(),
        axis.ticks.y=ggplot2::element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        legend.position = "bottom",
        panel.grid.major = element_blank(), # Remove grid lines
        panel.grid.minor = element_blank())

# World Cities

p1 + 
  geom_point(data = filter(world.cities, pop > 1000000), 
             aes(x = long, 
                 y = lat,
                 alpha = 0.9,
                 size = pop,
                 color = pop))+
  scale_color_gradient(high = "red", low = "orange")+
  labs(title = "Cities of the World with Population More Than 1 Million",
       size = "Population")+
  theme(axis.text.x=ggplot2::element_blank(),
        axis.ticks.x=ggplot2::element_blank(),
        axis.text.y=ggplot2::element_blank(),
        axis.ticks.y=ggplot2::element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        legend.position = "bottom",
        panel.grid.major = element_blank(), # Remove grid lines
        panel.grid.minor = element_blank())+
  guides(color = "none", alpha = "none")

# Old

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