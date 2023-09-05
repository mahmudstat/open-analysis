## Find LCM & GCF

# GCF with 2 values

divisor <- function(x){
  y <- seq_len(x)
  # Find x/y with remainder 0
  y[x%%y==0]
}

gcf2 <- function(x,y){
  fx <- divisor(x)
  fy <- divisor(y)
  # Find common factors
  max(intersect(fx,fy))
}

x <- 10
y <- 12

