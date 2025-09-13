# Source

# Libs

library(sf)
library(raster)
library(crsuggest)
library(osmdata)
library(cancensus)
library(readr)
library(dplyr)

a_single_point <- st_point(c(1,3))

attributes(a_single_point)

point1 <- st_point(x = c(1,3))
point2 <- st_point(x = c(2,4))
point3 <- st_point(x = c(3,3))
point4 <- st_point(x = c(4,3))
point5 <- st_point(x = c(5,2))

points <- st_sfc(point1, point2, point3, point4, point5)

points_wgs <- st_sfc(point1, point2, point3, point4, point5, crs = 4326)

attributes(points_wgs)

plot(points_wgs, col = "red", pch = 19)

points_attribute_data <- data.frame(
  transport_mode = c("Bicycle",
                      "Pedestrian",
                      "Motorcycle",
                      "Motorcycle",
                      "Motorcycle"))

points_sf <- st_sf(points_attribute_data, geometry = points)

plot(points_sf, pch = 19)

a_single_line_matrix <- rbind(c(1,1),
                              c(2,4),
                              c(3,3),
                              c(4,3),
                              c(5,2))
a_single_line_matrix

a_single_line <- st_linestring(a_single_line_matrix)

attributes(a_single_line)

plot(a_single_line, col = "blue")

line1 <- st_linestring(rbind(c(1,1),
                             c(2,4),
                             c(3,3),
                             c(4,3),
                             c(5,6)))

line2 <- st_linestring(rbind(c(3,3),
                             c(3,5),
                             c(4,5)))

line3 <- st_linestring(rbind(c(2,4),
                             c(-1,4),
                             c(-2,2)))

lines <- st_sfc(line1, line2, line3, crs = 4326)

attributes(lines)
plot(lines)

line_attribute_data <- data.frame(
  road_name = c("Bijoy Soroni",
                 "Kazi Nazrul Avenue",
                 "Link Road"),
  speed_limit = sample(50,3))

line_attribute_data

lines_sf <- st_sf (line_attribute_data, geometry = lines)

attributes(lines_sf)

plot(lines_sf)

plot(lines_sf[1], lwd = 5)

# Or by column name

plot(lines_sf["speed_limit"], lwd = 6)

# Polygons

a_polygon_matrix <-  rbind(c(1,1), c(2, 4), c(3, 3), c(4, 3), c(5,2),c(1,1))

a_polygon_list <- list(a_polygon_matrix)

a_polygon <- st_polygon(a_polygon_list)

plot(a_polygon, col = "forestgreen")

lake_hole <- rbind(c(1.5,1.5),
                   c(1.5, 1.75),
                   c(1.75, 1.75),
                   c(1.75, 1.5),
                   c(1.5, 1.5))
lake_polygon <- list(a_polygon_matrix, lake_hole)

polygon_with_hole <- st_polygon(lake_polygon)
plot(polygon_with_hole, col = "purple")

# A park

park1 <- polygon_with_hole

plot(park1, col = 3)

park2 <- st_polygon(list(
  rbind(
    c(6,6),c(8,7),c(11,9), c(10,6),c(8,5),c(6,6)
  )
))

park_attributes <- data.frame(park_name = c("Joinul", "Zia"))

park_sf <- st_sf(park_attributes, 
                 geometry = st_sfc(park1, park2, crs = 4326))

plot(park_sf)

# Ratser data

van_raster <- raster(resolution = 1000,
                     xmn = 483691, xmx = 498329,
                     ymn = 5449535, ymx = 5462381,
                     crs = 26910)

van_raster

values(van_raster) # still NA 

num_cells <- ncell(van_raster)

num_cells

cell_values <- runif(num_cells, min = -1, max = 1)

cell_values

values(van_raster) <- cell_values

values(van_raster)

plot(van_raster)

# Use another distribution

values(van_raster) <- rnorm(195, mean = 0, sd = 1)

plot(van_raster)

