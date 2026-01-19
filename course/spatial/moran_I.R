# https://mgimond.github.io/simple_moransI_example/

library(sf)
library(spdep)
library(tmap)

s <- readRDS(url("https://github.com/mgimond/Data/raw/gh-pages/Exercises/nhme.rds"))

names(s)

s$Income
hist(s$Income, main=NULL)

tm_shape(s) + tm_fill(col="Income", style="quantile", n=8, palette="Greens") +
  tm_legend(outside=TRUE)

nb <- poly2nb(s, queen = TRUE)  

nb[1]

lw <- nb2listw(nb, style="W", zero.policy=TRUE)

lw$weights[1]

inc.lag <- lag.listw(lw, s$Income)
inc.lag

plot(inc.lag ~ s$Income, pch=16, asp=1)
M1 <- lm(inc.lag ~ s$Income)
abline(M1, col="blue")

M1
coef(M1)[2]

# Computing the Moran’s I statistic

I <- moran(s$Income, lw, length(nb), Szero(lw))[1]
I
moran.test(s$Income,lw, alternative="greater")

