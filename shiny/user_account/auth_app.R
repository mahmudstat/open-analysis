library(shiny)
library(DBI)
library(RSQLite)

# Connect to the SQLite database
con <- dbConnect(SQLite(), "user_db.sqlite")

# Ensure the users table exists (create if not)
dbExecute(con, "CREATE TABLE IF NOT EXISTS users (username TEXT PRIMARY KEY, password TEXT)")

# UI
ui <- fluidPage(
  titlePanel("Shiny App with User Authentication"),
  
  sidebarLayout(
    sidebarPanel(
      # Sign up inputs
      conditionalPanel(
        condition = "output.loggedIn == false",
        textInput("signup_username", "Sign Up - Username"),
        passwordInput("signup_password", "Sign Up - Password"),
        actionButton("signup", "Sign Up")
      ),
      
      # Login inputs
      conditionalPanel(
        condition = "output.loggedIn == false",
        textInput("username", "Login - Username"),
        passwordInput("password", "Login - Password"),
        actionButton("login", "Login")
      ),
      
      # Logout button
      conditionalPanel(
        condition = "output.loggedIn == true",
        actionButton("logout", "Logout")
      )
    ),
    
    mainPanel(
      uiOutput("content")
    )
  )
)

# Server logic
server <- function(input, output, session) {
  # Reactive values to store session state
  user_session <- reactiveValues(loggedIn = FALSE, username = NULL)
  
  # Sign-up process
  observeEvent(input$signup, {
    req(input$signup_username, input$signup_password)
    
    # Check if the username already exists
    existing_user <- dbGetQuery(con, "SELECT * FROM users WHERE username = ?", params = list(input$signup_username))
    if (nrow(existing_user) > 0) {
      showNotification("Username already exists. Please choose another.", type = "error")
    } else {
      dbExecute(con, "INSERT INTO users (username, password) VALUES (?, ?)", params = list(input$signup_username, input$signup_password))
      showNotification("Sign up successful! You can now log in.", type = "message")
    }
  })
  
  # Login process
  observeEvent(input$login, {
    req(input$username, input$password)
    
    # Check credentials
    user <- dbGetQuery(con, "SELECT * FROM users WHERE username = ? AND password = ?", params = list(input$username, input$password))
    if (nrow(user) == 1) {
      user_session$loggedIn <- TRUE
      user_session$username <- input$username
      showNotification("Login successful!", type = "message")
    } else {
      showNotification("Invalid username or password. Please try again.", type = "error")
    }
  })
  
  # Logout process
  observeEvent(input$logout, {
    user_session$loggedIn <- FALSE
    user_session$username <- NULL
    showNotification("You have logged out.", type = "message")
  })
  
  # Conditional rendering of content based on login status
  output$content <- renderUI({
    if (user_session$loggedIn) {
      tagList(
        h3(paste("Welcome,", user_session$username)),
        p("This content is available only to logged-in users.")
      )
    } else {
      h3("Please log in or sign up to access this content.")
    }
  })
  
  # Expose loggedIn status for conditional UI rendering
  output$loggedIn <- reactive({
    user_session$loggedIn
  })
  outputOptions(output, "loggedIn", suspendWhenHidden = FALSE)
}

# Close the database connection when the app stops
onStop(function() {
  dbDisconnect(con)
})

# Run the application
shinyApp(ui = ui, server = server)
