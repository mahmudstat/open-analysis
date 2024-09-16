library(rvest) # For html_table and read_html
library(tidyverse)
library(RColorBrewer)

# Example

src <- "https://www.timeanddate.com/sun/bangladesh/dhaka?month=1&year=2024"

dhksun <- html_table(read_html(src), header = TRUE)[[2]] 
 
  
# Clean
dhksun <- dhksun[-c(1,2,33), -c(13:26)]

names(dhksun) <- c("Day", "Sunrise", "Sunset", "Daylength", "Diff", 
                   "Astro_Twilight_Start", 
                   "Astro_Twilight_End", "Naut_Twilight_Start", 
                   "Naut_Twilight_End", 
                   "Civil_Twilight_Start", "Civil_Twilight_End", "Solar_Noon")

View(dhksun)



# Now try iterating 

# Next
# Fetch data for any city
# Fetch historical times for a location
# : a variables: City, sun/moon, month, year, day