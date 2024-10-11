library(shiny)

# Load existing student data if the file exists
load_student_data <- function() {
  if (file.exists("student_info.csv")) {
    return(read.csv("student_info.csv", stringsAsFactors = FALSE))
  } else {
    return(NULL)
  }
}

# Load existing marks data if the file exists, otherwise create an empty data frame
load_marks_data <- function() {
  if (file.exists("marks_data.csv")) {
    return(read.csv("marks_data.csv", stringsAsFactors = FALSE))
  } else {
    return(data.frame(Roll = character(),
                      Name = character(),
                      House = character(),
                      Bangla = numeric(),
                      English = numeric(),
                      Mathematics = numeric(),
                      Science = numeric(),
                      HSS = numeric(),
                      DT = numeric(),
                      WB = numeric(),
                      LL = numeric(),
                      AAC = numeric(),
                      Religion = numeric(),
                      stringsAsFactors = FALSE))
  }
}

# Save marks data to CSV
save_marks_data <- function(data) {
  write.csv(data, "marks_data.csv", row.names = FALSE)
}

# Define UI
ui <- fluidPage(
  titlePanel("Enter Student Marks"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("form", "Select Form", 
                  choices = c("", "A", "B")),
      selectInput("subject", "Select Subject", 
                  choices = c("", "Bangla", "English", "Mathematics", "Science", "HSS", "DT", "WB", "LL", "AAC", "Religion")),
      uiOutput("marks_input"),  # Dynamic UI for entering marks
      actionButton("submit", "Submit")  # Submit button
    ),
    
    mainPanel(
      tableOutput("marks_table")  # Table to display marks data
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Load student data and marks data
  student_data <- load_student_data()
  marks_data <- reactiveVal(load_marks_data())
  
  # Check if student data is available
  observe({
    if (is.null(student_data)) {
      showNotification("Fill up students information first.", type = "error")
    }
  })
  
  # Dynamically create input boxes for each student
  output$marks_input <- renderUI({
    if (!is.null(student_data) && input$form != "") {
      filtered_data <- student_data[student_data$Form == input$form, ]
      if (input$subject != "" && nrow(filtered_data) > 0) {
        # Get current marks for the selected subject
        current_marks <- marks_data()
        lapply(1:nrow(filtered_data), function(i) {
          roll <- filtered_data$Roll[i]
          marks_value <- current_marks[current_marks$Roll == roll, input$subject]
          # If marks exist, use them; otherwise set to NA
          numericInput(paste0("marks_", i), 
                       label = paste("Marks for Roll", roll), 
                       value = ifelse(length(marks_value) > 0, marks_value, NA), 
                       min = 0, 
                       max = 20)
        })
      }
    }
  })
  
  # Reset input boxes when a new subject is chosen
  observeEvent(input$subject, {
    if (!is.null(student_data) && input$subject != "") {
      # Input boxes will be automatically filled with existing marks, so no need to reset
      # If you want to clear inputs on form change, you can uncomment the next line
      # reset_input_boxes()
    }
  })
  
  # Submit marks for the selected subject
  observeEvent(input$submit, {
    if (is.null(student_data)) {
      return()
    }
    
    if (input$form != "" && input$subject != "") {
      filtered_data <- student_data[student_data$Form == input$form, ]
      if (nrow(filtered_data) == 0) {
        showNotification("No students found for this form.", type = "error")
        return()
      }
      
      new_marks <- sapply(1:nrow(filtered_data), function(i) {
        as.numeric(input[[paste0("marks_", i)]])
      })
      
      # Validate marks
      if (any(is.na(new_marks)) || any(new_marks < 0) || any(new_marks > 20)) {
        showNotification("Marks must be numeric and between 0 and 20 for all students.", type = "error")
        return()
      }
      
      # Update marks data
      current_marks <- marks_data()
      
      for (i in 1:nrow(filtered_data)) {
        roll <- filtered_data$Roll[i]
        name <- filtered_data$Name[i]
        house <- filtered_data$House[i]  # Get house from filtered data
        
        # Check if roll number already exists in marks data
        if (roll %in% current_marks$Roll) {
          # Update existing marks
          current_marks[current_marks$Roll == roll, input$subject] <- new_marks[i]
        } else {
          # Add new student with marks
          new_entry <- data.frame(Roll = roll,
                                  Name = name,
                                  House = house,
                                  Bangla = ifelse(input$subject == "Bangla", new_marks[i], NA),
                                  English = ifelse(input$subject == "English", new_marks[i], NA),
                                  Mathematics = ifelse(input$subject == "Mathematics", new_marks[i], NA),
                                  Science = ifelse(input$subject == "Science", new_marks[i], NA),
                                  HSS = ifelse(input$subject == "HSS", new_marks[i], NA),
                                  DT = ifelse(input$subject == "DT", new_marks[i], NA),  # Add DT to new entry
                                  WB = ifelse(input$subject == "WB", new_marks[i], NA),
                                  LL = ifelse(input$subject == "LL", new_marks[i], NA),
                                  AAC = ifelse(input$subject == "AAC", new_marks[i], NA),
                                  Religion = ifelse(input$subject == "Religion", new_marks[i], NA),
                                  stringsAsFactors = FALSE)
          current_marks <- rbind(current_marks, new_entry)
        }
      }
      
      # Update and save marks data
      marks_data(current_marks)
      save_marks_data(current_marks)
      showNotification("Marks submitted successfully!", type = "message")
      
      # Clear all marks inputs after saving for the chosen subject
      reset_input_boxes()
    } else {
      showNotification("Please select a form and a subject.", type = "warning")
    }
  })
  
  # Function to reset input boxes
  reset_input_boxes <- function() {
    for (i in 1:nrow(student_data)) {
      updateNumericInput(session, paste0("marks_", i), value = NA)
    }
  }
  
  # Display updated marks data
  output$marks_table <- renderTable({
    current_marks <- marks_data()
    if (nrow(current_marks) > 0) {
      return(current_marks[, c("Roll", "Name", "House", names(current_marks)[4:ncol(current_marks)])])
    } else {
      return(data.frame())  # Return empty data frame if no marks
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
