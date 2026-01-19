# A basic introduction to Moran’s I analysis in R


# https://mgimond.github.io/simple_moransI_example/

library(sf)
library(spdep)
library(tmap)

s <- readRDS(url("https://github.com/mgimond/Data/raw/gh-pages/Exercises/nhme.rds"))

names(s)

# EDA 
hist(s$Income)
boxplot(s$Income, horizontal = TRUE)

# Map

tm_shape(s) + 
  tm_fill(col = "Income", style = "quantile", n = 8, pallete = "Greens")+
  tm_legend(outside = TRUE)

# Moran’s I analysis


nb <- poly2nb(s, queen = TRUE)

nb[[1]]

lw <- nb2listw(nb, style = "W", zero.policy = TRUE)

lw$weights

