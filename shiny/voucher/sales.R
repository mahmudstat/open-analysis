library(shiny)
library(shinyjs)

# Function to load existing products from CSV if it exists
load_products <- function() {
  if (file.exists("products.csv")) {
    read.csv("products.csv", stringsAsFactors = FALSE)
  } else {
    data.frame(product_id = integer(), Name = character(), Unit_Price = numeric(), Unit = character(), stringsAsFactors = FALSE)
  }
}

# App 2: Select Product, Input Amount, Show Unit, Total Price Calculation, and Print Summary
ui_product_selection <- fluidPage(
  useShinyjs(),
  titlePanel("Product Selection"),
  sidebarLayout(
    sidebarPanel(
      selectInput("product_select", "Select Product", choices = NULL),
      textOutput("selected_unit"),  # Display unit based on selection
      numericInput("product_amount", "Amount", value = 1, min = 0),  # Amount input
      actionButton("add_product", "Add Product")  # Add product button
    ),
    mainPanel(
      h3("Selected Products:"),
      tableOutput("selected_products"),  # Display selected products table
      div(style = "margin-top: 10px; font-weight: bold; font-size: 18px;", 
          textOutput("total_price")),  # Display total price within table margin
      actionButton("print_summary", "Print Summary")  # Print Summary button
    )
  ),
  
  # Hidden print area for summary
  div(id = "print_area", style = "display: none;",
      h3("Selected Products:"),
      tableOutput("summary_table"),
      div(style = "margin-top: 10px; font-weight: bold; font-size: 18px;", 
          textOutput("summary_total_price"))  # Total price for printing
  ),
  
  # JavaScript to trigger print functionality
  tags$script(
    HTML('
      $("#print_summary").on("click", function(){
        $("#print_area").show();  // Show only print area during printing
        window.print();
        $("#print_area").hide();  // Hide after printing is done
      });
    ')
  ),
  
  # Custom CSS to hide elements outside the print area
  tags$style(
    HTML('
      @media print {
        body * {
          visibility: hidden; /* Hide everything */
        }
        #print_area, #print_area * {
          visibility: visible; /* Show only the print area */
        }
        #print_area {
          position: absolute; /* Positioning to avoid page breaks */
          left: 0;
          top: 0;
        }
      }
    ')
  )
)

server_product_selection <- function(input, output, session) {
  # Load product data from CSV
  products <- reactiveVal(load_products())
  
  # Selected products and amounts
  selected_products <- reactiveVal(data.frame(product_id = integer(), Name = character(), Amount = numeric(), Unit_Price = numeric(), Unit = character(), Total = numeric(), stringsAsFactors = FALSE))
  
  # Update dropdown with product names
  observe({
    updateSelectInput(session, "product_select", choices = setNames(products()$product_id, products()$Name))
  })
  
  # Show the unit of the selected product
  observeEvent(input$product_select, {
    selected_product <- products()[products()$product_id == input$product_select, ]
    output$selected_unit <- renderText({
      paste("Unit:", selected_product$Unit)
    })
  })
  
  # Add product to the selected products table
  observeEvent(input$add_product, {
    req(input$product_select, input$product_amount)
    
    product_data <- products()
    selected_product <- product_data[product_data$product_id == input$product_select, ]
    
    # Calculate total price for the selected amount
    total_price <- selected_product$Unit_Price * input$product_amount
    
    # Add product to the selected_products list
    new_product <- data.frame(
      product_id = selected_product$product_id,
      Name = selected_product$Name,
      Amount = input$product_amount,
      Unit_Price = selected_product$Unit_Price,
      Unit = selected_product$Unit,
      Total = total_price,
      stringsAsFactors = FALSE
    )
    
    selected_products(rbind(selected_products(), new_product))
    
    # Reset the input fields
    updateSelectInput(session, "product_select", selected = "")
    updateNumericInput(session, "product_amount", value = 1)
    output$selected_unit <- renderText("")
  })
  
  # Display selected products
  output$selected_products <- renderTable({
    selected_products()
  })
  
  # Calculate and display the total price of all selected products with Taka sign
  output$total_price <- renderText({
    total <- sum(selected_products()$Total)
    paste("Total Price: ৳", round(total, 2))  # Display total with Taka sign
  })
  
  # Summary table for printing
  output$summary_table <- renderTable({
    selected_products()
  })
  
  # Calculate and display the summary total price for printing
  output$summary_total_price <- renderText({
    total <- sum(selected_products()$Total)
    paste("Total Price: ৳", round(total, 2))  # Display total with Taka sign
  })
}

shinyApp(ui = ui_product_selection, server = server_product_selection)
