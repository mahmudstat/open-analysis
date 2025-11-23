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

bd_dist |> ggplot() +
  geom_sf() +
  geom_point(data = acclatlon, 
             aes(x = lon, 
                 y = lat, 
                 fill = original_killed,  # ← Mapped to FILL
                 size = original_injured),
             shape = 21,                  # ← Shape that uses FILL
             alpha = 0.7) +
  labs(x = "", y = "") +
  facet_wrap(~original_day) +
  theme_void() +
  scale_fill_gradient(name = "Killed",    # ← Changed to FILL gradient
                      low = "blue",
                      high = "red") +
  scale_size_continuous(name = "Injured")


