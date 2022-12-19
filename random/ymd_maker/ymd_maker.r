times = c(31,28,31,30,31,30,31,31,30,31,30,31)

ymd <- data.frame(Month = rep(1:12, times = times))

View(ymd)

Day <- c()

for (i in times) {
  Day = c(Day, 1:i)
}

ymd$Day = Day

write.csv(ymd, "random/ymd_maker/ymd.csv")
