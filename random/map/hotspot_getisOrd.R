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

list_nb <- spdep::poly2nb(tes_data, queen = TRUE)

empty_nb <- which(card(list_nb) == 0)

tes_subset <- tes_data[-empty_nb, ]

names(tes_data)

# Further cleaning

which(is.na(tes_data$TreeEquityScore))
which(is.infinite(tes_data$TreeEquityScore))
tes_data <- na.omit(tes_data)

tes_nb <- poly2nb(tes_data, queen = TRUE)

test_w_binary <- nb2listw(test_nb, style = "B")

test_lag <- lag.listw(test_w_binary, tes_data$TreeEquityScore)
