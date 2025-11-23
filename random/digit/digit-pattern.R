num <- sample(10^8:10^8+500, 1)

num <- 77464479

freq_vector <- tabulate(as.numeric(strsplit(as.character(num), "")[[1]]) + 1, nbins = 10)

freq_vector

count_digit <- function(x){
  conv <- tabulate(as.numeric(strsplit(as.character(x), "")[[1]]) + 1, nbins = 10)
  as.character(paste(conv, collapse = ""))
}

it1 <- count_digit(num)
it2 <- count_digit(it1)
it3 <- count_digit(it2)
it4 <- count_digit(it3)

it4
cont_iter <- count_digit(it4)

cont_iter

# practice

x = 8009
# convert to 8-digit
sprintf("%08d", as.numeric(x))

# The function to count iteration to reach 6300000100

count_iterations <- function(x) {
  # Convert to 8-digit string (pad with leading zeros if needed)
  x <- sprintf("%08d", as.numeric(x))
  
  iterations <- 0
  seen <- character()  # Track seen numbers to detect cycles
  
  while(TRUE) {
    # Apply your transformation
    conv <- tabulate(as.numeric(strsplit(as.character(x), "")[[1]]) + 1, nbins = 10)
    next_x <- paste(conv, collapse = "")
    
    iterations <- iterations + 1
    
    # Check for convergence (repeating pattern)
    if (next_x %in% seen) {
      break
    }
    
    # Check if we've reached the fixed point
    if (next_x == x) {
      break
    }
    
    seen <- c(seen, x)
    x <- next_x
  }
  
  return(iterations)
}

# Test with your number that leads to 6300000100
count_iterations(77464479)
# Should return the number of iterations needed

# Test with other numbers
count_iterations(12345678)
count_iterations(99999999)
count_iterations(65484561)

count_digit(7101001000)
