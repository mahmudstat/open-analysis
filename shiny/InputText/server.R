function(input, output) {
  output$value <- renderText({ paste0("Assalamu Alaykum ", 
                                      input$caption, 
                                      "! \n May Allah Bless You") })
}
