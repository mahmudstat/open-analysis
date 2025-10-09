if (!require("rspat")) remotes::install_github("rspatial/rspat")

library(rspat)

h <- rspat::spat_data('houses2000')

dim(h)
names(h)
hb <- buffer(h, 1)

values(hb) <- values(h)

View(hb)

hha <- aggregate(hb, "County")
