# https://rpubs.com/heatherleeleary/hotspot_getisOrd_tut
# Data
# https://gisdata.tucsonaz.gov/datasets/cotgis::tree-equity-scores-tucson-1/about

library(sf)
library(sfdep)
library(spdep)

tes_data <- st_read("random/map/data/tree_equity_data.geojson")

head(tes_data)

hist(tes_data$TreeEquityScore)

ggplot(tes_data)+
  geom_sf(aes(fill = TreeEquityScore), 
          color = "black", 
          lwd = 0.1)+
  scale_fill_gradient(name = "Tree Equity Score",
                      low = "white",
                      high = "blue")+
  theme_void()

# Create a neighbor list

list_nb <- poly2nb(tes_data, queen = TRUE)


