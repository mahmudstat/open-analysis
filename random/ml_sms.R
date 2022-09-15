
library(tm)
library(SnowballC)

sms_raw <- read.csv("data/mlwrdata/sms_spam.csv", stringsAsFactors = FALSE)
View(sms_raw)

table(sms_raw$type)

sms_corpus <- VCorpus(VectorSource(sms_raw$text))

class(sms_corpus)

sms_corpus[[1]]

lapply(sms_corpus[1:2], as.character)

## Lower case

sms_corpus_clean <- tm_map(sms_corpus,
                           content_transformer(tolower))

sms_corpus_clean <- tm_map(sms_corpus_clean, removeNumbers)

## Remove stewords like to, for etc.

sms_corpus_clean <- tm_map(sms_corpus_clean,
                           removeWords, stopwords())

# Convert to root words

sms_corpus_clean <- tm_map(sms_corpus_clean, stemDocument)

as.character(sms_corpus_clean[[2]]) 
as.character(sms_corpus[[2]])

## Remove additional white spaces

sms_corpus_clean <- tm_map(sms_corpus_clean, stripWhitespace)

sms_dtm <- DocumentTermMatrix(sms_corpus_clean)

sms_train <- sms_dtm[1:4169, ]
sms_test <- sms_dtm[4170:5559,]

## Save types for later use, for matching prediction

sms_train_labels <- sms_raw[1:4169, ]$type

sms_test_labels <- sms_raw[4170:5559, ]$type

prop.table(table(sms_train_labels))

prop.table(table(sms_test_labels))
