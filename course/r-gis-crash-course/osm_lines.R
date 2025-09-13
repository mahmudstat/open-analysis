# libs

library(osmdata)
library(sf)

# By AREA ####
q <- opq("Farmgate, Bangladesh") %>% 
  add_osm_feature(key = "highway")

roads <- osmdata_sf(q)

class(roads)

road_lines <- roads$osm_lines
class(road_lines)
head(road_lines)

View(road_lines)

road_lines$osm_id[1]
plot(st_geometry(road_lines), col = "blue", lwd = 2)

plot(road_lines["name"], lwd = 2)

# ADD CRITERIA ####

syl <- getbb("Sylhet, Bangladesh")

sylbb <- opq(bbox = syl) %>% 
  add_osm_feature(key = "highway") # Large size

syl_lines <- osmdata_sf(sylbb)$osm_lines

plot(syl_lines)
