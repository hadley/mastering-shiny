{
    library(shiny)
    data <- attach(readRDS("data.rds"))
    for (prefix in names(resources)) {
        shiny::addResourcePath(prefix, resources[[prefix]])
    }
    shinyApp(ui, server)
}