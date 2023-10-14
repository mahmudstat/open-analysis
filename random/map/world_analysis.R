library(ggplot2)
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

ggplot() +
  geom_polygon(data = map_bd, aes(x=long, y = lat, group = group), fill="grey", alpha=0.3) +
  geom_point( data=latlon, aes(x=lon, y=lat))+
  coord_equal()
