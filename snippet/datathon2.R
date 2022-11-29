## Libs

install.packages("gmodels")
install.packages("ROCR")
install.packages("adabag")

## Load 
pkg <- c("tidyverse","RColorBrewer", "nnet", "caret", "data.table",
         "C50", "gmodels", "e1071", "ROCR", "mice", "adabag")

lapply(pkg, require, character.only = TRUE)

train <- fread("data/train.csv")
test <- fread("data/test.csv")

View(train)
View(test)

## Check var types

str(train)

## There are some characters. Let's convert them to factors

train <- as.data.frame(unclass(train),stringsAsFactors=TRUE)
 

head(str(train))


sapply(lapply(train, unique), length)

# there are factors with only one category

dim(train)
dim(test)

## Make label a factor

train$label <- as.factor(train$label)

table(train$label)
prop.table(table(train$label))

# There are 83% 0s and 17% 1s. 
# There are some variables with white spaces 

table(train$s54, useNA = "always")
prop.table(table(train$s54))

table(train$label, train$s54)

# Seems white spaces do have some significant impact. Give them a name.


# Add a level "none" for s54

levels(train$s54) <- c(levels(train$s54), "none")
train$s54[train$s54==train$s54[1]] <- "none"
train$s54[is.na(train$s54)] <- "none"

# for test data too
table(test$s54)

levels(test$s54) <- c(levels(test$s54), "none")
test$s54[test$s54==test$s54[1]] <- "none"

# Same thing for s55

levels(train$s55) <- c(levels(train$s55), "none")
train$s55[train$s55==train$s55[1]] <- "none"
train$s55[train$s55==train$s55[2]] <- "none"

## for test set
table(test$s54)
levels(test$s55) <- c(levels(test$s55), "none")
test$s55[test$s55==test$s55[1]] <- "none"

sum(is.na(train$s56))
sum(is.na(test$s53))


# Thus all values in s53, s56, s57, s59 are missing 
# Drop them, for now

train_clean <- subset(train, select = -c(s53, s56, s57, s59))

str(train_clean)

# There are 0,1 in several columns. Make them factors

table(train_clean$s48)
table(train_clean$n12)
table(train_clean$n13)
table(train_clean$s13)

train_clean$s48 <- as.factor(train_clean$s48)
train_clean$n12 <- as.factor(train_clean$n12)
train_clean$s13 <- as.factor(train_clean$s13)
train_clean$n13 <- as.factor(train_clean$n13)

## Do same for test

test$s48 <- as.factor(test$s48)
test$n12 <- as.factor(test$n12)
test$s13 <- as.factor(test$s13)
test$n13 <- as.factor(test$n13)

# drop s53, s56, s57, s59 from test

test <- subset(test, select = -c(s53, s56, s57, s59))

## s52 seems to have same values written in different form

table(train_clean$s52)

# Convert o to 0 and l to 1 (one)

train_clean$s52[train_clean$s52=="l"] <- 1
train_clean$s52[train_clean$s52=="o"] <- 0
table(train_clean$s52)
table(test$s52)
test$s52[test$s52=="l"] <- 1
test$s52[test$s52=="o"] <- 0


# Now they have only 1 and 0. Also make it 2 factors variable. 

train_clean$s52 <- droplevels(train_clean$s52)

# Dropped unused factors 

## The columns s69, s70, and s70 seem to have clumsy values

table(train_clean$s69)
levels(train_clean$s69)

head(train_clean$s69)

# Check s69 relationship with label

chisq.test(train_clean$s69, train_clean$label)
table(train_clean$s69, train_clean$label)


### Unfinished


# Now check the glm model

model1 <- glm(label~., data = train_clean[-1], family = "binomial")

# Now we got a model

mod1_summary <- summary(model1)
mod1_summary

## There are some NA coefficients. could be due to rank.

model1$rank
length(model1$coefficients)

## the rank is less than the number of columns, that says that the 
## information in the NA columns is already being perfectly 
## represented by the other columns
## These features are perfectly correlated with some other feature(s)

# Let's remove them, too and build the model again

train_clean <- subset(train_clean, select = -c(s69, s70, s71))
test <- subset(test, select = -c(s69, s70, s71))

model1 <- glm(label~., data = train_clean[-1], family = "binomial")
mod1_summary <- summary(model1)
mod1_summary

## Check whether ids are unique

length(unique(train_clean$id))

## Yes, they are

# Create tests and train set

partition <- createDataPartition(y=train_clean$label,
                                 p=.6,
                                 list=F)

trn <- train_clean[partition,] # Train set
tst <- train_clean[-partition,-c(29)] # Test set

## Check whether evenly distributed

prop.table(table(trn$label))
prop.table(table(tst$label))

## Well 

# Preserve test set values to match after prediction 
tst_labels <- tst$label

glm1 <- glm(label~., data = trn[-1], family = "binomial")
summary(glm1)
pred1 <- predict(glm1, newdata = tst, type = "response")
head(pred1)
length(pred1)

pred1val <- as.factor(ifelse(pred1<0.5,0,1))

