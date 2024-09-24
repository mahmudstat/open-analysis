

digitsum2 <- function(x) sum(floor(x / 10^(0:(nchar(x) - 1))) %% 10)

digitsum2(165)

