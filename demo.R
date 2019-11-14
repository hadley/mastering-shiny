
#' @examples
#' ui <- fluidPage("Hello world!")
#' app <- demo_inline("hello-world", ui)
#' app$running
#' app$reset()
#' app$resize(100)$screenshot("test-100")
#' app$resize(600)$screenshot("test-600")
#' app$deploy()
demo_inline <- function(name,
                     ui,
                     server = NULL,
                     packages = character(),
                     data = list()
                     ) {

  server <- strip_srcrefs(server)
  data <- lapply(data, strip_srcrefs)

  demoApp$new(name, ui = ui, server = server, packages = packages, data = data)
}

demoApp <- R6::R6Class("demoApp", public = list(
  name = character(),
  ui = NULL,
  server = NULL,
  packages = NULL,
  data = NULL,

  running = FALSE,
  driver = NULL,

  initialize = function(name, ui, server = NULL, packages = character(), data = list()) {
    self$name <- name
    self$ui <- ui
    self$server <- server
    self$packages <- packages
    self$data <- data

    fs::dir_create(self$path())
    self$run()
  },

  run = function() {
    self$running <- self$outdated()

    if (self$running) {
      app_from_components(self$path(), self$ui, self$server, self$packages, self$data)
      message("Starting ShinyDriver")
      self$driver <- shinytest::ShinyDriver$new(self$path())
      self$resize(600)
      self$save_hash()
    }
  },

  reset = function() {
    self$finalize()
    fs::file_delete(self$path("HASH"))
    self$run()
  },

  hash = function() {
    digest::digest(list(self$ui, self$server, self$packages, self$data))
  },

  save_hash = function() {
    writeLines(self$hash(), self$path("HASH"))
  },

  outdated = function() {
    path <- self$path("HASH")
    if (!fs::file_exists(path)) {
      return(TRUE)
    }

    readLines(path) != self$hash()
  },

  path = function(...) {
    fs::path("demos", self$name, ...)
  },

  resize = function(width, height = NULL) {
    if (self$running) {
      if (!is.null(height)) {
        self$driver$setWindowSize(width, height)
      } else {
        self$driver$setWindowSize(width, 100)
        height <- app_height(self$driver)
        self$driver$setWindowSize(width, height)
      }
    }
    invisible(self)
  },

  set_values = function(...) {
    if (self$running) {
      vals <- rlang::list2(...)
      for (nm in names(vals)) {
        self$driver$setValue(nm, vals[[nm]])
      }
    }
    invisible(self)
  },

  screenshot = function(path = "screenshot") {
    path <- self$path(path, ext = "png")
    if (self$running) {
      message("Taking screenshot")
      self$driver$takeScreenshot(path)
    } else {
      if (!fs::file_exists(path)) {
        stop("'", path, "' doesn't exist and app isn't running", call. = FALSE)
      }
    }

    knitr::include_graphics(path, dpi = screenshot_dpi())
  },

  finalize = function() {
    if (self$running) {
      self$driver$stop()
      self$running <- FALSE
    }
  },

  launch = function() {
    if (self$running) {
      browseURL(demo$driver$getUrl())
    }
  },

  deploy = function() {
    if (self$running) {
      message("Deploying to shinyapps.io")
      rsconnect::deployApp(
        appDir = self$path(),
        appName = paste0("ms-", self$name),
        appTitle = paste0("Mastering Shiny: ", self$name),
        server = "shinyapps.io",
        forceUpdate = TRUE,
        logLevel = "quiet",
        launch.browser = FALSE
      )
      fs::dir_delete(self$path("rsconnect"))
    }

    invisible(self)
  },

  link = function() {
    paste0("<https://hadley.shinyapps.io/ms-", self$name, ">")
  },

  figure = function() {
    paste0("Figure \\@ref(fig:", self$name, ")")
  }
))


strip_srcrefs <- function(x) {
  if (is.function(x)) {
    removeSource(x)
  } else {
    x
  }
}

missing_server <- strip_srcrefs(function(input, output, session) {})

app_from_components <- function(app_dir, ui, server = NULL, deps = character(), data = list()) {
  if (is.null(server)) {
    server <- missing_server
  }

  data <- modifyList(
    data,
    list(
      ui = ui,
      server = server,
      resources = resource_paths_get()
    )
  )
  saveRDS(data, file.path(app_dir, "data.rds"))

  deps <- lapply(rlang::syms(deps), function(dep) rlang::expr(library(!!dep)))
  app <- rlang::expr({
    library(shiny)
    !!!deps

    data <- attach(readRDS("data.rds"))
    for (prefix in names(resources)) {
      shiny::addResourcePath(prefix, resources[[prefix]])
    }

    shinyApp(ui, server)
  })
  cat(rlang::expr_text(app), file = file.path(app_dir, "app.R"))

  invisible()
}



# Helpers -----------------------------------------------------------------

app_height <- function(app) {
  wd <- app$.__enclos_env__$private$web
  obj <- wd$findElement("body")
  rect <- obj$getRect()
  rect$height
}

# Controls the size of automated shiny screenshots via app_screenshot().
# I don't understand why these values need to be different, they've been
# determined empirically.
screenshot_dpi <- function() {
  if (knitr::is_latex_output()) {
    120
  } else {
    96
  }
}

resource_paths_get <- function() {
  resources <- shiny:::.globals$resources
  vapply(resources, "[[", "directoryPath", FUN.VALUE = character(1))
}
