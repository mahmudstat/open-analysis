# libs

library(osmdata)
library(sf)
library(ggplot2)


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

plot(syl_lines["name"]) # Takes

# Add dummy attributes for illustration
set.seed(123)
syl_lines$safety <- sample(c("High", "Medium", "Low"), nrow(syl_lines), replace = TRUE)
syl_lines$jam <- runif(nrow(syl_lines), 0, 1)   # traffic jam index 0–1

library(ggplot2)

# Plot roads colored by safety level
ggplot(syl_lines) +
  geom_sf(aes(color = safety), size = 1) +
  scale_color_manual(values = c("High" = "green", "Medium" = "orange", "Low" = "red")) +
  theme_minimal() +
  ggtitle("Road Safety in Sylhet (Example Data)")

# Motijheel

motijheel <- getbb("Motijheel, Bangladesh")

motijheel_bb <- opq(bbox = motijheel) %>%
  add_osm_feature(key = "highway")

motijheel_lines <- osmdata_sf(motijheel_bb)$osm_lines

set.seed(100)
motijheel_lines$saefty <- sample(c("High", "Low", "Medium"), nrow(motijheel_lines), replace = TRUE)

# Plot roads colored by safety level
ggplot(motijheel_lines) +
  geom_sf(aes(color = saefty), size = 1) +
  scale_color_manual(values = c("High" = "green", "Medium" = "orange", "Low" = "red")) +
  theme_minimal() +
  ggtitle("Road Safety in Motijhel (Simulated Data)")
