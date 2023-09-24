library(tidyverse)

Team <- c("AFG", "AUS", "BAN", "ENG", "IND", "IRE", "NZ", "PAK", "SA", "SL", "WI", "ZIM")
Lost <- c(1, 224, 86, 302, 165, 3, 172, 128, 144, 108, 195, 68)
Won <- c(2, 388, 13, 368, 152, 0, 98, 136, 164, 91, 173, 12) 
test_win <- tibble(Team, Won, Lost)

test_win %>% ggplot(aes(Won, Lost, color=Team)) +
  geom_point(size=4, pch= 19)+
  theme(legend.position = "none")+
  labs(title = "Win-Loss Ratio of Test-Playing Team") 


test_win %>% ggplot(aes(Won, Lost, color=Team)) +
  geom_text(data = test_win, aes(x=Won, y = Lost, label = Team))+
  theme(legend.position = "none")+
  labs(title = "Win-Loss Ratio of Test-Playing Team")
