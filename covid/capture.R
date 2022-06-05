x <- rnorm(100)
out <- capture.output(x)
cat("Output", out, file = "Output.txt", sep = "\n", append = TRUE)
