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
  "308967",  # Jos Buttler
  "30176"    # David Warner
)

# Demo

auswt20 <- fetch_cricinfo("T20", "Women", country = "Aust")

jos_butler <- fetch_player_data(308967, "T20", "batting")

View(jos_butler)

# Fetch ball-by-ball data for all players
all_players_data <- data.frame()

for (player_id in player_ids) {
  player_data <- fetch_player_data(activity = "batting", playerid = player_id, matchtype = "t20")
  player_data$player_id <- player_id
  all_players_data <- bind_rows(all_players_data, player_data)
  Sys.sleep(1) # Be polite to the API
}

bdmush <- fetch_player_data(56029, "T20", "batting") |> 
  mutate(player = "Mushfiq", BF = as.integer(BF)) |> 
  select(player, everything())
bdlitton <- fetch_player_data(536936, "T20", "batting") |> 
  mutate(player = "Litton", BF = as.integer(BF)) |> 
  select(player, everything())
bdmahmud <- fetch_player_data(56025, "T20", "batting")|> 
  mutate(player = "Mahmudulah", BF = as.integer(BF)) |> 
  select(player, everything())

# View(bdbatterst20)

bdbatterst20 <-bind_rows(bdmahmud, bdmush, bdlitton)

# Train Mushfiq ####

# Remove NA# 

bdmush <- bdmush |> 
  filter(!is.na(BF))

# Choose factors

# Opposition, Ground, Pos, 


mushmod <- lm(data = bdmush, BF ~ Opposition+Ground+Pos)

summary(mushmod)
