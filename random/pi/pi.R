# Chatgpt

leibniz_pi <- function(n) {
  terms <- (-1)^(0:(n - 1)) / (2 * (0:(n - 1)) + 1)
  pi_approx <- sum(terms)
  return(4 * pi_approx)
}

# Example usage:
leibniz_pi(10000)  # The larger n is, the closer the approximation will be to the actual value of π


# mine

pif <- function(n){
  4*sum((-1)^(0:(n-1)) / (2*(0:(n-1) + 1)))
}

pif(10)

# With iNTEGRATion

f <- function(x) exp(-x^2)

int <- integrate(f, 0, 10)

4*(int$value)^2

# Make function

pi_exp_mns_xsq <- function(n){
  f <- function(x) exp(-x^2)
  
  int <- integrate(f, 0, 10)
  
  4*(int$value)^2
}

pi_exp_mns_xsq(25) - pi_exp_mns_xsq(20)

round(pi_exp_mns_xsq(25), 10)
