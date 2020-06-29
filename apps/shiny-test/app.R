library(shiny)
ui <- fluidPage(
  numericInput("x", "x", 0),
  numericInput("y", "y", 0)
)
server <- function(input, output, session) {
  observeEvent(input$x, {
    updateNumericInput(session, "y", value = input$x * 2)
  })
}

shinyApp(ui, server)
