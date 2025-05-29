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

# Function to get the next product_id, filling in gaps in IDs first
next_product_id <- function(products) {
  if (nrow(products) == 0) {
    return(1L)  # Return 1 if no products exist
  } else {
    existing_ids <- sort(products$product_id)
    missing_ids <- setdiff(seq(min(existing_ids), max(existing_ids)), existing_ids)
    if (length(missing_ids) > 0) {
      return(min(missing_ids))  # Return the smallest missing ID
    } else {
      return(max(existing_ids) + 1L)  # Return the next ID after the max
    }
  }
}

# App 1: New Product Creation with Auto-Save on Add, Edit, and Reset functionality
ui_product <- fluidPage(
  useShinyjs(),  # Enable shinyjs
  titlePanel("New Product"),
  sidebarLayout(
    sidebarPanel(
      # Hidden product_id, handled internally
      textInput("product_name", "Product Name", value = ""),  # No default value
      textInput("unit", "Unit (e.g., kg, pcs)", value = ""),  # No default value
      numericInput("unit_price", "Unit Price", value = NA, min = 0),  # No default value, set to NA
      actionButton("add_product", "Add/Update Product"),
      actionButton("reset_product", "Reset"),  # New Reset button
      hr(),
      textInput("delete_product_id", "Product ID to Delete", value = ""),  # Input to delete by product ID
      actionButton("delete_product", "Delete Product")
    ),
    mainPanel(
      tableOutput("product_list")
    )
  )
)

server_product <- function(input, output, session) {
  # Load products from CSV when the app starts
  products <- reactiveVal(load_products())
  
  # Store the product being edited
  editing_product_id <- reactiveVal(NULL)
  
  # Function to render the product list with Edit and Delete buttons
  output$product_list <- renderTable({
    product_data <- products()
    
    # Create Edit buttons for each product
    product_data$Edit <- sapply(seq_len(nrow(product_data)), function(i) {
      paste0('<button id="edit_', i, '" class="edit_btn" data-index="', i, '">Edit</button>')
    })
    
    # Select only relevant columns for display
    product_data <- product_data[, c("product_id", "Name", "Unit_Price", "Unit", "Edit")]
    colnames(product_data) <- c("Product ID", "Product Name", "Unit Price", "Unit", "Edit")
    
    # Use HTML for rendering buttons
    product_data
  }, sanitize.text.function = function(x) x)  # Allow HTML rendering
  
  # Add/Update product when "Add/Update Product" is clicked
  observeEvent(input$add_product, {
    product_data <- products()
    
    # Check for missing fields
    if (is.na(input$unit_price) || input$product_name == "" || input$unit == "") {
      showNotification("Please fill in all fields", type = "error")
      return()
    }
    
    # Check if we are editing a product
    if (!is.null(editing_product_id())) {
      # Find the index of the product to edit
      edit_index <- which(product_data$product_id == editing_product_id())
      # Update the existing product
      product_data[edit_index, ] <- data.frame(
        product_id = editing_product_id(),
        Name = input$product_name,
        Unit_Price = input$unit_price,
        Unit = input$unit,
        stringsAsFactors = FALSE
      )
      showNotification("Product updated!", type = "message")
      
      # Reset the editing ID after updating
      editing_product_id(NULL)
    } else {
      # Add a new product if not editing
      product_id <- next_product_id(product_data)
      new_product <- data.frame(
        product_id = as.integer(product_id),  # Ensure product_id is an integer
        Name = input$product_name,
        Unit_Price = input$unit_price,
        Unit = input$unit,
        stringsAsFactors = FALSE
      )
      product_data <- rbind(product_data, new_product)
      showNotification("Product added and saved!", type = "message")
    }
    
    # Update the product list and save it to the CSV
    products(product_data)
    write.csv(product_data, "products.csv", row.names = FALSE)
    
    # Reset all input fields after adding/updating a product
    updateTextInput(session, "product_name", value = "")
    updateTextInput(session, "unit", value = "")
    updateNumericInput(session, "unit_price", value = NA)
  })
  
  # Reset all fields when "Reset" is clicked
  observeEvent(input$reset_product, {
    updateTextInput(session, "product_name", value = "")
    updateTextInput(session, "unit", value = "")
    updateNumericInput(session, "unit_price", value = NA)
    editing_product_id(NULL)  # Reset editing state
  })
  
  # Handle edit button click
  observe({
    req(products())
    product_data <- products()
    
    # Bind click events to dynamically created buttons
    lapply(seq_len(nrow(product_data)), function(i) {
      edit_button_id <- paste0("edit_", i)
      
      shinyjs::onclick(edit_button_id, {
        selected_product <- product_data[i, ]
        
        # Fill in the current product details in input boxes
        updateTextInput(session, "product_name", value = selected_product$Name)
        updateTextInput(session, "unit", value = selected_product$Unit)
        updateNumericInput(session, "unit_price", value = selected_product$Unit_Price)
        
        # Store the product_id of the product being edited
        editing_product_id(selected_product$product_id)
      })
    })
  })
  
  # Handle delete button click
  observeEvent(input$delete_product, {
    req(input$delete_product_id)
    
    product_data <- products()
    
    # Find the row by product_id and remove it
    delete_index <- which(product_data$product_id == as.numeric(input$delete_product_id))
    if (length(delete_index) > 0) {
      product_data <- product_data[-delete_index, ]
      products(product_data)
      
      # Save the updated product list to CSV
      write.csv(product_data, "products.csv", row.names = FALSE)
      showNotification("Product deleted!", type = "message")
    } else {
      showNotification("Product ID not found", type = "error")
    }
    
    # Clear delete input field
    updateTextInput(session, "delete_product_id", value = "")
  })
}

shinyApp(ui = ui_product, server = server_product)
