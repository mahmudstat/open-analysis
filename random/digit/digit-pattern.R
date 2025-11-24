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

# List
count_iterations <- function(x, target = "6300000100") {
  # Convert to 8-digit string (pad with leading zeros if needed)
  x <- sprintf("%08d", as.numeric(x))
  
  iterations <- 0
  seen <- character()  # Track seen numbers to detect cycles
  path <- character()  # Track the entire path
  
  while(TRUE) {
    # Apply your transformation
    conv <- tabulate(as.numeric(strsplit(as.character(x), "")[[1]]) + 1, nbins = 10)
    next_x <- paste(conv, collapse = "")
    
    iterations <- iterations + 1
    path <- c(path, x)  # Record current number
    
    # Check if we've reached the target
    if (next_x == target) {
      path <- c(path, next_x)  # Include the target in the path
      break
    }
    
    # Check for cycles (repeating pattern)
    if (next_x %in% seen) {
      path <- c(path, next_x)  # Include the cycle start
      break
    }
    
    # Check if we've reached a fixed point (other than target)
    if (next_x == x) {
      path <- c(path, next_x)
      break
    }
    
    seen <- c(seen, x)
    x <- next_x
    
    # Safety limit to prevent infinite loops
    if (iterations > 50) {
      path <- c(path, next_x)
      break
    }
  }
  
  return(list(iterations = iterations, path = path))
}

result <- count_iterations(77464479)
result$iterations  # Number of iterations to reach 6300000100
result$path        # The sequence of numbers encountered

# Print the journey
cat("Path to 6300000100:\n")
for(i in 1:length(result$path)) {
  cat(sprintf("Step %2d: %s\n", i-1, result$path[i]))
}

count_digit(77464479)
count_iterations(77464479)

# Numbers of any digit

count_iterations_any <- function(x, target = "6300000100") {
  # Convert to character and ensure it becomes 10-digit format
  x <- as.character(x)
  
  # Apply transformation to get to 10-digit format immediately
  conv <- tabulate(as.numeric(strsplit(x, "")[[1]]) + 1, nbins = 10)
  x <- paste(conv, collapse = "")
  
  iterations <- 0
  path <- x  # Start with the first 10-digit number
  
  while(x != target) {
    conv <- tabulate(as.numeric(strsplit(x, "")[[1]]) + 1, nbins = 10)
    x <- paste(conv, collapse = "")
    
    iterations <- iterations + 1
    path <- c(path, x)
    
    # Safety limit and cycle detection
    if (iterations > 50 || x %in% path[1:length(path)-1]) {
      break
    }
  }
  
  return(list(iterations = iterations, path = path))
}

count_iterations_any(7)
count_iterations_any(63)

# Exclduing  leading zeros

count_iterations_exclude_0 <- function(x, target = "6300000100") {
  # Remove leading zeros from the original input
  current <- as.character(as.numeric(x))
  path <- current
  
  iterations <- 0
  
  while(current != target) {
    # Count digits in the current number (leading zeros already excluded)
    digits <- as.numeric(strsplit(current, "")[[1]])
    conv <- tabulate(digits + 1, nbins = 10)
    transformed <- paste(conv, collapse = "")
    
    # Remove leading zeros from the transformed result to get next number
    current <- as.character(as.numeric(transformed))
    
    iterations <- iterations + 1
    path <- c(path, transformed, current)  # Show both transformed and cleaned
    
    # Safety limit and cycle detection
    if (iterations > 50 || current %in% path) {
      break
    }
  }
  
  return(list(iterations = iterations, path = path))
}


count_iterations_exclude_0(98)

count_iterations_exclude_0(98)$path

# This does not produce a good thing;

# 98 -> 0000000011 -> 11 -> 0200000000 -> 200000000 -> 8010000000

# actually this process may not give 6300000100. let's just see what we get after 10, 15 iterations. so create a fucntion with 2 args (x, n), where n means path up to n iterations.


count_iterations_n <- function(x, n = 10) {
  current <- as.character(as.numeric(x))
  result <- data.frame(
    iteration = integer(),
    input = character(),
    output = character(),
    converted = character(),
    stringsAsFactors = FALSE
  )
  
  for (i in 1:n) {
    # Count digits in the current number
    digits <- as.numeric(strsplit(current, "")[[1]])
    conv <- tabulate(digits + 1, nbins = 10)
    output <- paste(conv, collapse = "")
    
    # Remove leading zeros to get next input
    converted <- sub("^0+", "", output)
    if (converted == "") converted <- "0"
    
    # Add to result table
    result <- rbind(result, data.frame(
      iteration = i,
      input = current,
      output = output,
      converted = converted
    ))
    
    current <- converted
  }
  
  return(result)
}


result <- count_iterations_n(98, 10)
print(result)

# Stop when 6300000100 is reached

count_iterations_n <- function(x, n = 10) {
  current <- as.character(as.numeric(x))
  result <- data.frame(
    iteration = integer(),
    input = character(),
    output = character(),
    converted = character(),
    stringsAsFactors = FALSE
  )
  
  for (i in 1:n) {
    digits <- as.numeric(strsplit(current, "")[[1]])
    conv <- tabulate(digits + 1, nbins = 10)
    output <- paste(conv, collapse = "")
    
    converted <- sub("^0+", "", output)
    if (converted == "") converted <- "0"
    
    result <- rbind(result, data.frame(
      iteration = i,
      input = current,
      output = output,
      converted = converted
    ))
    
    # Stop if we reach the target
    if (output == "6300000100") {
      break
    }
    
    current <- converted
  }
  
  return(result)
}

result <- count_iterations_n(886)
print(result)


