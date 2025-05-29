

dbinom(0, 10, 0.3)

pbin <- dbinom(0:10, 10, 0.3)

sum(dbinom(0:10, 10, 0.3))


plot(0:10, pbin*100, type = "h")

accu_binom <- function(n, p){
  pbin <- dbinom(0:n, n, p)
  print(pbin)
}

acb <- accu_binom(10, 0.5)

plot(0:10, acb*100, type = "l")


