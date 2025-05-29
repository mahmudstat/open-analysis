library(shiny)

# App 1: Create Products with Auto-Save on Add
ui_product <- fluidPage(
  titlePanel("Product Creation"),
  sidebarLayout(
    sidebarPanel(
      textInput("product_name", "Product Name"),
      numericInput("unit_price", "Unit Price", value = 0, min = 0),
      textInput("unit", "Unit (e.g., kg, pcs)"),
      actionButton("add_product", "Add Product")
    ),
    mainPanel(
      tableOutput("product_list")
    )
  )
)

server_product <- function(input, output, session) {
  products <- reactiveVal(data.frame(Name = character(), Unit_Price = numeric(), Unit = character(), stringsAsFactors = FALSE))
  
  observeEvent(input$add_product, {
    # Add new product to the list
    new_product <- data.frame(Name = input$product_name, Unit_Price = input$unit_price, Unit = input$unit, stringsAsFactors = FALSE)
    updated_products <- rbind(products(), new_product)
    products(updated_products)
    
    # Save the updated products to CSV automatically
    write.csv(updated_products, "products.csv", row.names = FALSE)
    
    # Reset input fields
    updateTextInput(session, "product_name", value = "")
    updateNumericInput(session, "unit_price", value = 0)
    updateTextInput(session, "unit", value = "")
    
    # Show notification
    showNotification("Product added and saved!", type = "message")
  })
  
  output$product_list <- renderTable({
    products()
  })
}

shinyApp(ui = ui_product, server = server_product)
