# https://r.geocompx.org/intro


# Chapter 1: Intro #### 
library(leaflet)
install.packages("sf")
install.packages("terra")
install.packages("spData")
install.packages("spDataLarge", repos = "https://geocompr.r-universe.dev")

library(sf)
library(terra)
library(spData)

# Better to load one by one 

packages_to_load <- c("dplyr", "terra", "spData")
invisible(lapply(packages_to_load, library, character.only = TRUE))

# Preview | Night View ####

popup <- c("Robin", "Jakub", "Jannes")

leaflet() |> 
  addProviderTiles("NASAGIBS.ViirsEarthAtNight2012") |>
  addMarkers(lng = c(89, 93),
             lat = c(21, 23),
             popup = popup)

class(world) # from spData

names(world)

plot(world)

summary(world["lifeExp"])

# subset 
world_mini <- world[1:2, 1:3]

world_mini |> plot()

View(world)

plot(world$name_long == "Bangladesh")

# Basic Maps ####

plot(world[3:6])

plot(world["continent"])

plot(subset(world, continent == "Africa"))

plot(subset(world, name_long == "Bangladesh")["name_long"]) # not accurate shape

world_asia <- world[world$continent=="Asia", ]
asia <- st_union(world_asia)

plot(world["pop"], reset = FALSE)

plot(asia, add = TRUE, col = "red")

plot(st_union(world[world$name_long=="Bangladesh", ]), 
     add = TRUE, col = "black") # works


plot(world["continent"], reset = FALSE)
cex = sqrt(world$pop)/10000
world_cents = st_centroid(world, of_largest = TRUE)
plot(st_geometry(world_cents), 
     add = TRUE,
     cex = cex)

bn <- world[world$name_long ==  "Bangladesh",]

plot(st_geometry(bn), expandBB = c(1, 1.4, 1.6, 1), col = "grey", lwd = 3)
plot(st_geometry(world_asia), add = TRUE)


# Geometries ####

lnd_point <- st_point(c(0.1, 51.5))
lnd_geom <- st_sfc(lnd_point, crs = "EPSG:4326")
lnd_attribute <- data.frame(
  name = "London",
  temperature = 25,
  date = as.Date("2023-06-21")
)
lnd_sf <- st_sf(lnd_attribute, geometry = lnd_geom)

lnd_sf

class(lnd_sf)

# Points ####

st_point(c(5,2)) # XY 
st_point(c(5,2,3)) # XYZ point

st_point(c(5,2,1), dim = "XYM") # 3D

st_point(c(5,2,3,1)) # XYZM, with extra variable


multipoin_matrix <- rbind(c(5,2), c(1,3), c(3,4), c(3,2))

st_multipoint(multipoin_matrix)

# Multi Line ####

linestring_matrix <- rbind(c(1,5), c(4,4), c(4,1), c(2,2), c(3,2))

st_linestring(linestring_matrix)

plot(linestring_matrix) # the above has no effect in plotting

# Polygon List ####

polygon_list <- list(rbind(c(1, 5), c(2, 2), c(4, 1), c(4, 4), c(1, 5)))

plot(polygon_list) # not working, may be cause its a list
st_polygon(polygon_list)

polygon_border <- rbind(c(1,5),
                        c(2,2),
                        c(4,1),
                        c(4,4),
                        c(1,5))
polygon_hole <- rbind(c(2,4),
                      c(3,4),
                      c(3,3),
                      c(2,3),
                      c(2,4)
)

polygon_with_hole_list <- list(polygon_border, polygon_hole)
st_polygon((polygon_with_hole_list))

# To plot

polygon_hole_sf <- st_polygon(polygon_with_hole_list)

plot(polygon_hole_sf, col = "blue")

# How to col() hole?