CrossTable(pred1val,tst_labels,
           prop.chisq = FALSE, prop.t = FALSE,
           dnn = c('predicted', 'actual'))

# GLM AUC

pred1_raw <- predict(glm1, newdata = tst, type = "raw")


## Naive Bayes

modnv <- naiveBayes(trn[-1], trn$label)
prednv <- predict(modnv, tst[-c(1,29)])

CrossTable(prednv, tst_labels,
           prop.chisq = FALSE, prop.t = FALSE,
           dnn = c('predicted', 'actual'))

# Get AUC

# First derive raw probabilities
nvpred <- predict(modnv, tst, type = "raw")
head(nvpred)

# Use probabilities of 1

nvpred <- prediction(predictions = nvpred[, 2],
                     labels = tst_labels)

nv_auc <- performance(nvpred, measure = "auc")
unlist(nv_auc@y.values)

## Full train.

## We are omitting the id column, they don't matter

nvfull <- naiveBayes(train_clean[,-1], train_clean$label)
nvfull_pred <- predict(nvfull, test[,-1])

## Now this values must be put in a data frame against test id values

submission <- data.frame(id = test$id, label = nvfull_pred)

write_csv(submission, file = "data/Submission_NA_2e45nx.csv")

## Apply to whole train 

## Get raw probabilities for AUC

nvfull_raw <- predict(nvfull, train_clean[-c(29)], type = "raw")
nvfull_prob1 <- prediction(predictions = nvfull_raw[, 2],
                           labels = train_clean$label)
full_perf <- performance(nvfull_prob1, measure = "auc")
unlist(full_perf@y.values)

## Further cleaning data

str(train_clean)

# Looking at the output, variables s11 to s52 look alright. 

# They just have different categories, and each category has many values.
# No weird string 
# s52 was cleaned

table(train_clean$s54)
train_clean$s54 <- droplevels(train_clean$s54)
train_clean$s55 <- droplevels(train_clean$s55)

# Dropped unused factors. There are interesting patterns. 

table(train_clean$s55)

# Let's make all types of "kk" uppercase, 2k to 2K

trc$s55[trc$s55=="2k"] <- "2K"
trc$s55[trc$s55=="kk"] <- "KK"
trc$s55[trc$s55=="Kk"] <- "KK"
trc$s55[trc$s55=="kK"] <- "KK"
trc$s55 <- droplevels(trc$s55)
table(trc$s55)

## For test

test$s55[test$s55=="2k"] <- "2K"
test$s55[test$s55=="k2"] <- "K2"
test$s55[test$s55=="kk"] <- "KK"
test$s55[test$s55=="Kk"] <- "KK"
test$s55[test$s55=="kK"] <- "KK"
test$s55 <- droplevels(test$s55)
table(test$s55)

# Now should we convert 2K to K2. If we do, we have also to convert 
# in s54: 2a to a2, 2b to b2 etc. We don't know the data, so we skip it for now.

colSums(is.na(trc))

# Now there are no columns with missing values

# Let's fit the model again

trn <- trc[partition,] # Train set
tst <- trc[-partition,-c(29)]

modnv <- naiveBayes(trn[-1], trn$label)
prednv <- predict(modnv, tst[-1])

CrossTable(prednv, tst_labels,
           prop.chisq = FALSE, prop.t = FALSE,
           dnn = c('predicted', 'actual'))

# Get AUC

# First derive raw probabilities
nvpred <- predict(modnv, tst, type = "raw")
head(nvpred)

# Use probabilities of 1

nvpred <- prediction(predictions = nvpred[, 2],
                     labels = tst_labels)

nv_auc <- performance(nvpred, measure = "auc")
unlist(nv_auc@y.values)

## AUC was  before, and now it is 0.8540

## Full 

nvfull <- naiveBayes(trc[,-1], trc$label)
nvfull_pred <- predict(nvfull, test[,-1])

## Now this values must be put in a data frame against test id values

submission <- data.frame(id = test$id, label = nvfull_pred)

write_csv(submission, file = "data/Submission_NA_2e45nx.csv")

## Apply to whole train 

## Get raw probabilities for AUC

nvfull_raw <- predict(nvfull, train_clean[-c(29)], type = "raw")
nvfull_prob1 <- prediction(predictions = nvfull_raw[, 2],
                           labels = train_clean$label)
full_perf <- performance(nvfull_prob1, measure = "auc")
unlist(full_perf@y.values)

## Check redefining 2k to k2
table(trc$s54)

str(trc)

# Check whether integers/numeric are really such

sapply(lapply(train, unique), length)

# n3 has only 10 unique values, n15 has 7

table(trc$n3)
table(trc$n15)

# These two can be converted to factors

trc$n3 <- as.factor(trc$n3)
trc$n15 <- as.factor(trc$n15)
test$n3 <- as.factor(test$n3)
test$n15 <- as.factor(test$n15)

# Let's fit the model again

trn <- trc[partition,] # Train set
tst <- trc[-partition,-c(29)]

