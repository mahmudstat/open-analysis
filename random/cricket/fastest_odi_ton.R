library(rvest)
library(tidyverse)

src <- "https://www.espncricinfo.com/records/fastest-hundreds-211608"
fastest_odi_ton <- html_table(read_html(src), header = TRUE)[[1]]

# Remove *

mycol <- c("#7996ff", "#889eff", "#95a6ff", "#a2adff", "#aeb6ff", "#babeff", "#c5c6ff", "#d0ceff", "#dbd7ff", "#e5dfff")

fastest_odi_ton %>% 
 # mutate(Runs = as.numeric(gsub("\\*", "", Runs))) %>% 
  # Removes stars, not necessary for this plot
  top_n(10, -Balls) %>%  # Select top ten
  mutate(SL = 1:10) %>% # So that one player can be shown multiple times
  mutate(SL = factor(SL, levels = SL[order(-Balls)])) %>% 
  ggplot(aes(SL, Balls, fill = SL))+
  geom_col()+
  theme(legend.position = "none")+
  coord_flip()+
  geom_text(aes(label=paste("Off", Balls, "Balls by", Player)), 
            vjust=1, color="black", hjust = 1,
            position = position_dodge(0.5), size=3.5)+
 scale_fill_manual(values = mycol[10:1])+
#  scale_fill_brewer(palette = "Spectral")+
  labs(title = "Fastest Centuries in Men's ODI Cricket",
       caption = "Source: ESPNCricInfo")
