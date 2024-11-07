library(shiny)

# Load existing student data if the file exists
load_student_data <- function() {
  if (file.exists("student_info.csv")) {
    return(read.csv("student_info.csv", stringsAsFactors = FALSE))
  } else {
    return(data.frame(Roll = character(), Name = character(), House = character(), Form = character(), stringsAsFactors = FALSE))
  }
}

# Save student data to a CSV file
save_student_data <- function(data) {
  write.csv(data, "student_info.csv", row.names = FALSE)
}

# Define UI
ui <- fluidPage(
  titlePanel("Student Information Input"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("roll", "Roll Number"),
      textInput("name", "Name"),
      selectInput("house", "House", choices = c("", "Ti", "Sj", "Su")),
      selectInput("form", "Form", choices = c("", "A", "B")),
      actionButton("save", "Save"),
      actionButton("delete", "Delete"),
      br(), br(),
      uiOutput("message")
    ),
    
    mainPanel(
      tableOutput("student_table")  # Display the student data table
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Reactive value to store student data
  student_data <- reactiveVal(load_student_data())
  
  # Render student table
  output$student_table <- renderTable({
    student_data()
  })
  
  # Message output
  output$message <- renderUI({
    if (!is.null(input$roll) && input$roll != "" && input$roll %in% student_data()$Roll) {
      tags$p("Roll number already exists!", style = "color: red;")
    }
  })
  
  # Save student information
  observeEvent(input$save, {
    roll <- input$roll
    name <- input$name
    house <- input$house
    form <- input$form
    
    # Check if all fields are filled
    if (roll == "" || name == "" || house == "" || form == "") {
      showNotification("Please fill out all fields.", type = "error")
      return(NULL)
    }
    
    # Check for duplicate roll number
    current_data <- student_data()
    existing_row <- which(current_data$Roll == roll)
    
    if (length(existing_row) > 0) {
      # Update existing entry
      current_data[existing_row, ] <- data.frame(Roll = roll, Name = name, House = house, Form = form, stringsAsFactors = FALSE)
      showNotification("Student information updated.", type = "message")
    } else {
      # Add new entry if roll number doesn't exist
      current_data <- rbind(current_data, data.frame(Roll = roll, Name = name, House = house, Form = form, stringsAsFactors = FALSE))
      showNotification("New student added.", type = "message")
    }
    
    # Save updated data
    student_data(current_data)
    save_student_data(current_data)
    
    # Clear input fields
    updateTextInput(session, "roll", value = "")
    updateTextInput(session, "name", value = "")
    updateSelectInput(session, "house", selected = "")
    updateSelectInput(session, "form", selected = "")
  })
  
  # Delete student information
  observeEvent(input$delete, {
    roll <- input$roll
    
    if (roll == "" || !(roll %in% student_data()$Roll)) {
      showNotification("Invalid roll number.", type = "error")
      return(NULL)
    }
    
    current_data <- student_data()
    current_data <- current_data[current_data$Roll != roll, ]
    
    # Save updated data
    student_data(current_data)
    save_student_data(current_data)
    
    showNotification("Student entry deleted.", type = "message")
    
    # Clear input fields
    updateTextInput(session, "roll", value = "")
    updateTextInput(session, "name", value = "")
    updateSelectInput(session, "house", selected = "")
    updateSelectInput(session, "form", selected = "")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
