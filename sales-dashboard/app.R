library(dplyr)
library(shiny)

# https://www.kaggle.com/kyanyoga/sample-sales-data
# License: CC-0
sales <- vroom::vroom("sales_data_sample.csv")

library(shiny)
ui <- fluidPage(
  titlePanel("Sales Dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput("territory", "Territory", choices = unique(sales$TERRITORY)),
      selectInput("customername", "Customer", choices = NULL),
      selectInput("ordernumber", "Order number", choices = NULL, size = 5, selectize = FALSE),
    ),
    mainPanel(
      uiOutput("customer"),
      tableOutput("data")
    )
  )
)
server <- function(input, output, session) {
  territory <- reactive({
    req(input$territory)
    if (input$territory == "NA") {
      filter(sales, is.na(TERRITORY))
    } else {
      filter(sales, TERRITORY == input$territory)
    }
  })
  customer <- reactive({
    req(input$customername)
    filter(territory(), CUSTOMERNAME == input$customername)
  })

  output$customer <- renderUI({
    row <- customer()[1, ]
    tags$div(
      class = "well",
      tags$p(tags$strong("Name: "), row$CUSTOMERNAME),
      tags$p(tags$strong("Phone: "), row$PHONE),
      tags$p(tags$strong("Contact: "), row$CONTACTFIRSTNAME, " ", row$CONTACTLASTNAME)
    )
  })

  order <- reactive({
    req(input$ordernumber)
    customer() %>%
      filter(ORDERNUMBER == input$ordernumber) %>%
      arrange(ORDERLINENUMBER) %>%
      select(PRODUCTLINE, QUANTITYORDERED, PRICEEACH, SALES, STATUS)
  })

  output$data <- renderTable(order())

  observeEvent(territory(), {
    updateSelectInput(session, "customername", choices = unique(territory()$CUSTOMERNAME), selected = character())
  })
  observeEvent(customer(), {
    updateSelectInput(session, "ordernumber", choices = unique(customer()$ORDERNUMBER))
  })

}
shinyApp(ui, server)
