pkg <- c("tidyverse", "readxl", "broom", "RColorBrewer", "sf", "sp", "ggmap",
         "gridExtra" # for combining multiple plot
         )

library(ggspatial) # For north arrow

lapply(pkg, require, character.only = TRUE)

bd_dist_map <- readRDS("data/gadm36_BGD_2_sp.rds")

scc47b <- read_csv("random/map/scc47b.csv")

bd_dist_map$scc47b <- scc47b$count

geocode_47b <- read_csv("data/geocodes_47b.csv")

par(mfrow=c(1,2))

spplot(bd_dist_map, "scc47b", col.regions = brewer.pal(n = 5, name = "Greens"),
       cuts=4, col='transparent', main='Cadet Map (47B)',
       sub='', scales=list(draw=T))

dev.off()

map_bd <- map_data("world") %>% filter(region == "Bangladesh")

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

# Combined

grid.arrange(ggplot() +
               geom_polygon(data = map_bd, 
                            aes(x=long, y = lat, group = group), fill = "grey", alpha = 0.5) +
               # geom_jitter()+
               geom_point(data=geocode_47b, shape = 16,
                          aes(x=lon, y=lat, size = 10, alpha = 0.3, color = District))+
               # geom_text(data = geocode_47b, aes(lat, lon, label = District))+
               coord_equal()+
               labs(title = "Cadet Map (47B)")+
               theme(legend.position = "none"),
             spplot(bd_dist_map, "scc47b", col.regions = brewer.pal(n = 5, name = "Greens"),
                    cuts=4, col='transparent', main='',
                    sub='', scales=list(draw=T)),
             ncol = 2)
