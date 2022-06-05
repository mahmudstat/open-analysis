#Extract daily data from IEDCR
#Dhaka on 9th april
library(rvest)
library(tabulizer)
url <- "https://iedcr.gov.bd/images/files/nCoV/Today_9th.pdf"
corona_dhaka <- html_table()
