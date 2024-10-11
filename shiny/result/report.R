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

# Define UI
ui <- fluidPage(
  
  # CSS to hide the sidebar during print, remove the print header/footer, and modify other print settings
  tags$head(
    tags$style(HTML("
      @media print {
        .sidebar { display: none; }
        .main-panel { width: 100%; }
        #result-title { display: none; }  /* Hide the 'Result Report' title in print */
        @page {
          margin: 0;
        }
        body {
          margin: 1cm;
        }
        /* Hide browser print headers and footers */
        @page { size: auto; margin: 0mm; }
        body { margin: 1.6cm; }
      }
    "))
  ),
  
  div(id = "result-title", tags$h2("Result Report")),  # Replaced titlePanel with div and h2
  
  sidebarLayout(
    sidebarPanel(
      class = "sidebar",  # Add class for sidebar to target with CSS
      selectInput("form", "Select Form", 
                  choices = c("", "A", "B")),
      actionButton("generate_report", "Generate Report"),
      actionButton("print_report", "Print Report")  # Button for printing the report
    ),
    
    mainPanel(
      class = "main-panel",  # Add class for main panel to target with CSS
      uiOutput("report")  # Output area for report
    )
  ),
  
  # Inline JavaScript to trigger print action
  tags$script(HTML("
    $(document).on('click', '#print_report', function() {
      window.print();
    });
  "))
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
    
    # Add SL, total, and percent columns
    filtered_marks$SL <- seq_len(nrow(filtered_marks))
    filtered_marks$Total <- rowSums(filtered_marks[, 4:ncol(filtered_marks)], na.rm = TRUE)
    filtered_marks$Percent <- round((filtered_marks$Total / (20 * (ncol(filtered_marks) - 4))) * 100, 2)  # Two decimal places
    
    # Define Form Master based on selected form
    form_master <- ifelse(input$form == "A", "Ishita", "Abdullah Al Mahmud")
    
    # Generate report output
    output$report <- renderUI({
      tagList(
        tags$div(style = "text-align:center;",  # Center the logo and text
                 tags$img(src = "scc_logo.jpg", height = "100px"),  # Resize logo to 100px
                 tags$h4("Fortnightly Exam (2nd Term) - 2024"),
                 tags$h4("Result Sheet"),
                 # Put texts in one line after "Result Sheet" and spread it across the page width
                 tags$div(style = "display: flex; justify-content: space-between; width: 100%;",
                          tags$span(paste("Intake: 47")),
                          tags$span(paste("Class IX, Form:", input$form)),
                          tags$span(paste("Form Master:", form_master))
                 )
        ),
        tags$table(class = "table table-bordered",
                   tags$thead(
                     tags$tr(
                       tags$th("SL"),
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
                         tags$td(filtered_marks$SL[i]),
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
                         tags$td(sprintf("%.2f", filtered_marks$Percent[i]))  # Format to 2 decimal places
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
