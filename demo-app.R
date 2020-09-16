library(shiny)
attach(readRDS("data.rds"))

lapply(`_packages`, library, character.only = TRUE)
for (prefix in names(`_resources`)) {
  shiny::addResourcePath(prefix, `_resources`[[prefix]])
}

if (!exists("_server")) {
  `_server` <- function(input, output, session) {}
}

shinyApp(`_ui`, `_server`)
