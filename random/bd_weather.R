#Libs

library(tidyverse)
library(RColorBrewer)

bd_division_weather <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vQ6g3f0KJDt19di48bx55E_mTZZAtrop8psWbIUk4hD0YiVO4ivQHUw5yA3wTgb2_ddAn72Hut_GkuR/pub?output=csv")

View(bd_division_weather)

# Rename columns

bd_division_weather %>% group_by(City) %>% 
  summarise(TotRain = sum(Rainfall_mm)) %>% 
  mutate(City = factor(City, levels = City[order(TotRain)])) %>% 
  ggplot(aes(City, TotRain, fill = City))+
  scale_fill_brewer(palette = "PiYG")+
  geom_bar(stat = "identity")+
  coord_flip()+
  theme(legend.position = "none",
        axis.title = element_text(face="bold"))+
  geom_text(aes(label=TotRain), vjust=1, color="black", hjust = 1,
            position = position_dodge(0.5), size=4)+
  labs(y = "Rainfall", 
       x = "City", 
       title = "Yearly Rainfall (mm) in Bangladesh Divisional Cities")

# Rainfall Map

# Divisional Map: Download from the following link 
# https://gadm.org/download_country_v3.html
# For divisions: BGD_1_sp
# For districts: BGD_2_sp

bd_div <- readRDS("data/gadm36_BGD_1_sp.rds")

dim(bd_div)

View(bd_div)

# Add rain data

# Total Rainfall
TotR <- bd_division_weather %>% group_by(City) %>% 
  summarise(TotRain = sum(Rainfall_mm))

bd_div$Rain <- TotR$TotRain[c(1:4, 6:8)]

spplot(bd_div, "Rain", col.regions = brewer.pal(n = 7, name = "YlGn"),
       cuts=6, col='transparent', main='Rainfall in Bnagladesh Cities',
       sub='Source: WMO & BMD', scales=list(draw=T))

# Fortified data

bd_div_gg <- fortify(bd_div)



