library(tidygeocoder)

bdacc <- read_csv("random/map/data/bdacc.csv")

View(bdacc)

latlong <- geo(address = bdacc$Address, method = "osm",
               lat = latitude, long = longitude)

View(latlong) # Does not work
# USe https://www.geoapify.com/tools/geocoding-online/

