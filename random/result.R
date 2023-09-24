# Library

library(tidyverse)
library(RColorBrewer)

excelr <- function(header=TRUE,...) {
  read.table("clipboard",sep="\t",header=header,...)
}

t28b <- excelr()

View(t28b)

t28b %>% pivot_longer(!Subject, names_to = "Grade", values_to = "Count") %>% 
  ggplot(aes(Subject, Count, fill = Grade))+
  scale_fill_brewer(palette = "BuPu", direction = -1)+
  geom_bar(position = "dodge", stat = "identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

