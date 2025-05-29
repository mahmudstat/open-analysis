library(shiny)
library(DBI)
library(RSQLite)  # or use RMySQL/RPostgres for a larger database

# Sample SQLite database (for local testing)
# Alternatively, you can use an actual DBMS and replace the SQLite connection below
db <- dbConnect(SQLite(), ":memory:")

# Create a sample products table in SQLite
dbExecute(db, "CREATE TABLE products (serial_number TEXT, product_name TEXT, price REAL)")
dbExecute(db, "INSERT INTO products (serial_number, product_name, price) VALUES
                ('123456789', 'Product A', 19.99),
                ('987654321', 'Product B', 29.99)")

# UI
ui <- fluidPage(
  titlePanel("Barcode Scanner Product Lookup"),
  textInput("barcode", "Scan Barcode", placeholder = "Scan here..."),
  actionButton("lookup", "Lookup Price"),
  textOutput("product_name"),
  textOutput("price")
)

# Server
server <- function(input, output, session) {
  
  # Observe when the barcode input changes
  observeEvent(input$lookup, {
    serial <- input$barcode
    
    # Query the database for the product info
    query <- dbSendQuery(db, "SELECT product_name, price FROM products WHERE serial_number = ?")
    dbBind(query, list(serial))
    result <- dbFetch(query)
    dbClearResult(query)
    
    # Display the product details if found
    if (nrow(result) > 0) {
      output$product_name <- renderText(paste("Product:", result$product_name))
      output$price <- renderText(paste("Price: $", result$price))
    } else {
      output$product_name <- renderText("Product not found")
      output$price <- renderText("")
    }
  })
  
  # Automatically clear input after lookup (optional)
  observeEvent(input$lookup, {
    updateTextInput(session, "barcode", value = "")
  })
}

# Run the app
shinyApp(ui, server)
