library(shiny)

# Load existing data if the file exists, otherwise create an empty data frame
load_data <- function() {
  if (file.exists("student_info.csv")) {
    return(read.csv("student_info.csv", stringsAsFactors = FALSE))
  } else {
    return(data.frame(Roll = character(),
                      Name = character(),
                      Form = character(),
                      House = character(),
                      stringsAsFactors = FALSE))
  }
}

# Save the data to CSV
save_data <- function(data) {
  write.csv(data, "student_info.csv", row.names = FALSE)
}

# Define UI
ui <- fluidPage(
  titlePanel("Initiate Input - Student Information"),
  
  sidebarLayout(
    sidebarPanel(
      # Form layout for student information
      textInput("roll", "Student Roll Number"),
      textInput("name", "Student Name"),
      
      selectInput("form", "Form", 
                  choices = c("", "A" = "A", "B" = "B")),
      
      selectInput("house", "House", 
                  choices = c("", "Ti" = "Ti", "Sj" = "Sj", "Su" = "Su")),
      
      actionButton("submit", "Submit")
    ),
    
    mainPanel(
      tableOutput("table")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Reactive storage for student data
  student_data <- reactiveVal(load_data())
  
  # Add new student info on submit
  observeEvent(input$submit, {
    new_entry <- data.frame(Roll = input$roll,
                            Name = input$name,
                            Form = input$form,
                            House = input$house,
                            stringsAsFactors = FALSE)
    
    updated_data <- rbind(student_data(), new_entry)
    student_data(updated_data)
    
    # Automatically save data on submit
    save_data(updated_data)
    showNotification("Data saved successfully!", type = "message")
    
    # Reset the input fields after submission
    updateTextInput(session, "roll", value = "")
    updateTextInput(session, "name", value = "")
    updateSelectInput(session, "form", selected = "")  # Reset form dropdown
    updateSelectInput(session, "house", selected = "")  # Reset house dropdown
  })
  
  # Display student info table
  output$table <- renderTable({
    student_data()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
