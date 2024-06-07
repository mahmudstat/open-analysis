library(pacman)

p_load(tidyverse, patchwork)

days <- c("Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri")
count <- sample(20,7)

dfweek <- tibble(days, count) %>% mutate(days = factor(days, levels = days))

rose <- dfweek %>% ggplot(aes(days, count, fill = days))+
  geom_col()+
  coord_polar()+
  coord_polar("x", start = 270)+
  theme(axis.ticks.x=element_blank(), 
        axis.text.y=element_blank(),  
        axis.ticks.y=element_blank(),
        axis.title = element_blank(),
        legend.position = "none")