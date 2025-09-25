library(ggplot2)

polygon_border <- rbind(c(1,5), c(2,2), c(4,1), c(4,4), c(1,5))
polygon_hole <- rbind(c(2,4), c(3,4), c(3,3), c(2,3), c(2,4))

border_df <- as.data.frame(polygon_border)
hole_df <- as.data.frame(polygon_hole)

ggplot() +
  geom_polygon(data = border_df, aes(x = V1, y = V2), 
               fill = "lightblue", color = "darkblue") +
  geom_polygon(data = hole_df, aes(x = V1, y = V2), 
               fill = "black", color = "darkblue") +
  labs(title = "Polygon with Hole", x = "X", y = "Y") +
  coord_equal()
