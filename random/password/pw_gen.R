# A function to create password of n characters with 




gen_pw <- function (nC = 8, nS = 1, nD = 1, nL = 1, nl = 1){
  S = c("!","'","#","$","%","*","+","-","/",":","<","=",">","?","@","^", 
        "`", "|","~", "`", ".", ";")
  allchr <- c(0:9, letters, LETTERS, S)
  extrachar <- nC - (nS + nD + nL + nl)
  pw <- c(sample(S, nS), 
          sample(0:9, nD),
          sample(LETTERS, nL),
          sample(letters, nl),
          sample(allchr, extrachar))
  paste(sample(pw), collapse = "") # Paste & Randomize order of the characters 
}

gen_pw(3, nS = 0)

pw <- gen_pw (10)

pw


pw = c(); for (i in 1:10) pw[i] = gen_pw(6); pw




