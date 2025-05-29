# Libraries

library(tidyverse)
library(maps)

# Get the world polygon and extract UK
library(giscoR)

BD <- gisco_get_countries(country = "BD", resolution = 1)


data <- world.cities %>% filter(country.etc == "BD")

dp <- data.frame(long = c(91.86, 88.89),
                 lat = c(25.09, 23.64))

ggplot()+
  geom_sf(data = BD, fill = "orange")+
  geom_point(data = dp, aes(long, lat, , size = lat, alpha = 0.6))

ggplot() +
  geom_sf(data = BD, fill = "grey", alpha = 0.3) +
  geom_point(data = data, aes(x = long, y = lat, alpha = pop))

ccbd <- read_csv("random/map/ccbd.csv")

View(ccbd)

ccbd$area_acres <- c(185, 110, 52, 49, 110, 55, 50, 50, 50, 47, 57, 50)

ggplot() +
  geom_sf(data = BD, fill = "grey")+
  geom_point(data = ccbd, alpha = 0.8, 
             aes(x = lon, 
                 y = lat, 
                 size = area_acres),
             color = "red")+
  theme_void()+
 # theme(legend.position = "none")+
  labs(title = "Location of Cadet Colleges in Bangladesh", 
       size = "Area (acres)", alpha = "")
  
