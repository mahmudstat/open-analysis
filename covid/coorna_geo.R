#Libraries
library(sp)
library(rgdal)
library(tidyverse)
library(ggmap)
library(maps)
library(mapdata)

library(plyr)
library(RColorBrewer)
library(mapproj)
library(scales)

## Load all

# pkg <- c("tidyverse", "readxl", "broom", "RColorBrewer", "nnet")

# lapply(pkg, require, character.only = TRUE)

#Read rds fiels
#These are for r

# Source: https://gadm.org/download_country_v3.html

gadm36_BGD_0_sp <- readRDS("data/gadm36_BGD_0_sp.rds")
class(gadm36_BGD_1_sp)
plot(gadm36_BGD_1_sp)

gadm36_BGD_4_sp <- readRDS("data/gadm36_BGD_4_sp.rds")

plot(gadm36_BGD_2_sp, col="blue")

gadm36_BGD_2_sp <- readRDS("data/gadm36_BGD_2_sp.rds")
gadm36_BGD_2_sp$crit <- sample(64)

zilla=readOGR("D:/R/RGIS/BD", layer="BGD_adm2")
zilla$crit=sample(64)
library(sp)
spplot(zilla, "crit",col.regions=heat.colors(5),
       cuts=4, col='transparent', main='Sample Map',
       sub='Based on_', scales=list(draw=T))

# FRom
# https://eriqande.github.io/rep-res-web/lectures/making-maps-with-R.html
usa <- map_data("usa")
dim(usa)
head(usa)

gg1 <- ggplot() +
  geom_polygon(data = usa, aes(x = long, y = lat, group = group),
               color = "red", fill = "violet")+
  coord_fixed(1.3)

class(usa)

labs <- data.frame(
  long = c(-122.064873, -122.306417),
  lat = c(36.951968, 47.644855),
  names = c("SWFSC-FED", "NWFSC"),
  stringsAsFactors = FALSE
) 

gg1 + 
  geom_point(data = labs, aes(x = long, y = lat), color = "black", size = 5) 

gg1 + 
  geom_point(data = labs, aes (x = long, y = lat), color = "green", size = 3)

states <-  map_data("state")

ggplot(states) +
  geom_polygon(aes(x = long, y = lat, fill = region, group = group), color = "white") +
  theme(legend.position = "none") +
  coord_fixed(1.6)

world <- map_data("world2Hires")

ggplot(world) +
  geom_polygon(aes(x = long, y= lat, fill = "blue"))+
  coord_fixed(1.3)

dim(world)

head(world)

corona_dat <- read_csv("geo/corona.csv")

View(corona_dat)

corona_clean <- corona_dat[-1, -c(1,6)] %>% 
  rename(country = `Countries and territories[a]_1`,
         case = `Cases[b]`,
         death = `Deaths[c]`,
         recover= `Recov.[d]`) %>% 
  mutate(case = str_remove(case, ","),
         death = str_remove(death, ","),
         recover = str_remove(recover, ","),
         country = gsub("\\[.*", "", country))

View(corona_clean)

world_map <- readOGR("gadm36.gpkg", layer = "gadm36")

map('world',col="grey", fill=TRUE, bg="white", lwd=0.05, mar=rep(0,4),border=0, ylim=c(-80,80) )



world <- map_data("world")

ggplot(world) + geom_polygon(aes(long, lat)) + coord_fixed(1.8)

zilla <- readOGR("geo/BDshp", layer = "BGD_adm2")

plot(bd)

class(bd)

View(zilla)

zilla2 <- edit(zilla@data)

plot(zilla2)

write_csv(zilla@data, "districts.csv")

zilla@data %>% select(NAME_2) %>% write_csv("districts.csv")


###FRpm https://www.r-spatial.org//r/2018/10/25/ggplot2-sf.html

library("ggplot2")
theme_set(theme_bw())
library("sf")

library("rnaturalearth")
library("rnaturalearthdata")
library(rgeos)

world <- ne_countries(scale = "medium", returnclass = "sf")

class(world)

View(world)
ggplot(data = world) + geom_sf(aes(fill = pop_est))+
  labs (x="Longitude", y = "Latitude") + ggtitle("Main")+
  scale_fill_viridis_c(option = "plasma", trans ="sqrt")

#Round globe

ggplot(data = world) +
  geom_sf(aes(fill = pop_est)) +
  scale_fill_viridis_c(option = "plasma", trans ="sqrt")+
  coord_sf(crs = "+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs ")

#Fetch corona data
corona_clean <- corona_clean %>% rename(sovereignt = country)

world2 <- world %>% left_join(corona_clean, by = "sovereignt")

world2$recover <-  as.numeric(world2$recover)

ggplot(world2) +
  geom_sf(aes(fill = recovery)) +
  scale_fill_viridis_c(option = "D", begin = 0.5, end = 0.9, direction = -1)+
  coord_sf(crs = "+proj=laea +lat_0=23 +lon_0=0 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs ")+
  labs(title = "Covid-19 Effect", 
       subtitle = "data from worldometers.info (as of 02 April, 2020)")+
  theme(legend.position = "left")

ggsave("covid19_recv.png")

