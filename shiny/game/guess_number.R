library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Number Guessing Game"),
  sidebarLayout(
    sidebarPanel(
      numericInput("guess", "Enter your guess (1-100):", value = NULL, min = 1, max = 100),
      actionButton("submit", "Submit Guess"),
      verbatimTextOutput("feedback"),
      textOutput("attempts")
    ),
    mainPanel(
      textOutput("instructions"),
      actionButton("new_game", "Start New Game")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  # Reactive values to store game state
  game_state <- reactiveValues(secret_number = sample(1:100, 1), attempts = 0)
  
  # Instructions output
  output$instructions <- renderText({
    "Try to guess the number I'm thinking of between 1 and 100!"
  })
  
  # Reset game on new game button click
  observeEvent(input$new_game, {
    game_state$secret_number <- sample(1:100, 1)
    game_state$attempts <- 0
    output$feedback <- renderText("")
    output$attempts <- renderText("")
  })
  
  # Handle guessing logic
  observeEvent(input$submit, {
    req(input$guess)  # Ensure the guess is provided
    game_state$attempts <- game_state$attempts + 1
    guess <- input$guess
    
    # Determine feedback based on the guess
    if (guess < game_state$secret_number) {
      output$feedback <- renderText("The number is greater!")
    } else if (guess > game_state$secret_number) {
      output$feedback <- renderText("The number is smaller!")
    } else {
      output$feedback <- renderText("Congratulations! You've guessed the number!")
    }
    output$attempts <- renderText(paste("Attempts:", game_state$attempts))
  })
}

# Run the app
shinyApp(ui, server)
