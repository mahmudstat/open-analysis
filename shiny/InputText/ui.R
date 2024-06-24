fluidPage(
  textInput(inputId = "caption", 
            label = "Tell Us Your Name", 
            value = "",
            placeholder = "TEXT"),
  verbatimTextOutput("value")
)
