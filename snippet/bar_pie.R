library(tidyverse)

# Rose chart
piedf <- tibble(value = sample(30:50, 8),
                cat = paste(LETTERS[1:8], "Group")) %>% 
  mutate(cat = factor(cat, level = cat[order(value)]))

piedf %>% ggplot(aes(cat, value, fill = cat))+
  geom_bar(stat = "identity")+
  coord_flip()+
  coord_polar("x", start = 270)+
  theme(axis.ticks.x=element_blank(), 
        axis.text.y=element_blank(),  
        axis.ticks.y=element_blank(),
        axis.title = element_blank(),
        legend.position = "none")

# This also looks nice. Just order by freq 

# Simple bar

piedf %>% ggplot(aes(x = "", y = value, fill = cat))+
  geom_col()+
  coord_polar("y")+
  geom_text(aes(label = paste(round(100*value/sum(value),0), "%")),
            position = position_stack(vjust = 0.5))+
  theme(axis.ticks.x=element_blank(), 
        axis.text.y=element_blank(),  
        axis.ticks.y=element_blank(),
        axis.title = element_blank(),
        legend.position = "none")
  
