# Read data from
# https://www.espncricinfo.com/records/highest-career-batting-average-282911

library(rvest)
library(tidyverse)
library(viridis)


batting_src <- "https://www.espncricinfo.com/records/highest-career-batting-average-282911"


odi_batting_avg <- html_table(read_html(batting_src), header = TRUE)[[1]] 

odi_batting_avg %>% top_n(10, Ave) %>% 
  mutate(Player = factor(Player, levels = Player[order(Ave)])) %>% 
  ggplot(aes(Player, Ave, fill = Player))+
  geom_col()+
  coord_flip()+
  theme(legend.position = "none")+
  geom_text(aes(label=paste("Average = ", Ave, " & Runs =", Runs)), 
            vjust=1, color="black", hjust = 1,
            position = position_dodge(0.5), size=3.5)


View(odi_batting_avg)

str(odi_batting_avg)



