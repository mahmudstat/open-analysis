library(pacman)

p_load(tidyverse, rvest, RColorBrewer) 

library(rvest)

src <- "https://www.espncricinfo.com/records/largest-margin-of-victory-by-runs-283902"

largest_odi_wins <- html_table(read_html(src), header = TRUE)[[1]] %>% 
  top_n(10, Margin) %>% 
  separate_wider_delim(cols = Margin, names = c("Runs", "resid"), 
                       cols_remove = FALSE, delim = " ") %>% 
  mutate(Runs = as.numeric(Runs))

# A novel chart
largest_odi_wins %>% 
  ggplot(aes(reorder(Ground, Runs), Runs, fill = Opposition))+
  geom_col(width = 0.15, color = "yellow")+
  geom_point(color = "red", size = 5)+
  coord_polar()+
  scale_x_discrete(labels = largest_odi_wins$Winner[reorder(largest_odi_wins$Ground, 
                                                            largest_odi_wins$Runs)])+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  geom_text(aes(label=Runs), 
            vjust=-0.8, color="black", hjust = 0.5, size=3.5)

