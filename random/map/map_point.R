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
  geom_sf(data = BD, fill = "orange", alpha = 0.6)+
  geom_point(data = dp, aes(long, lat, , size = lat))

ggplot() +
  geom_sf(data = BD, fill = "grey", alpha = 0.3) +
  geom_point(data = data, aes(x = long, y = lat, alpha = pop))
