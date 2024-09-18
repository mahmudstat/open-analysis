
# List of all objects
objs <- mget(ls("package:base"), inherits = TRUE)

# Functions

funs <- Filter(is.function, objs)

# No. of arguments of a function

length(formals(funs$apply))

# No. of variable in second function

formals(funs[[2]]) # see 

length(formals(funs[[2]])) # get n(var)

# How many functions

length(funs)

# Get no. of variables in each function

funvar <- c()

for (n in 1:1270) funvar[n] <- length(formals(funs[[n]]))

head(funvar, 20)

# See function name

# 3rd fun

fun3 <- funs[3]

class(fun3)

names(fun3) 

# Get all names

fun_name <- c()

for (n in 1:1270) fun_name[n] <- names(funs[n]) 

head(fun_name)

# Create a data frame

fundat <- data.frame(
  Name = fun_name,
  nvar <- funvar
)

View(fundat)

# Find fun with max var

fun_name[funvar==max(funvar)]

# It's scan

# See how many vars

funvar[fun_name=="scan"]

## 22
