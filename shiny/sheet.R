# Library

install.packages('googlesheets4')

library(googlesheets4)

dat <- read_sheet(ss = "282569801")
