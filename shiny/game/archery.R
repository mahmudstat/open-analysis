library(shiny)
library(ggplot2)

# Define UI
ui <- fluidPage(
  titlePanel("Interactive Archery Game"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Score:"),
      verbatimTextOutput("score"),
      actionButton("rotate", "Rotate Target")
    ),
    
    mainPanel(
      plotOutput("targetPlot", click = "plot_click", height = "500px")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  # Initialize score
  score <- reactiveVal(0)
  angle <- reactiveVal(0)
  
  observeEvent(input$rotate, {
    angle(angle() + 30)  # Rotate the target by 30 degrees
  })
  
  output$targetPlot <- renderPlot({
    # Create a target with a rotation
    target_radius <- c(20, 15, 10, 5)  # Radii for the target circles
    target_colors <- c("red", "blue", "green", "white")  # Colors for the circles
    
    # Create circles for the target
    circles <- lapply(seq_along(target_radius), function(i) {
      theta <- seq(0, 2 * pi, length.out = 100)
      data.frame(
        x = target_radius[i] * cos(theta),
        y = target_radius[i] * sin(theta),
        fill = target_colors[i]
      )
    })
    
    # Combine the circle data into a single data frame
    target_data <- do.call(rbind, circles)
    
    # Create the plot
    p <- ggplot() +
      theme_void() +
      coord_fixed() +
      geom_polygon(data = target_data, aes(x = x, y = y, fill = fill), alpha = 0.5) +
      xlim(-60, 60) + ylim(-60, 60) +
      ggtitle("Click to Shoot!") +
      theme(legend.position = "none") +
      geom_point(aes(x = 0, y = 0), size = 3, color = "black")  # Center of the target
    
    # Rotate target based on the angle
    if (angle() != 0) {
      rotation_matrix <- matrix(c(cos(angle() * pi / 180), -sin(angle() * pi / 180),
                                  sin(angle() * pi / 180), cos(angle() * pi / 180)), nrow = 2)
      rotated_data <- as.matrix(target_data[, 1:2]) %*% rotation_matrix
      target_data$x <- rotated_data[, 1]
      target_data$y <- rotated_data[, 2]
    }
    
    p <- p + geom_polygon(data = target_data, aes(x = x, y = y, fill = fill), alpha = 0.5)
    
    print(p)
  })
  
  observeEvent(input$plot_click, {
    click <- input$plot_click
    distance <- sqrt(click$x^2 + click$y^2)
    
    # Scoring based on distance from the center
    if (distance <= 5) {
      score(score() + 10)  # Bullseye
    } else if (distance <= 10) {
      score(score() + 7)   # Inner circle
    } else if (distance <= 15) {
      score(score() + 5)   # Middle circle
    } else if (distance <= 20) {
      score(score() + 3)   # Outer circle
    } else {
      score(score())        # No score
    }
  })
  
  output$score <- renderText({
    paste("Total Score:", score())
  })
}

# Run the app
shinyApp(ui, server)
