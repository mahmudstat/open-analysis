library(tidyverse)
library(RColorBrewer)

dhktmp <- c(18.4, 22.1, 26.4, 28.6, 28.9, 29.1, 28.9, 29.0, 28.7, 27.5, 24.0, 19.9)
syltmp <- c(18.4, 20.8, 24.3, 26.0, 26.8, 27.6, 28.0, 28.2, 27.9, 26.7, 23.3, 19.7)
chttmp <- c(19.8, 22.5, 26.1, 28.2, 28.8, 28.6, 28.1, 28.2, 28.4, 27.8, 24.9, 21.2)
dftmp <- data.frame(Temperature = c(dhktmp, syltmp),
                    Month = factor(rep(month.name, 2), month.name),
                    City = rep(c("Dhaka", "Sylhet"), each = 12))

bdtemp <- data.frame(Temperature = c(dhktmp, syltmp, chttmp),
                     Month = factor(rep(month.name, 3), month.name),
                     City = rep(c("Dhaka", "Sylhet", "Chittagong"), each = 12))

bdtemp %>% ggplot(aes(Month, Temperature, fill = City))+
  geom_bar(stat = "identity", position = "dodge")+
  scale_fill_brewer(palette = "Paired", direction = -1)+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  labs(title = "Montlhy Temperature by City")

# Scatter

mpg %>% ggplot(aes(cty, hwy, colour = drv, size = displ))+
  geom_point()+
  labs(x = "City", y = "Highway", title = "Car Fuel Economy",
       color = "Drive Train", size = "Displacement")+
  scale_color_manual(labels = c("4 Window", "Fron-Wheel", "Rear Wheel"),
                     values = c("DodgerBlue", "SlateBlue", "MediumSeaGreen"))
