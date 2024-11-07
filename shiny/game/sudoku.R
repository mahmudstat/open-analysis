library(shiny)

# Function to generate a complete 6x6 Sudoku grid
generate_full_grid <- function() {
  base <- matrix(c(
    1, 2, 3, 4, 5, 6,
    4, 5, 6, 1, 2, 3,
    2, 3, 4, 5, 6, 1,
    5, 6, 1, 2, 3, 4,
    3, 4, 5, 6, 1, 2,
    6, 1, 2, 3, 4, 5
  ), nrow = 6, byrow = TRUE)
  
  # Shuffle rows within blocks
  row_blocks <- split(base, rep(1:3, each = 2))  # Split into 3 blocks of 2 rows
  shuffled_rows <- do.call(rbind, lapply(row_blocks, function(block) block[sample(nrow(block)), ]))
  )

# Shuffle columns within blocks
col_blocks <- split(t(shuffled_rows), rep(1:2, each = 3))  # Split into 2 blocks of 3 columns
shuffled_cols <- do.call(rbind, lapply(col_blocks, function(block) block[sample(nrow(block)), ]))
)

# Transpose back to original orientation
final_grid <- t(shuffled_cols)
return(final_grid)
}

# Function to create a Sudoku puzzle by removing elements
create_puzzle <- function(grid) {
  puzzle <- grid
  # Randomly remove numbers (adjust the difficulty)
  cells_to_remove <- sample(1:36, 12)  # Remove 12 cells
  puzzle[cells_to_remove] <- NA
  return(puzzle)
}

# Function to validate the Sudoku solution
check_solution <- function(user_grid) {
  # Check each row and column for duplicates
  for (i in 1:6) {
    row_vals <- na.omit(user_grid[i, ])
    if (length(row_vals) != length(unique(row_vals))) return(FALSE)
    
    col_vals <- na.omit(user_grid[, i])
    if (length(col_vals) != length(unique(col_vals))) return(FALSE)
  }
  
  # Check each 2x3 subgrid for duplicates
  for (row in seq(1, 5, by = 2)) {
    for (col in seq(1, 5, by = 3)) {
      block <- user_grid[row:(row + 1), col:(col + 2)]
      block_vals <- na.omit(as.vector(block))
      if (length(block_vals) != length(unique(block_vals))) return(FALSE)
    }
  }
  
  return(TRUE)
}

# Define UI
ui <- fluidPage(
  titlePanel("6x6 Sudoku Game"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Rules"),
      tags$ul(
        tags$li("Each row must contain the digits from 1 to 6 without repetition."),
        tags$li("Each column must also contain the digits from 1 to 6 without repetition."),
        tags$li("Each 2x3 subgrid must contain the digits from 1 to 6."),
        tags$li("Fill the empty cells using logic—no guessing required!")
      ),
      actionButton("check", "Check Solution"),
      actionButton("new_game", "New Game")
    ),
    mainPanel(
      uiOutput("sudoku_grid"),
      verbatimTextOutput("result")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  # Reactive value to store the Sudoku grid
  sudoku_grid <- reactiveVal(create_puzzle(generate_full_grid()))
  
  # Render the Sudoku grid as input fields
  output$sudoku_grid <- renderUI({
    grid <- sudoku_grid()
    
    grid_table <- lapply(1:6, function(i) {
      row_inputs <- lapply(1:6, function(j) {
        if (!is.na(grid[i, j])) {
          tags$input(type = "text", value = grid[i, j], style = "width: 50px; background-color: #f0f0f0; border: none; text-align: center;", readonly = TRUE)
        } else {
          textInput(paste0("cell_", i, "_", j), label = NULL, value = "", width = '50px', placeholder = "")
        }
      })
      tags$div(style = "display: flex; justify-content: center; gap: 5px;", row_inputs)
    })
    
    do.call(tagList, grid_table)
  })
  
  # New game button
  observeEvent(input$new_game, {
    new_puzzle <- create_puzzle(generate_full_grid())
    sudoku_grid(new_puzzle)
    output$result <- renderText("")
  })
  
  # Check solution button
  observeEvent(input$check, {
    grid <- sudoku_grid()
    user_grid <- grid  # Start with the existing grid structure
    
    for (i in 1:6) {
      for (j in 1:6) {
        user_value <- input[[paste0("cell_", i, "_", j)]]
        if (user_value != "") {
          user_grid[i, j] <- as.numeric(user_value)
        } else {
          user_grid[i, j] <- NA
        }
      }
    }
    
    if (check_solution(user_grid)) {
      output$result <- renderText("Congratulations! The solution is correct.")
    } else {
      output$result <- renderText("The solution is incorrect. Try again!")
    }
  })
}

# Run the app
shinyApp(ui, server)
