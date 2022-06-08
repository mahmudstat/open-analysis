
library(tidyverse)
gadm36_BGD_4_sp <- readRDS("data/gadm36_BGD_4_sp.rds")

View(gadm36_BGD_4_sp)

class(gadm36_BGD_4_sp) 

df <- data.frame(x=letters, y= LETTERS)
sub('R','R language',df$y) # sub works with vectors, not data frame

View(gadm36_BGD_4_sp@data)

