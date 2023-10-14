#Libs

pkg <- c("tidyverse", "readxl", "broom", "RColorBrewer", "sf", "sp", "ggmap")

library(ggspatial) # For north arrow

lapply(pkg, require, character.only = TRUE)

library(tidyverse)
library(RColorBrewer)
library(sf)

bd_division_weather <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vQ6g3f0KJDt19di48bx55E_mTZZAtrop8psWbIUk4hD0YiVO4ivQHUw5yA3wTgb2_ddAn72Hut_GkuR/pub?output=csv")

View(bd_division_weather)

bd_dist_names <- read_csv("data/bd_districts.csv")

View(bd_dist_names)

# Bar Plot (Annual Rainfall)

bd_division_weather %>% group_by(City) %>% 
  summarise(TotRain = sum(Rainfall_mm)) %>% 
  mutate(City = factor(City, levels = City[order(TotRain)])) %>% 
  ggplot(aes(City, TotRain, fill = City))+
  scale_fill_brewer(palette = "PiYG")+
  geom_bar(stat = "identity", width = 0.8)+
  coord_flip()+
  theme(legend.position = "none",
        axis.title = element_text(face="bold"))+
  geom_text(aes(label=TotRain), vjust=1, color="black", hjust = 1,
            position = position_dodge(0.5), size=3.5)+
  labs(y = "Rainfall", 
       x = "City", 
       title = "Yearly Rainfall (mm) in Bangladesh Divisional Cities")

# 

# Rainfall Map

# Divisional Map: Download from the following link 
# https://gadm.org/download_country_v3.html
# For divisions: BGD_1_sp
# For districts: BGD_2_sp

bd_div <- readRDS("data/gadm36_BGD_1_sp.rds")

dim(bd_div)

View(bd_div)

# Add rain data

# Total Rainfall
TotR <- bd_division_weather %>% group_by(City) %>% 
  summarise(TotRain = sum(Rainfall_mm))

bd_div$Rain <- TotR$TotRain[c(1:4, 6:8)]


spplot(bd_div, "Rain", col.regions = brewer.pal(n = 7, name = "YlGn"),
       cuts=6, col='transparent', main='Annaul Rainfall  (in mm) in Bnagladesh',
       sub='Source: WMO & BMD', scales=list(draw=T))

# District Rainfall

bd_dist_rain <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vQ6g3f0KJDt19di48bx55E_mTZZAtrop8psWbIUk4hD0YiVO4ivQHUw5yA3wTgb2_ddAn72Hut_GkuR/pub?gid=272007487&single=true&output=csv")

View(bd_dist_rain)

# See top values 

bd_dist_rain %>% slice_max(Rainfall18_m, n = 10)

# More than 2k

bd_dist_rain %>% filter(Rainfall18_m>2000)

# District Map

bd_dist_map <- readRDS("data/gadm36_BGD_2_sp.rds")

bd_dist_map@data$NAME_2

bd_dist_map$Rain <- bd_dist_rain$Rainfall17_mm

View(bd_dist_rain)

spplot(bd_dist_map, "Rain", col.regions = brewer.pal(n = 5, name = "PuBuGn"),
       cuts=4, col='transparent', main='Annaul Rainfall  (in mm) in Bnagladesh',
       sub='Source: WMO & BMD (2017)', scales=list(draw=T))

# col.regions = heat.colors(8) another option

bd_dist_map@data$NAME_2
bd_dist_rain$District

# Fortified data

bd_div_gg <- fortify(bd_div)
latlon <- read_csv("data/geocodes.csv")
View(latlon)

# Points on map

ggplot(bd_div_gg, aes(long, lat, group=group)) +
  geom_polygon() +
  geom_path(color= "white")+
  coord_equal()+
  annotation_north_arrow(location = "tr", which_north = "true", 
                         pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                         style = north_arrow_fancy_orienteering)
  geom_point(data = latlon, aes(lon, lat))

  
  
## Maps from Google
qmap("Dhaka")
  
# Geocode 
# https://www.geoapify.com/tools/geocoding-online


