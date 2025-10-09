# SRC https://rspatial.org/spatial/index.html

# install.packages("terra")

library(terra)

# BASE R MAPS #### 

name <- LETTERS[1:10]
longitude <- c(-116.7, -120.4, -116.7, -113.5, -115.5,
                            -120.8, -119.5, -113.7, -113.7, -110.7)
latitude <- c(45.3, 42.6, 38.9, 42.1, 35.7, 38.9,
              36.2, 39, 41.6, 36.9)
stations <- cbind(longitude, latitude)

set.seed(0)

precip <- round((runif(length(latitude))*10)^3)

psize <- 1 + precip/500
plot(stations, cex = psize, pch = 20, col = "red")
text(stations, name, pos = 4)

breaks <- c(100, 250, 500, 1000)
legend.psize <- 1 + breaks/500
legend("topright", legend = breaks, pch = 20, pt.cex = legend.psize, col = "red", bg = 'gray')

# Multiple 
lon <- c(-116.8, -114.2, -112.9, -111.9, -114.2, -115.4, -117.7)
lat <- c(41.3, 42.9, 42.4, 39.8, 37.6, 38.3, 37.6)
x <- cbind(lon, lat)
plot(stations, main='Precipitation')

polygon(x, col = "blue", border = 'lightblue')
lines(stations, lwd = 3, col = "red")
points(x, cex = 2, pch = 20)
points(stations, cex = psize, pch = 20, col = "red")

# MAking spatial data  ####

wst <- data.frame(longitude, latitude, name, precip)
wst

## the blue polygon drawn on the map above might represent a state, and a next question might be which of the 10 stations fall within that polygon. And how about any other operation on spatial data, including reading from and writing data to files? 

longitude <- c(-116.7, -120.4, -116.7, -113.5, -115.5, -120.8, -119.5, -113.7, -113.7, -110.7)
latitude <- c(45.3, 42.6, 38.9, 42.1, 35.7, 38.9, 36.2, 39, 41.6, 36.9)
lonlat <- cbind(longitude, latitude)
class(lonlat)

# Using terra, SPatVector 

pts <- vect(lonlat)
class(pts)

geom(pts)

crdref <- "+proj=longlat +datum=WGS84"
pts <- vect(lonlat, crs = crdref)
pts
crs(pts)

# Adding attributes

precipvalues <- runif(nrow(lonlat), min = 0, max = 100)
df <- data.frame(ID=1:nrow(lonlat), precip = precipvalues)

ptv <- vect(lonlat, atts = df, crs = crdref)
class(ptv)

geom(ptv)

# Lines and polygons ####

lon <- c(-116.8, -114.2, -112.9, -111.9, -114.2, -115.4, -117.7)
lat <- c(41.3, 42.9, 42.4, 39.8, 37.6, 38.3, 37.6)
lonlat <- cbind(id=1, part=1, lon, lat)
lonlat

lns <- vect(lonlat, type = "lines", crs = crdref)

lns


pols <- vect(lonlat, type = "polygons", crs = crdref)

pols

plot(pols, las=1)
plot(pols, border = "blue", col = "yellow", lwd = 2, add = TRUE)
points(pts, col = 'red', pch = 20, cex = 2)

# Raster Data ####

# From scratch

r <- rast(ncol = 10, nrow = 10, xmin = -150, xmax = -80, ymin = 20, ymax = 60)

r
values(r) <- runif(ncell(r))
r

plot(r)
# add polygon and points
lon <- c(-116.8, -114.2, -112.9, -111.9, -114.2, -115.4, -117.7)
lat <- c(41.3, 42.9, 42.4, 39.8, 37.6, 38.3, 37.6)
lonlat <- cbind(id=1, part=1, lon, lat)
pts <- vect(lonlat)
pols <- vect(lonlat, type = "polygons", crs="+proj=lonlat +datum=WGS84")
points(pts, col = 'red', pch = 20, cex = 3)
lines(pols, col = 'blue', lwd=2)

# multi-layer object

r2 <- r*r
r3 <- sqrt(r)
s <- c(r, r2, r3)

s
plot(s)

