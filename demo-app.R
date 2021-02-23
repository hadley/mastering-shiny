library(shiny)
attach(readRDS("data.rds"))

lapply(`_packages`, library, character.only = TRUE)
if (exists("_before")) {
  `_before`()
}

if (!exists("_server")) {
  `_server` <- function(input, output, session) {}
}

shinyApp(`_ui`, `_server`, enableBookmarking = `_bookmark`)
