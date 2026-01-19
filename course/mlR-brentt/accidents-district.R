# Switched to docs/../research

library(arules)

url <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vQ46KApZvLqq8w323sWrUY4IFRphcy8-cMBjrMdhzR2KmbzJIqT8MQsKr5edn3gq5yNimYc1qtli8p-/pub?gid=966425923&single=true&output=csv"
acc_full <- read.csv(url)

write.csv(acc_full, file = "course/mlR-brentt/acc_full.csv")

acc_dist <- subset(acc_full, select = "districts")

# View(acc_dist)

write.table(acc_dist, file = "course/mlR-brentt/acc_dist.csv", 
          row.names = FALSE, col.names = FALSE, quote = FALSE)

acc <- read.transactions("course/mlR-brentt/acc_dist.csv", 
                              sep = ",", skip = 1)

summary(acc)

acc <- read.transactions("course/mlR-brentt/acc_dist.csv", sep = ",")
summary(acc)

inspect(acc[1:10])

itemFrequency(acc[, 1:3])

itemFrequencyPlot(acc, support = 0.1)

itemFrequencyPlot(acc, topN = 10)

image(acc[1:10])

apriori(acc)

acc_rule <- apriori(acc, 
                    parameter = list(
                      support = 0.005, confidence = 0.5, minlen = 2
                    ))
acc_rule

summary(acc_rule)

inspect(acc_rule[1:10])

# Check individual frequencies
itemFrequency(acc)[c("Chuadanga", "Chattogram", "Lakshmipur", "Bogura")]

