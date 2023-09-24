# Libs

library(tidyverse)

babar_odi <- read_csv('random/cricket/babar_odi.csv')

View(babar_odi)

babar_odi <- babar_odi %>% rename(odisl = ...10) 

babar_odi <- babar_odi %>% mutate(sl = dim(babar_odi)[1]:1)

babar_odi %>% ggplot(aes(x = sl, y = Bat1))+
  geom_bar(stat="identity")

# Replace Not out (*)

## Most ODI WKTS

odi_wkt <- read_csv("random/cricket/odi_most_wkts.csv")

odi_wkt
View(odi_wkt)

odi_wkt$Player=factor(odi_wkt$Player, 
                      levels = odi_wkt$Player[order(odi_wkt$SR)])

odi_wkt %>% filter(Wkts>250) %>% ggplot(aes(Player, SR, fill = Player))+
  geom_line(stat = "identity", group = "1")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  coord_flip()

odi_wkt %>% filter(Wkts>300) %>% ggplot(aes(Player, SR, fill = Player)) +
  geom_text(data = odi_wkt, aes(Player, SR, label = Wkts))+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  coord_flip()
