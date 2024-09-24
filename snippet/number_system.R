# Binray to Decimal

bin2dec <- function(x) {
  digits <- as.numeric(unlist(strsplit(as.character(x), "")))
  pwr <- (length(digits)-1):0
  return(sum(digits*2^pwr))
}

bin2dec(1011110)


x <- 12


dec2bin
