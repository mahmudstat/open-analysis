# Write a for loop to calculate the factorial of a number n = 5

# While loop for 5!, 5 factorial

i <- 1
f <- 1 
while (i <=5) {
  f <- i*f
  i <- i + 1
}
f

# For loop 

f <- 1
for (j in 1:5) {
  f <- f*j
}

f

# Given a vector of names names = c("Ali", "Sara", "Tom", "Meera"), convert all names to lowercase using tolower() and add the prefix "Student: " to each name.

names = c("Ali", "Sara", "Tom", "Meera")

nml <- paste0("Student: ", tolower(names))


