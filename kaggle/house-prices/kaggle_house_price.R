## Libraries

library(data.table)

## Data

hp_train <- fread(file = "kaggle/house-prices/data/train.csv", 
                  stringsAsFactors = TRUE)

View(hp_train)

summary(hp_train$SalePrice)

colnames(hp_train)

str(hp_train)

table(hp_train$MSZoning)

hp_lm_all <- lm(SalePrice ~ ., data=hp_train)

## Errors. Some factor have only one unique value

sapply(lapply(hp_train, unique), length)


