library(rvest) # For html_table and read_html
library(tidyverse)
library(RColorBrewer)

# Example

src <- "https://www.timeanddate.com/sun/bangladesh/sylhet?month=2&year=1900"

dhksun <- html_table(read_html(src), header = TRUE)[[2]] 
 
  
# Clean
dhksun <- dhksun[-c(1,2,33), c(1:4)]

names(dhksun) <- c("Day", "Sunrise", "Sunset", "Daylength")

names(dhksun) <- c("Day", "Sunrise", "Sunset", "Daylength", "Diff", 
                   "Astro_Twilight_Start", 
                   "Astro_Twilight_End", "Naut_Twilight_Start", 
                   "Naut_Twilight_End", 
                   "Civil_Twilight_Start", "Civil_Twilight_End", "Solar_Noon")

View(dhksun)

# Extract first 4 

dhksun <- dhksun %>% 
  mutate(Sunrise = substr(Sunrise, start = 1, stop = 5),
         Sunset = substr(Sunset, start = 1, stop = 5))


# Now try iterating 

# # https://www.timeanddate.com/sun/bangladesh/dhaka?month=1&year=2024

object <- "sun"
month <- 2
year <- 2023
country <- "Bangladesh"
city <- "sylhet"
url <- paste0("https://www.timeanddate.com/", 
              object, "/", country, "/", city, "?month=",
              month, "&year=", year)
url

data <- html_table(read_html(url), header = TRUE)[[2]] 

View(data)

# Next
# Fetch data for any city
# Fetch historical times for a location
# : a variables: City, sun/moon, month, year, day