modnv <- naiveBayes(trn[-1], trn$label)
prednv <- predict(modnv, tst[-1])

# Get AUC

# First derive raw probabilities
nvpred <- predict(modnv, tst, type = "raw")

# Use probabilities of 1

nvpred <- prediction(predictions = nvpred[, 2],
                     labels = tst_labels)

nv_auc <- performance(nvpred, measure = "auc")
unlist(nv_auc@y.values)

## Full model

nvfull <- naiveBayes(trc[,-1], trc$label)
nvfull_pred <- predict(nvfull, test[,-1])

submission <- data.frame(id = test$id, label = nvfull_pred)

write_csv(submission, file = "data/2/Submission_NA_2e45nx.csv")

## Apply to whole train

nvfull_raw <- predict(nvfull, trc[-c(29)], type = "raw")
nvfull_prob1 <- prediction(predictions = nvfull_raw[, 2],
                           labels = train_clean$label)
full_perf <- performance(nvfull_prob1, measure = "auc")
unlist(full_perf@y.values)

View(trc)

## Check the effect of numeric variables

nums <- unlist(lapply(trc, is.numeric), use.names = FALSE) 
trc_num <- trc[ , nums]
trc_num$label <- trc$label
str(trc_num)

trc_num %>% ggplot(aes(n11, color = label))+
  geom_boxplot()
trc_num %>% ggplot(aes(n14, color = label))+
  geom_boxplot()

## Looking at all others boxplots, it seems, they don't affect label much
## there's a big intersection between 0s and 1s 
## For n11, both label category have almost perfect correlation

par(mfrow=c(1,2))
hist(trc_num$n11[trc$label==0], xlab = "n11, where label=0")
hist(trc_num$n11[trc$label==1], xlab = "n11, where label=1")

# Both are uniformly distributed, so don't bear predictive significance

hist(trc_num$n14[trc$label==0], xlab = "n11, where label=0")
hist(trc_num$n14[trc$label==1], xlab = "n11, where label=1")

# The same holds for n14. Let's remove all numeric

trc_wo_num <- trc %>% select_if(negate(is.numeric))

str(trc_wo_num)

## From test too

tst_wo_num <- test %>% select_if(negate(is.numeric))
str(tst_wo_num)

str(test)

# Previously test chr columns were not converted to factos. now do it.

test <- as.data.frame(unclass(test),stringsAsFactors=TRUE)

str(test)

# Now build model on without numeric

trn <- trc_wo_num[partition,] # Train set
tst <- trc_wo_num[-partition,-c(18)]

modnv <- naiveBayes(trn[-1], trn$label)
prednv <- predict(modnv, tst[-1])

# Get AUC

# First derive raw probabilities
nvpred <- predict(modnv, tst, type = "raw")

# Use probabilities of 1

nvpred <- prediction(predictions = nvpred[, 2],
                     labels = tst_labels)

nv_auc <- performance(nvpred, measure = "auc")
unlist(nv_auc@y.values)


# Seems auc has not improved. 

# Apply pca 

trc_pca <- prcomp(trc_num[,-12], center = TRUE,scale. = TRUE)

summary(trc_pca)

## PCA does not help reduce variables. to get 94% variation in y, we need 7 PCs

## Try removing only n11 and n14

trc2 <- subset(trc, select = -c(id, n11,n14))
tst2 <- subset(test, select = -c(id, n11,n14))

trn <- trc2[partition,] # Train set
tst <- trc2[-partition,]
tst_labels <- tst$label
tst <- subset(tst, select = -c(label))

modnv <- naiveBayes(trn[-1], trn$label)
prednv <- predict(modnv, tst[-1])

# Get AUC

# First derive raw probabilities
nvpred <- predict(modnv, tst, type = "raw")

# Use probabilities of 1

nvpred <- prediction(predictions = nvpred[, 2],
                     labels = tst_labels)

nv_auc <- performance(nvpred, measure = "auc")
unlist(nv_auc@y.values)

# We get 0.8540552. Not an improvement. Try replacing 2as to a2

## Using caret

modelLookup("nb")

## Caret is skipped due to device hang

# Find columns with missing values

names(which(colSums(is.na(trc)) > 0))
names(which(colSums(is.na(test)) > 0))

## mice took too long time. 

sum(is.na(trc$s54))

# There are only 364 missing rows. Let's remove them.

trc2 <- trc2 %>% drop_na()

ada <- boosting(label ~ ., data = trn)
ada_pred <- predict(ada, tst)

ada_values <- ada_pred$class

ada_pred$confusion

# AUC

nvpred <- prediction(predictions = ada_pred$prob[, 2],
                     labels = tst_labels)

nv_auc <- performance(nvpred, measure = "auc")
unlist(nv_auc@y.values)

## Full model

ada_full <- boosting(label ~ ., data = trc2)

ada_pred <- predict(ada_full, tst2)

ada_values <- ada_pred$class

submission <- data.frame(id = test$id, label = ada_values)

write_csv(submission, file = "data/3/Submission_NA_2e45nx.csv")
