library(lubridate)

DOB <- "1993-08-01"

DOB1 <- "1991-02-13"

DOB2 <- "1994-10-1"

DOB3 <- "2021-12-22"

age <- as.period(interval(start = DOB3, end = Sys.Date()))

age




