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
                      DT = numeric(),  # Include DT column
                      WB = numeric(),
                      LL = numeric(),
                      AAC = numeric(),
                      Religion = numeric(),
                      stringsAsFactors = FALSE))
  }
}

# Define UI
ui <- fluidPage(
  titlePanel("Result Report"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("form", "Select Form", 
                  choices = c("", "A", "B")),
      actionButton("generate_report", "Generate Report")  # Button to generate report
    ),
    
    mainPanel(
      uiOutput("report")  # Output area for report
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Load student data and marks data
  student_data <- load_student_data()
  marks_data <- load_marks_data()
  
  # Observe button click to generate report
  observeEvent(input$generate_report, {
    req(input$form)  # Ensure form is selected
    
    filtered_marks <- marks_data[marks_data$Roll %in% student_data$Roll[student_data$Form == input$form], ]
    
    if (nrow(filtered_marks) == 0) {
      showNotification("No marks found for the selected form.", type = "error")
      return()
    }
    
    # Add total and percent columns
    filtered_marks$Total <- rowSums(filtered_marks[, 4:ncol(filtered_marks)], na.rm = TRUE)
    filtered_marks$Percent <- (filtered_marks$Total / (20 * (ncol(filtered_marks) - 3))) * 100  # Assuming max score is 20 per subject
    
    # Define Form Master based on selected form
    form_master <- ifelse(input$form == "A", "Ishita", "Abdullah Al Mahmud")
    
    # Generate report output
    output$report <- renderUI({
      tagList(
        tags$img(src = "scc_logo.png", height = "25px"),
        tags$h4("Fortnightly Exam (2nd Term) - 2024"),
        tags$h4("Result Sheet"),
        tags$h5(paste("Intake: 47, Class IX, Form:", input$form)),
        tags$h5(paste("Form Master:", form_master)),
        tags$table(class = "table table-bordered",
                   tags$thead(
                     tags$tr(
                       tags$th("Roll"),
                       tags$th("Name"),
                       tags$th("House"),
                       tags$th("Bangla"),
                       tags$th("English"),
                       tags$th("Mathematics"),
                       tags$th("Science"),
                       tags$th("HSS"),
                       tags$th("DT"),
                       tags$th("WB"),
                       tags$th("LL"),
                       tags$th("AAC"),
                       tags$th("Religion"),
                       tags$th("Total"),
                       tags$th("Percent")
                     )
                   ),
                   tags$tbody(
                     lapply(1:nrow(filtered_marks), function(i) {
                       tags$tr(
                         tags$td(filtered_marks$Roll[i]),
                         tags$td(filtered_marks$Name[i]),
                         tags$td(filtered_marks$House[i]),
                         tags$td(filtered_marks$Bangla[i]),
                         tags$td(filtered_marks$English[i]),
                         tags$td(filtered_marks$Mathematics[i]),
                         tags$td(filtered_marks$Science[i]),
                         tags$td(filtered_marks$HSS[i]),
                         tags$td(filtered_marks$DT[i]),
                         tags$td(filtered_marks$WB[i]),
                         tags$td(filtered_marks$LL[i]),
                         tags$td(filtered_marks$AAC[i]),
                         tags$td(filtered_marks$Religion[i]),
                         tags$td(filtered_marks$Total[i]),
                         tags$td(filtered_marks$Percent[i])
                       )
                     })
                   )
        )
      )
    })
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
