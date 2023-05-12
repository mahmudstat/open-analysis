# Libraries

library(tidyverse)

# Data

mominul_test <- read_csv("random/cricket/mominul_test_runs.csv")

View(mominul_test_innings)

mominul_test <- mominul_test %>% mutate(Total_run = Bat1+Bat2, )

mominul_test_innings <- pivot_longer(data = mominul_test,
                                     cols = starts_with("Ba"), 
                                     names_to = "Innings", 
                                     values_to = "Run")
mominul_test_innings %>% ggplot(aes(Match, Run, color = Run))+
  geom_point()+geom_line()+
  theme(legend.position = "top")

