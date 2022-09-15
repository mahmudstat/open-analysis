## Libraries

library(sp)
library(tidyverse)

bd_dist <- readRDS("data/gadm36_BGD_2_sp.rds")
corona_dat <- read_csv("data/corona.csv")

View(corona_dat)

bd_dist$covid <- sample(64)
spplot(bd_dist, "covid",col.regions=heat.colors(5),
           cuts=4, col='transparent', main='Sample Map',
           sub='Based on_', scales=list(draw=T))

## Plot using ggplot2

bd_dist_gg <- fortify(bd_dist)

View(bd_dist_gg)
class(bd_dist_gg)

bd_dist_gg <- bd_dist_gg %>% mutate(id = as.numeric(id))

bd_dist_gg <-  bd_dist_gg %>% left_join(corona_dat, by = "id")
bd_dist_gg <- bd_dist_gg %>% mutate(corona = replace_na(corona, 0))

ggplot(bd_dist_gg,  fill= corona)+ 
  geom_polygon(aes(x=long, y=lat, group = group))+
  geom_point(aes(x=long, y=lat, size=corona))

ggplot(bd_dist_gg) + aes(long, lat, group=group, fill = corona)+
  geom_polygon() +
  geom_path(color= "white")+
  coord_equal()+
  scale_fill_gradient("Confirmed Cases",
                      low = "yellow",
                      high = "red",
                      space = "Lab",
                      na.value = "blue",
                      guide = "colorbar",
                      aesthetics = "fill"
  )+
  labs(title = "Coronavirus Cases in Bangladesh", 
       subtitle = "source: iedcr.gov.bd, as of 08 April, 2020",
       caption = "copyright: mahmud")

## Plot visit

visit <- read_csv("random/my_visit_bd/bd_visits.csv")

bd_dist$visit <- visit$status_num

spplot(bd_dist, "visit", col.regions=heat.colors(4),
       cuts=3, col='blue', main='Sample Map', scales=list(draw=T))

# Natural Earth
# Fetch map and plot points 

library("rnaturalearth")
library("rnaturalearthdata")
library(rgeos)

bdne <- ne_countries(scale = "medium", returnclass = "sf", 
                     country = "bangladesh")

class(bdne)

View(bdne)

ggplot(data = bdne) + geom_sf(aes())+
  labs (x="Longitude", y = "Latitude") + ggtitle("Main")+
  scale_fill_viridis_c(option = "plasma", trans ="sqrt")

## 