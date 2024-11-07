library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Cadet Data Collection"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("cadet_no", "Cadet Number:", value = 1001, min = 1),
      textInput("name", "Name:"),
      selectInput("house", "House:", choices = c("Ti", "Sj", "Su")),
      numericInput("bangla", "Bangla:", value = 0, min = 0, max = 100),
      numericInput("english", "English:", value = 0, min = 0, max = 100),
      numericInput("mathematics", "Mathematics:", value = 0, min = 0, max = 100),
      numericInput("science", "Science:", value = 0, min = 0, max = 100),
      numericInput("hss", "HSS:", value = 0, min = 0, max = 100),
      numericInput("wb", "WB:", value = 0, min = 0, max = 100),
      numericInput("ll", "LL:", value = 0, min = 0, max = 100),
      numericInput("aac", "AAC:", value = 0, min = 0, max = 100),
      numericInput("religion", "Religion:", value = 0, min = 0, max = 100),
      actionButton("submit", "Submit")
    ),
    
    mainPanel(
      tableOutput("cadetData")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  # Path to store the CSV file
  file_path <- "cadet_data.csv"
  
  # Reactive value to store cadet data
  cadet_data <- reactiveVal(data.frame(
    Cadet_No = numeric(),
    Name = character(),
    House = character(),
    Bangla = numeric(),
    English = numeric(),
    Mathematics = numeric(),
    Science = numeric(),
    HSS = numeric(),
    WB = numeric(),
    LL = numeric(),
    AAC = numeric(),
    Religion = numeric(),
    stringsAsFactors = FALSE
  ))
  
  # Load existing data if the file exists
  if (file.exists(file_path)) {
    existing_data <- read.csv(file_path, stringsAsFactors = FALSE)
    cadet_data(existing_data)
  }
  
  # Observe when the submit button is clicked
  observeEvent(input$submit, {
    # Collect new cadet data
    new_data <- data.frame(
      Cadet_No = input$cadet_no,
      Name = input$name,
      House = input$house,
      Bangla = input$bangla,
      English = input$english,
      Mathematics = input$mathematics,
      Science = input$science,
      HSS = input$hss,
      WB = input$wb,
      LL = input$ll,
      AAC = input$aac,
      Religion = input$religion,
      stringsAsFactors = FALSE
    )
    
    # Update the reactive data frame
    updated_data <- rbind(cadet_data(), new_data)
    cadet_data(updated_data)
    
    # Save the updated data to a CSV file
    write.csv(updated_data, file_path, row.names = FALSE)
  })
  
  # Display the collected cadet data
  output$cadetData <- renderTable({
    cadet_data()
  })
}

# Run the app
shinyApp(ui = ui, server = server)
