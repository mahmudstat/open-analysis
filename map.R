# Libraries

install.packages("rgdal")

library(tidyverse)

pkg <- c("tidyverse", "rgdal", "sf")
library(pkg)

bdmap <- readRDS("random/map/gadm36_BGD_4_sf.rds")

View(bdmap)
class(bdmap)

head(bdmap, 3)

names(bdmap)

plot(bdmap['NAME_4'])


