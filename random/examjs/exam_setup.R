library(shiny)

ui <- fluidPage(
  titlePanel("Exam Setup"),
  sidebarLayout(
    sidebarPanel(
      textInput("subjectName", "Subject Name"),
      
      h4("Fortnightly Exam"),
      numericInput("FNT", "Mark", value = NULL),
      numericInput("FNP", "Pass Mark", value = NULL),
      
      h4("Final Exam"),
      numericInput("FinalCQT", "Final CQ Mark", value = NULL),
      numericInput("FinalCQTP", "Final CQ Pass Mark", value = NULL),
      
      numericInput("FinalMCQT", "Final MCQ Mark", value = NULL),
      numericInput("FinalMCQTP", "Final MCQ Pass Mark", value = NULL),
      
      numericInput("FNPRT", "Final Practical Mark", value = NULL),
      numericInput("FNPRTP", "Final Practical Pass Mark", value = NULL),
      
      actionButton("save", "Save Exam Setup"),
      br(), br(),
      textOutput("confirmation")
    ),
    mainPanel(
      h4("Current Setup Data"),
      uiOutput("dynamic_table")  # Using uiOutput for dynamic rendering
    )
  )
)

server <- function(input, output, session) {
  # Define the CSV file path
  csv_file <- "setup.csv"
  
  # Initialize the file if it doesn't exist
  if (!file.exists(csv_file)) {
    write.csv(data.frame(
      Subject = character(),
      FN = numeric(),
      FNP = numeric(),
      FinalCQT = numeric(),
      FinalCQTP = numeric(),
      FinalMCQT = numeric(),
      FinalMCQTP = numeric(),
      FNPRT = numeric(),
      FNPRTP = numeric(),
      stringsAsFactors = FALSE
    ), csv_file, row.names = FALSE)
  }
  
  # Reactive value to hold the current data
  current_data <- reactiveVal(read.csv(csv_file, stringsAsFactors = FALSE))
  
  # Function to update the table UI
  updateTableUI <- function() {
    output$dynamic_table <- renderUI({
      data_table <- current_data()
      if (nrow(data_table) == 0) return(NULL)
      
      # Create a table with action buttons for each row
      table_output <- tagList()
      for (i in 1:nrow(data_table)) {
        row <- data_table[i, ]
        action_buttons <- tagList(
          actionButton(inputId = paste0("edit_", i), label = "Edit", class = "btn btn-primary btn-sm"),
          actionButton(inputId = paste0("delete_", i), label = "Delete", class = "btn btn-danger btn-sm")
        )
        
        table_output <- tagAppendChild(table_output, div(
          style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 5px;",
          p(paste(row$Subject, row$FN, row$FNP, row$FinalCQT, row$FinalCQTP,
                  row$FinalMCQT, row$FinalMCQTP, row$FNPRT, row$FNPRTP, sep = " | ")),
          action_buttons
        ))
      }
      
      table_output
    })
  }
  
  # Save data when "Save" button is clicked
  observeEvent(input$save, {
    # Create a new row with input values
    new_row <- data.frame(
      Subject = input$subjectName,
      FN = input$FNT,
      FNP = input$FNP,
      FinalCQT = input$FinalCQT,
      FinalCQTP = input$FinalCQTP,
      FinalMCQT = input$FinalMCQT,
      FinalMCQTP = input$FinalMCQTP,
      FNPRT = input$FNPRT,
      FNPRTP = input$FNPRTP,
      stringsAsFactors = FALSE
    )
    
    # Get the existing data
    existing_data <- current_data()
    
    # Check if subject already exists
    subject_index <- which(existing_data$Subject == input$subjectName)
    
    if (length(subject_index) > 0) {
      # Update existing row
      existing_data[subject_index, ] <- new_row
    } else {
      # Append new row
      existing_data <- rbind(existing_data, new_row)
    }
    
    # Save the updated data back to CSV
    write.csv(existing_data, csv_file, row.names = FALSE)
    current_data(existing_data)
    
    output$confirmation <- renderText("Subject saved successfully!")
    
    # Reset all input fields
    resetInputs()
    
    # Refresh the table after saving data
    updateTableUI()
  })
  
  # Function to reset all input fields
  resetInputs <- function() {
    updateTextInput(session, "subjectName", value = "")
    updateNumericInput(session, "FNT", value = NULL)
    updateNumericInput(session, "FNP", value = NULL)
    updateNumericInput(session, "FinalCQT", value = NULL)
    updateNumericInput(session, "FinalCQTP", value = NULL)
    updateNumericInput(session, "FinalMCQT", value = NULL)
    updateNumericInput(session, "FinalMCQTP", value = NULL)
    updateNumericInput(session, "FNPRT", value = NULL)
    updateNumericInput(session, "FNPRTP", value = NULL)
  }
  
  # Observe for dynamic edit and delete button clicks
  observe({
    req(current_data())
    table_data <- current_data()
    
    # Loop through each row for dynamic button handling
    for (i in 1:nrow(table_data)) {
      local({
        row_idx <- i
        
        # Edit button
        observeEvent(input[[paste0("edit_", row_idx)]], {
          selected_data <- table_data[row_idx, , drop = FALSE]  # Ensure single row data frame
          updateTextInput(session, "subjectName", value = selected_data$Subject)
          updateNumericInput(session, "FNT", value = selected_data$FN)
          updateNumericInput(session, "FNP", value = selected_data$FNP)
          updateNumericInput(session, "FinalCQT", value = selected_data$FinalCQT)
          updateNumericInput(session, "FinalCQTP", value = selected_data$FinalCQTP)
          updateNumericInput(session, "FinalMCQT", value = selected_data$FinalMCQT)
          updateNumericInput(session, "FinalMCQTP", value = selected_data$FinalMCQTP)
          updateNumericInput(session, "FNPRT", value = selected_data$FNPRT)
          updateNumericInput(session, "FNPRTP", value = selected_data$FNPRTP)
        })
        
        # Delete button
        observeEvent(input[[paste0("delete_", row_idx)]], {
          showModal(modalDialog(
            title = "Confirm Delete",
            "Are you sure you want to delete this row?",
            footer = tagList(
              modalButton("Cancel"),
              actionButton(paste0("confirm_delete_", row_idx), "Delete", class = "btn-danger")
            )
          ))
        })
        
        # Confirm deletion of a row
        observeEvent(input[[paste0("confirm_delete_", row_idx)]], {
          updated_data <- current_data()
          updated_data <- updated_data[-row_idx, , drop = FALSE]  # Remove the selected row
          
          # Save the updated data back to CSV
          write.csv(updated_data, csv_file, row.names = FALSE)
          current_data(updated_data)
          
          removeModal()
          updateTableUI()  # Refresh the table after deletion
        })
      })
    }
  })
  
  # Initial rendering of the table
  updateTableUI()
}

shinyApp(ui = ui, server = server)
