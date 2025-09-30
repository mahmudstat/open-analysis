
# Create data 
dir.create("course/remote-sensing/data", showWarnings = FALSE)
if (!file.exists("course/remote-sensing/data/rs/samples.rds")) {
  download.file("https://biogeo.ucdavis.edu/data/rspatial/rs.zip", dest = "data/rs.zip
˓→")
  unzip("data/rs.zip", exdir="data")
}

dir.create("course/remote-sensing/data", showWarnings = FALSE)
if (!file.exists("course/remote-sensing/data/rs/samples.rds")) {
  download.file("https://geodata.ucdavis.edu/rspatial/rs.zip", dest = "course/remote-sensing/data/rs.zip")
  unzip("course/remote-sensing/data/rs.zip", exdir="data")
}
