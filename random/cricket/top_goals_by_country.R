library(rvest)
library(tidyverse)
library(RColorBrewer)

src <- "https://en.wikipedia.org/wiki/List_of_top_international_men%27s_football_goalscorers_by_country"
top_goals <- html_table(read_html(src), header = TRUE)[[1]]

top_goals$Player=factor(top_goals$Player, 
                        levels = top_goals$Player[order(top_goals$Goals)])

top_goals <- pivot_longer(data = top_goals[1:10, 1:5], cols = c(Goals, Caps))

top_goals %>% ggplot(aes(Player, value, fill = name))+
  geom_bar(stat = "identity", position = "dodge")+
  coord_flip()+
  scale_fill_brewer(palette = "Spectral", name = "Type")+
  labs(title = "Top Goal Scorers by Country", y = "No. of Goals/Caps", x = "Name")+
  geom_text(aes(label=paste(value, name)), 
            vjust=0.5, color="black", hjust = 1.1,
            position = position_dodge(0.9), size=3.5)
  
