library(shiny)

# Load existing data if the file exists, otherwise create an empty data frame
load_data <- function() {
  if (file.exists("student_grades.csv")) {
    return(read.csv("student_grades.csv", stringsAsFactors = FALSE))
  } else {
    return(data.frame(Roll = character(),
                      Name = character(),
                      House = character(),
                      Subject = character(),
                      Marks = numeric(),
                      stringsAsFactors = FALSE))
  }
}

# Save the data to CSV
save_data <- function(data) {
  write.csv(data, "student_grades.csv", row.names = FALSE)
}

# Define UI
ui <- fluidPage(
  titlePanel("Student Grades Collection"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("roll", "Student Roll Number"),
      textInput("name", "Student Name"),
      textInput("house", "House"),
      
      selectInput("subject", "Select Subject",
                  choices = c("Bangla", "English", "Mathematics", "Science", 
                              "HSS", "WB", "LL", "AAC", "Religion")),
      
      numericInput("marks", "Enter Marks (Out of 20)", value = 0, min = 0, max = 20),
      
      actionButton("submit", "Submit"),
      
      hr(),
      
      actionButton("save", "Save Data")
    ),
    
    mainPanel(
      tableOutput("table")
    )
  )
)

# Define Server
server <- function(input, output, session) {
  
  # Reactive data storage for grades
  grades <- reactiveVal(load_data())
  
  # Submit button action to add data
  observeEvent(input$submit, {
    if (input$marks <= 20) {
      new_entry <- data.frame(Roll = input$roll,
                              Name = input$name,
                              House = input$house,
                              Subject = input$subject,
                              Marks = input$marks,
                              stringsAsFactors = FALSE)
      
      updated_data <- rbind(grades(), new_entry)
      grades(updated_data)
    } else {
      showNotification("Marks cannot exceed 20.", type = "error")
    }
  })
  
  # Save button action to save data
  observeEvent(input$save, {
    save_data(grades())
    showNotification("Data saved successfully!", type = "message")
  })
  
  # Render the data table
  output$table <- renderTable({
    grades()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
