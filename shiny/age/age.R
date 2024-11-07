library(shiny)
library(lubridate)

# Define UI
ui <- fluidPage(
  titlePanel("Age Calculator"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("year", "Select Year:", choices = 1900:year(Sys.Date()), selected = 2000),
      selectInput("month", "Select Month:", choices = month.name, selected = "January"),
      selectInput("day", "Select Day:", choices = 1:31, selected = 1),
      actionButton("calculate", "Calculate Age")
    ),
    
    mainPanel(
      h3("Your Age:"),
      textOutput("age_output")
    )
  )
)

# Define Server logic
server <- function(input, output) {
  observeEvent(input$calculate, {
    output$age_output <- renderText({
      dob <- as.Date(paste(input$year, match(input$month, month.name), input$day, sep = "-"))
      today <- Sys.Date()
      
      age_years <- year(today) - year(dob)
      age_months <- month(today) - month(dob)
      age_days <- day(today) - day(dob)
      
      if (age_days < 0) {
        age_days <- age_days + days_in_month(dob)
        age_months <- age_months - 1
      }
      if (age_months < 0) {
        age_months <- age_months + 12
        age_years <- age_years - 1
      }
      
      paste(age_years, "years,", age_months, "months, and", age_days, "days old")
    })
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
