# 
library(jsonlite) # To read json

bd <- fromJSON("data/gadm41_BGD_2.json")

View(bd)

plot(bd)





