library(pacman)

p_load(tidyverse)

overs <- tibble(over =1:50,
                run = sample(0:12, 50, replace = TRUE),
                wicket = sample(c(sample(1,9, replace = T), sample(0,41, replace = T)),50),
                cumr = cumsum(run)
                )
View(overs)

overs %>% ggplot(aes(over, run, fill = run))+
  geom_col()+
 # geom_line()+
  geom_point(data = overs %>% filter(wicket==1), color = "red", size = 3)+
  scale_fill_gradient(high = "darkgreen", low = "red")
