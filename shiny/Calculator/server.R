library(shiny)
shinyServer(function(input, output) {
  output$output <- renderText({
    switch(input$operator,
           "+" = input$num1 + input$num2,
           "-" = input$num1 - input$num2,
           "x" = input$num1 * input$num2,
           "÷" = input$num1 / input$num2,
           "^" = input$num1 ^ input$num2,
           "√" = sqrt(input$num1))
    
  })
  
})