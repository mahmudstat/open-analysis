# https://www.geeksforgeeks.org/r-language/natural-language-processing-with-r/

## Libs
install.packages(c("NLP", "tm","tokenizers", "udpipe", "text", "textdata", "sentimentr"))

## Create a vector of package names
packages_to_load <- c("NLP", "udpipe", "tm", "tidyverse", "tokenizers", "text", "textdata", "sentimentr")

## Load the packages using lapply
lapply(packages_to_load, library, character.only = TRUE)

## Text Tokenization 

text <- "Natural Language Processing in R is exciting!!"
text_corpus <- Corpus(VectorSource(text)) |> 
  tm_map(content_transformer(tolower)) |>
  tm_map(removePunctuation) |>
  tm_map(removeNumbers) |>
  tm_map(removeWords, stopwords("english")) |>
  tm_map(stripWhitespace)

tokenize_words(text_corpus)

## Part of Speech Tagging

ud_model <- udpipe_download_model(
  language = "english",
  model_dir = getwd())
ud_model <- udpipe_load_model(ud_model$file_model)

senten <- "The quick brown fox jumps over the lazy dog."
udpipe_annot <- udpipe_annotate(ud_model, x = senten)

udpipe_pos <- as.data.frame(udpipe_annot)

udpipe_pos[c("token_id","token","upos")]

## Named Enity Recognition (NER)

## Sentiment Analysis

text <- c("I love R programming!", "I hate bugs in the code.")

sentiment(text)
