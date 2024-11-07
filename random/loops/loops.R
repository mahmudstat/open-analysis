# While loop to get summation of runif 20

# For loop

x <- c(1,2,6)

for (k in x) print(k^2)

# To store as a vector

y <- c()
n <- seq_along(x)

for (k in n) y[n] <- x^2

# Or directly

x^2

count <- 0
sum <- 0

while(sum<20){
  number <- runif(1)
  sum <- sum + number
  count <- count + 1
  print(paste("Iteration", count, ": ", sum))
}

print(paste("Total Iteration needed: ", count))



