# Install and load required packages
install.packages(c("cricketdata", "dplyr", "tidyr", "ggplot2", "caret", "randomForest", "xgboost"))
library(cricketdata)
library(dplyr)
library(tidyr)
library(ggplot2)
library(caret)
library(randomForest)
library(xgboost)

# Get data for multiple batsmen (example players)
player_ids <- c(
  "253802",  # Virat Kohli
  "49633",   # Rohit Sharma
  "10617",   # AB de Villiers
  "267192",  # Jos Buttler
  "30176"    # David Warner
)

# Demo

auswt20 <- fetch_cricinfo("T20", "Women", country = "Aust")

jos_butler <- fetch_player_data(267192, "T20", "batting")



# Fetch ball-by-ball data for all players
all_players_data <- data.frame()

for (player_id in player_ids) {
  player_data <- fetch_player_data(activity = "batting", playerid = player_id, matchtype = "t20")
  player_data$player_id <- player_id
  all_players_data <- bind_rows(all_players_data, player_data)
  Sys.sleep(1) # Be polite to the API
}
