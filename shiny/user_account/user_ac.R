# Load libraries
library(shiny)
library(shinyjs)
library(digest)

# A simple user database for demo purposes
users_db <- data.frame(
  username = character(),
  password = character(),
  stringsAsFactors = FALSE
)

# UI
ui <- fluidPage(
  useShinyjs(),
  titlePanel("Create Account or Login"),
  
  # Login and registration forms
  tabsetPanel(
    tabPanel("Login", 
             textInput("login_user", "Username"),
             passwordInput("login_pass", "Password"),
             actionButton("login_btn", "Login"),
             textOutput("login_status")),
    
    tabPanel("Register",
             textInput("reg_user", "Username"),
             passwordInput("reg_pass", "Password"),
             actionButton("reg_btn", "Register"),
             textOutput("reg_status"))
  ),
  
  # After login: Profile input for CV
  hidden(div(id = "profile_section",
             h3("Enter your profile details"),
             textInput("name", "Name"),
             textInput("email", "Email"),
             textAreaInput("education", "Education", ""),
             textAreaInput("experience", "Experience", ""),
             textAreaInput("skills", "Skills", ""),
             actionButton("submit_profile", "Submit"),
             textOutput("profile_saved"))),
  
  # Show CV
  hidden(div(id = "cv_section",
             h3("Your CV"),
             verbatimTextOutput("cv_display")))
)

# Server
server <- function(input, output, session) {
  
  # Reactive value to store user login state
  user <- reactiveValues(logged_in = FALSE, current_user = NULL)
  
  # Registration process
  observeEvent(input$reg_btn, {
    if (input$reg_user == "" || input$reg_pass == "") {
      output$reg_status <- renderText("Please enter both username and password.")
    } else if (input$reg_user %in% users_db$username) {
      output$reg_status <- renderText("Username already exists. Try a different one.")
    } else {
      hashed_pass <- digest(input$reg_pass, algo = "sha256")
      users_db <<- rbind(users_db, data.frame(username = input$reg_user, password = hashed_pass))
      output$reg_status <- renderText("Registration successful! You can now login.")
    }
  })
  
  # Login process
  observeEvent(input$login_btn, {
    if (input$login_user == "" || input$login_pass == "") {
      output$login_status <- renderText("Please enter both username and password.")
    } else {
      hashed_pass <- digest(input$login_pass, algo = "sha256")
      user_row <- subset(users_db, username == input$login_user & password == hashed_pass)
      if (nrow(user_row) == 1) {
        user$logged_in <- TRUE
        user$current_user <- input$login_user
        output$login_status <- renderText(paste("Welcome,", input$login_user))
        show("profile_section")
        hide("cv_section")
      } else {
        output$login_status <- renderText("Invalid username or password.")
      }
    }
  })
  
  # Save profile info
  observeEvent(input$submit_profile, {
    if (user$logged_in) {
      profile_data <- paste("Name: ", input$name, "\nEmail: ", input$email, "\nEducation: ", input$education, "\nExperience: ", input$experience, "\nSkills: ", input$skills)
      output$cv_display <- renderText(profile_data)
      output$profile_saved <- renderText("Profile saved! You can now view your CV.")
      show("cv_section")
    }
  })
}

# Run the app
shinyApp(ui, server)
