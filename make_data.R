# Make Data
library(tidyverse)
library(clockplot)

# This data have been collected from Kaggle; it doesn't have any license. 
# https://www.kaggle.com/datasets/abdulqaderasiirii/hospital-patient-data/
hosp <- read.csv("data/hospital.csv")

View(hosp)

hosp <- hosp[, -c(3,4)]

hosp <- hosp[,-7]

names(hosp) <- c("Date", "Revenue", "DocType", "Financial_Class", 
                 "Patient_Type", "Entry_Time", "Completion_Time", "ID")

write.csv(hosp, file = "data/hospital.csv", )

str(hosp)

# Try plotting time

clock_chart_qlt(hosp[1:100,], Entry_Time, Financial_Class)+
  labs(color = "Patient Type")
