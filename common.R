# load shiny first to avoid any conflict messages later
library(shiny)

knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  cache = FALSE
)

options(digits = 3)

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

makeApp <- function(ui, server = NULL, app_dir = tempfile(), deps = character()) {
  if (is.null(server)) {
    server <- function(input, output, session) {}
  }

  dir.create(app_dir)
  saveRDS(ui, file.path(app_dir, "ui.rds"))
  saveRDS(server, file.path(app_dir, "server.rds"))
  saveRDS(resource_paths_get(), file.path(app_dir, "resources.rds"))

  deps <- lapply(rlang::syms(deps), function(dep) expr(library(!!dep)))

  app <- rlang::expr({
    library(shiny)
    !!!deps

    ui <- readRDS("ui.rds")
    server <- readRDS("server.rds")
    resources <- readRDS("resources.rds")
    for (prefix in names(resources)) {
      shiny::addResourcePath(prefix, resources[[prefix]])
    }

    shinyApp(ui, server)
  })
  cat(rlang::expr_text(app), file = file.path(app_dir, "app.R"))

  app_dir
}

# Generate a ShinyDriver from ui and a server function
testApp <- function(ui, server = NULL, ...) {
  app_dir <- makeApp(ui, server, ...)
  shinytest::ShinyDriver$new(app_dir)
}

deployApp <- function(ui, server, name, deps = character()) {
  app_dir <- makeApp(ui, server, deps = deps)
  rsconnect::deployApp(app_dir, appName = name, server = "shinyapps.io")
}

ui_screenshot <- function(ui, name, width = 600, height = NA) {
  app_screenshot(testApp(ui, NULL), name, width = width, height = height)
}


# When knitr is running, used cached version if it exists
app_screenshot <- function(app, name, width = 600, height = NA) {
  path <- file.path("screenshots", paste0(name, ".png"))

  if (!isTRUE(getOption("knitr.in.progress")) || !file.exists(path)) {
    if (is.na(height)) {
      height <- app_height(app)
    }
    app$setWindowSize(width, height)
    app$takeScreenshot(path)
  }

  knitr::include_graphics(path, dpi = 72)
}

app_height <- function(app) {
  wd <- app$.__enclos_env__$private$web
  obj <- wd$findElement("body")
  rect <- obj$getRect()
  rect$height
}

app_record <- function(app) {
  shinytest::recordTest(app$.__enclos_env__$private$path)
}


# Resource paths ----------------------------------------------------------

resource_paths_get <- function() {
  resources <- shiny:::.globals$resources
  vapply(resources, "[[", "directoryPath", FUN.VALUE = character(1))
}
