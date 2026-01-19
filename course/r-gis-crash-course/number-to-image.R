library(raster)

numb <- raster(resolution=1000, #specify spatial resolution
               xmn=483691, xmx=498329, #specify extent from east to west in metres
               ymn=5449535, ymx=5462381, #specify extent from north to south in metres
               crs=26910) #set projection
numb

values(numb)

ncell(numb)

cell_values <- runif(ncell(numb),min = -1,max=1)
cell_values

values(numb) <- cell_values

plot(numb)

