# load shiny first to avoid any conflict messages later
library(shiny)

knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  cache = FALSE
)

# Masks readr::read_csv, and performs persistent download caching
read_csv <- function(file, ...) {
  if (grepl("^https?://", file)) {
    url <- file
    ext <- tools::file_ext(url)
    if (nchar(ext) > 0) {
      ext <- paste0(".", ext)
    }
    hash <- digest::digest(url, "sha1")

    dir.create("_download_cache", showWarnings = FALSE)

    file <- file.path("_download_cache", paste0(hash, ext))
    if (!file.exists(file)) {
      download.file(url, file, method = "libcurl")
    }
  }
  readr::read_csv(file, ...)
}


# Custom printing ---------------------------------------------------------
knit_print <- knitr::knit_print

knit_print.shiny.tag.list <- function(x, options = list(), ...) {

  if (isTRUE(options$raw_html)) {
    x <- htmltools::htmlEscape(x)
    knitr::asis_output(paste0("<pre><code>", x, "</code></pre>"))
  }
}
registerS3method("knit_print", "shiny.tag.list", knit_print.shiny.tag.list)

# Screenshot generation

# Generate a ShinyDriver from ui and a server function
testApp <- function(ui, server = NULL) {
  if (is.null(server)) {
    server <- function(input, output, session) {}
  }

  app_dir <- tempfile()
  dir.create(app_dir)
  saveRDS(ui, file.path(app_dir, "ui.rds"))
  saveRDS(server, file.path(app_dir, "server.rds"))

  app <- rlang::expr({
    library(shiny)
    ui <- readRDS("ui.rds")
    server <- readRDS("server.rds")

    shinyApp(ui, server)
  })
  cat(rlang::expr_text(app), file = file.path(app_dir, "app.R"))

  shinytest::ShinyDriver$new(app_dir)
}

app_screenshot <- function(ui, server, name, width = 600, height = 400) {
  path <- file.path("screenshots", paste0(name, ".png"))

  if (!file.exists(path)) {
    app <- testApp(ui, server)
    app$setWindowSize(width, height)
    app$takeScreenshot(path)
  }

  knitr::include_graphics(path, dpi = 72)
}

