library(shiny)
shinyUI(fluidPage(
  titlePanel("Hello"),
  sidebarLayout(
    mainPanel(
      h5("Take Salam"),
      textInput("name", "Write your name", "SampleName"),
    ),
    mainPanel(
      h2("Your name is"),
      textOutput("output")
    ))))