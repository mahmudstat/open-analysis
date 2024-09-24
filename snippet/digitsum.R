

digitsum2 <- function(x) sum(floor(x / 10^(0:(nchar(x) - 1))) %% 10)

digitsum2(165)

x <- 1100110

y <- sum(as.numeric(unlist(strsplit(as.character(x), ""))))

digits <- as.numeric(unlist(strsplit(as.character(x), "")))

# To binary

pwr <- (length(digits)-1):0

sum(digits*2^pwr)

# Directly

bin2dec <- function(x) {
  digits <- as.numeric(unlist(strsplit(as.character(x), "")))
  pwr <- (length(digits)-1):0
  return(sum(digits*2^pwr))
}

bin2dec(111)


# Binray to 