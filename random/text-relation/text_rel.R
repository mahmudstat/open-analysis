# Src

# http://fredgibbs.net/tutorials/document-similarity-with-r.html

# Libs

library(tm)

corpus <- Corpus(DirSource("random/text-relation/corpus"))

getTransformations()

corpus <- tm_map(corpus, removePunctuation)

class(corpus)

corpus <- tm_map(corpus, removeWords, stopwords("english"))

tdm <- TermDocumentMatrix(corpus)

inspect(tdm)

findFreqTerms(tdm)

?findAssocs

# See word associations with a threshold

findAssocs(tdm, "jump", 0.45)

df <- as.data.frame(inspect(tdm))
df_scale <- scale(df)

dist <- dist(df_scale, method = "euclidean")

fit <- hclust(dist, method = "ward.D")

plot(fit)

# Using adist

text <- c("I love you", "I hate you")
adist(text)

