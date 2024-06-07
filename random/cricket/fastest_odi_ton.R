library(rvest)
library(tidyverse)
library(RColorBrewer)

src <- "https://www.espncricinfo.com/records/fastest-hundreds-211608"
fastest_odi_ton <- html_table(read_html(src), header = TRUE)[[1]]

# Remove *

mycol <- c("#35ff22", "#5dff32", "#78ff3f", "#8eff4a", "#a2ff54", "#b4ff5e", "#c5ff67", "#d5ff70", "#e5ff79", "#f4ff81")

fastest_odi_ton %>% 
 # mutate(Runs = as.numeric(gsub("\\*", "", Runs))) %>% 
  # Removes stars, not necessary for this plot
  top_n(10, -Balls) %>%  # Select top ten
  mutate(SL = 1:10) %>% # So that one player can be shown multiple times
  mutate(SL = factor(SL, levels = SL[order(-Balls, Player)])) %>% 
  ggplot(aes(SL, Balls, fill = SL))+
  geom_col(width = 0.8, alpha = 0.9)+
  coord_flip()+
  theme(legend.position = "none")+
  geom_text(aes(label=paste(Balls, "")), 
            vjust=1, color="black", hjust = 1,
            position = position_dodge(0.5), size=3.5)+
 scale_fill_manual(values = brewer.pal(n = 10, name = "Paired"))+
#  scale_fill_brewer(palette = "Spectral")+
  labs(title = "Fastest Centuries in Men's ODI Cricket",
       caption = "Source: ESPncricInfo",
       x = "Player")+
  scale_x_discrete(labels = fastest_odi_ton$Player[-fastest_odi_ton$Balls][10:1])

ggsave(filename = "random/cricket/fastest_ton.png")

## Try plotting from raw data

fastest_odi_ton %>% top_n(10, -Balls) %>% 
  ggplot(aes(fct_infreq(Balls), Balls))+
  geom_bar(stat = "identity")+ # the bars are not sorted
  coord_flip() # Repeated lables get added
  