ggplot(world2) +
  geom_sf(aes(fill = death)) +
  scale_fill_viridis_c(option = "A", begin = 0.5, end = 0.9, direction = -1)+
  coord_sf(crs = "+proj=laea +lat_0=40 +lon_0=90 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs ")+
  labs(title = "Covid-19 Effect", 
       subtitle = "data from worldometers.info (as of 02 April, 2020)")+
  theme(legend.position = "bottom")

ggsave("covid19_death.png")

ggplot(world2) +
  geom_sf(aes(fill = affected)) +
  scale_fill_viridis_c(option = "B", begin = 0.9, end = 0.5, direction = 1)+
  coord_sf(crs = "+proj=laea +lat_0=23 +lon_0=20 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs ")+
  labs(title = "Covid-19 Effect", 
       subtitle = "data from worldometers.info (as of 02 April, 2020)")+
  theme(legend.position = "left")+
  geom_point(x, aes(lon, lat, size=3))

ggsave("covid19_case.png")

ggplot(world2) +
  geom_sf(aes(fill = affected)) +
  scale_fill_gradient("Confirmed Cases",
                      low = "yellow",
                      high = "red",
                      space = "Lab",
                      na.value = "green",
                      guide = "colorbar",
                      aesthetics = "fill"
  )+
  coord_sf(crs = "+proj=laea +lat_0=23 +lon_0=20 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs ")+
  labs(title = "Covid-19 Effect", 
       subtitle = "data from worldometers.info (as of 02 April, 2020)")+
  theme(legend.position = "left")

View(world2)

world2$recovery[c(42, 91, 133)] <- 76571
world2$recovery[c(11,89,148,176,227,233)] <- 11983


world2$case[c(42, 91, 133)] <- 81620
world2$case[c(11,89,148,176,227,233)] <- 265001

world2 <- world2 %>% rename(affected = case)

plot(zilla, col= corona_bd$corona)

#BD
corona_bd <- read_csv("geo/districts_corona.csv")
zilla$corona <- corona_bd$corona
corona_bd$id <- 0:63

zilla_gg <- fortify(zilla)
zilla_gg <- zilla_gg %>% mutate(id = as.numeric(id))

zilla_gg <-  zilla_gg %>% left_join(corona_bd, by = "id")
zilla_gg <- zilla_gg %>% mutate(corona = replace_na(corona, 0))

ggplot(zilla_gg, fill= corona) + 
  geom_polygon(aes(x=long, y=lat, group = group, color= "grey"))+
  geom_point(aes(x=long, y=lat, size=corona))

ggplot(zilla_gg) + aes(long, lat, group=group, fill = corona)+
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
ggsave("geo/coronabd3.png")

ggplot(zilla_gg) + aes(long, lat, group=group, fill = corona)+
  geom_polygon() +
  geom_path()+
  coord_equal()+
  scale_fill_gradient("Confirmed Cases",
    low = "#ffbf00",
    high = "#ff0000",
    space = "Lab",
    na.value = "green",
    guide = "colorbar",
    aesthetics = "fill"
  )+
  labs(title = "Coronavirus Cases in Bangladesh", 
       subtitle = "source: iedcr.gov.bd, as of 08 April, 2020",
       caption = "copyright: mahmud")

ggsave("geo/corona_bd2.png")  
  
ecoreg <- readOGR("geo/ecoregion_design", layer = "eco_l3_ut")

View(ecoreg@data)


#New World Map

corona_src <- "https://www.worldometers.info/coronavirus/"

library(rvest)
covid19_global <- html_table(read_html(corona_src))[[1]]

View(covid19_global)
View(covid19_global_clean)

covid19_global_clean <- covid19_global %>% 
  mutate(TotalCases = str_remove(TotalCases, ",")) %>% 
  mutate(TotalDeaths = str_remove (TotalDeaths, ",")) %>% 
  select(`Country,Other`, TotalCases, TotalDeaths) %>% 
  rename(sovereignt = `Country,Other`) %>% 
  mutate(TotalCases = as.numeric(TotalCases)) %>% 
  mutate(TotalDeaths = as.numeric(TotalDeaths))

#US data is not included
#BUT 
world2$TotalCases.y[world2$sov_a3=="US1"] = 435160
world2$TotalDeaths.y[world2$sov_a3=="US1"] = 14797


library("rnaturalearth")
library("rnaturalearthdata")
library(rgeos)
world <- ne_countries(scale = "medium", returnclass = "sf")

world2 <- world2 %>% left_join(covid19_global_clean, by = "sovereignt")

ggplot(world2) +
  geom_sf(aes(fill = TotalCases.y)) +
  scale_fill_gradient("Confirmed Cases",
                      low = "#d9b3ff",
                      high = "#ff3300",
                      space = "Lab",
                      na.value = "#f2f2f2",
                      guide = "colorbar",
                      aesthetics = "fill")+
  labs(title = "Worldwide Covid-19 Effect", 
       subtitle = "data from worldometers.info (as of 09 April, 2020)")+
  theme(legend.position = "left")+
  geom_point(data=x, aes(lon, lat, size=3))+
  coord_sf(crs = "+proj=laea +lat_0=0 +lon_0=0 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs ")
ggsave("corona_global1.png")



