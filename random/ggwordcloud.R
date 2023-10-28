install.packages("ggwordcloud")

library(ggwordcloud)

data("love_words_small")
set.seed(42)
ggplot(love_words_small, aes(label = word, size = speakers)) +
  geom_text_wordcloud() +
  scale_size_area(max_size = 40) +
  theme_minimal()

# 

data("love_words")
set.seed(42)
ggplot(
  love_words,
  aes(
    label = word, size = speakers,
    color = speakers
  )
) +
  geom_text_wordcloud_area(aes(angle = 45 * sample(-2:2, nrow(love_words),
                                                   replace = TRUE,
                                                   prob = c(1, 1, 4, 1, 1)
  )),
  mask = png::readPNG(system.file("img/hearth.png",
                                  package = "ggwordcloud", mustWork = TRUE
  )),
  rm_outside = TRUE
  ) +
  scale_size_area(max_size = 40) +
  theme_minimal() +
  scale_color_gradient(low = "darkred", high = "red")
