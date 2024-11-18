# Libs

install.packages("DBI")       # Provides database connectivity
install.packages("RSQLite")   # SQLite specific DBI backend
install.packages("shiny")     # Shiny for creating the app

library(DBI)
library(RSQLite)

# Connect to SQLite (this will create the database file if it doesn't exist)
con <- dbConnect(RSQLite::SQLite(), "shiny/user_account/my_database.sqlite")

# Create a table in the database
dbExecute(con, "
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY,
    username TEXT NOT NULL,
    password TEXT NOT NULL
  )
")

# Insert some sample data into the table
dbExecute(con, "INSERT INTO users (username, password) VALUES ('user1', 'password1')")
dbExecute(con, "INSERT INTO users (username, password) VALUES ('user2', 'password2')")

# Close the connection
dbDisconnect(con)

## Check db View

# List tables
dbListTables(con)

# See table cols
dbListFields(con, "users")
names("users") # Not working

# See table as data.frame

tbl <- dbReadTable(con, "users")

class(tbl) # data.frame
