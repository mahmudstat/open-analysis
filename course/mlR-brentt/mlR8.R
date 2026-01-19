# Libs
library(tidyverse)
# install.packages("arules")
library(arules)
# Data

grocery <- read_csv("course/mlR-brentt/groceries.csv", col_names = paste0("V", 1:4))

class(grocery)

head(grocery)

# Read as transactions

groceries <- read.transactions("course/mlR-brentt/groceries.csv", sep = ",")

summary(groceries)

View(groceries)

inspect(groceries[1:5])

itemFrequency(groceries[, 1:3])

itemFrequencyPlot(groceries, support = 0.1)

itemFrequencyPlot(groceries, topN = 20)

image(groceries[1:5])

# First model

apriori(groceries)

groc_rules <- apriori(groceries, parameter = list(
  support = 0.006, confidence = 0.25, minlen = 2
))

groc_rules

summary(groc_rules)

# Inspect Rules

inspect(groc_rules[1:10])

# Sort most important rules

inspect(sort(groc_rules, by = "lift")[1:5])

# Actionable Rules

ber <- subset(groc_rules, items %in% c("berries", "yogurt"), lift > 3)

inspect(ber)

