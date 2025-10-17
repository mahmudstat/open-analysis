library(tidyverse)

library(sf)
bd_dist <- st_read("random/map/data/gadm41_BGD_2.json")

plot(bd_dist["COUNTRY"])

## ggplot2

dp <- data.frame(long = c(91.86, 88.89),
                 lat = c(25.09, 23.64),
                 size = c(5,2))

acclatlon <- read_csv("random/map/data/acclatlon.csv")

View(acclatlon)

bd_dist |> ggplot()+
  geom_sf()+
  geom_point(data = acclatlon, 
             aes(x = lon, 
                 y=lat, 
                 color= "red", 
                 size = original_killed,
                 alpha = 0.9))+
  labs(x = "", y = "")+
  scale_fill_viridis_c()



