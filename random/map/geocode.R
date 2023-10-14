# Lb

library(ggmap)

# Register API

register_google(key = "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")

addresses <- c("Sylhet", "Netrokona")

locations <- geocode(addresses, source = "google", output = "more")

