## ML model: Decision Tree

# Libs

install.packages("C50")
install.packages("gmodels")

library(data.table)


pkg <- c("tidyverse","RColorBrewer", "nnet", "caret", "data.table", "C50",
         "gmodels")
lapply(pkg, require, character.only = TRUE)

## Data

credit <- fread("data/mlwrdata/credit.csv")

class(credit)
View(credit)

train_sample <- sample(1000, 900)
credit_train <- credit[train_sample, ]
credit_test <- credit[-train_sample, ]

prop.table(table(credit_train$default))
prop.table(table(credit_test$default))

# Convert outcome to factors

credit_train <- as.data.frame(unclass(credit_train),stringsAsFactors=TRUE)

## Train 

credit_model <- C5.0(credit_train[-17], credit_train$default)

credit_pred <- predict(credit_model, credit_test)

CrossTable(credit_test$default, credit_pred,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual default', 'predicted default'))

