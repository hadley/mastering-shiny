shiny:::withPrivateSeed(set.seed(100))

#' @examples
#' library(shiny)
#' ui <- fluidPage("Hello world!")
#' app <- demoApp$new("hello-world", ui)
#' app$running
#' app$reset()
#' app$resize(100)$takeScreenshot("test-100")
#' app$resize(600)$takeScreenshot("test-600")
#' app$deploy()


demoApp <- R6::R6Class("demoApp", public = list(
  name = character(),
  ui = NULL,
  server = NULL,
  data = NULL,

  running = FALSE,
  driver = NULL,

  initialize = function(name, ui, server = NULL, env = parent.frame()) {
    self$name <- name
    self$ui <- ui
    self$server <- server
    self$data <- app_data(server, ui, env)

    fs::dir_create(self$path())
    self$run()
  },

  run = function() {
    self$running <- self$outdated() && !is_ci()

    if (self$running) {
      rlang::inform("Starting ShinyDriver")
      file.copy("demo-app.R", self$path("app.R"))
      saveRDS(self$data, self$path("data.rds"))

      self$driver <- shinytest::ShinyDriver$new(self$path())
      self$resize(600)
    }
  },

  reset = function() {
    self$finalize()
    fs::file_delete(self$path("data.rds"))
    self$run()
  },

  outdated = function() {
    if (!file.exists(self$path("data.rds"))) {
      rlang::inform(paste0("Initialising ", self$name))
      return(TRUE)
    }
    data_old <- readRDS(self$path("data.rds"))

    diff <- waldo::compare(data_old, self$data, x_arg = "old", y_arg = "new")
    if (length(diff) == 0) {
      FALSE
    } else {
      rlang::inform(paste0(
        self$name, " has changed:\n",
        paste0(diff, collapse = "\n\n")
      ))
      TRUE
    }
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
      self$driver$waitForShiny()
    }
    invisible(self)
  },

  setInputs = function(...) {
    if (self$running) {
      self$driver$setInputs(...)
    }
    invisible(self)
  },

  sendKeys = function(name, keys) {
    if (self$running) {
      self$driver$sendKeys(name, keys)
    }
    invisible(self)
  },
  click = function(id) {
    if (self$running) {
      self$driver$click(id)
    }
    invisible(self)
  },

  execute_js = function(js) {
    if (self$running) {
      self$driver$executeScript(js)
    }
    invisible(self)
  },

  dropDown = function(id, pos = NULL) {
    js <- glue::glue('
      $("#{id}")
        .siblings()
        .filter(".selectize-control")
        .find(".selectize-input")
        .click();
    ')
    self$execute_js(js)

    if (!is.null(pos)) {
      js <- glue::glue('
        $($("#{id}")
          .siblings()
          .filter(".selectize-control")
          .find(".selectize-dropdown-content")
          .children()
          .get({pos - 1}))
          .mouseenter();
        ')
      self$execute_js(js)
    }

    invisible(self)
  },

  takeScreenshot = function(path = "screenshot", id = NULL, parent = FALSE) {
    path <- self$path(path, ext = "png")
    if (self$running) {
      rlang::inform("Taking screenshot")
      self$driver$takeScreenshot(path, id = id, parent = parent)
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
      unlink(self$path("app.R"))
      self$running <- FALSE
    }
  },

  launch = function() {
    if (self$running) {
      browseURL(demo$driver$getUrl())
    }
  },

  deploy = function(quiet = TRUE) {
    if (self$running) {
      rlang::inform(paste("Deploying ", self$name, " to shinyapps.io"))
      if (!requireNamespace("rsconnect", quietly = TRUE)) {
        return(invisible(self))
      }

      rsconnect::deployApp(
        appDir = self$path(),
        appName = paste0("ms-", self$name),
        appTitle = paste0("Mastering Shiny: ", self$name),
        server = "shinyapps.io",
        forceUpdate = TRUE,
        logLevel = if (quiet) "quiet" else "normal",
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
  },

  caption = function(text = NULL) {
    paste0(
      text, if (!is.null(text)) " ",
      "See live at ", self$link(), "."
    )
  }
))

# server + ui -> app ------------------------------------------------------

app_data <- function(server, ui, env = parent.frame()) {
  globals <- app_server_globals(server, env)

  data <- strip_srcrefs(globals$globals)
  data$ui <- ui
  data$server <- strip_srcrefs(server)
  data$resources <- shiny::resourcePaths()
  data$packages <- globals$packages
  data
}

app_server_globals <- function(server, env = parent.frame()) {
  # Work around for https://github.com/HenrikBengtsson/globals/issues/61
  env <- new.env(parent = env)
  env$output <- NULL

  globals <- globals::globalsOf(server, envir = env, recursive = FALSE)
  globals <- globals::cleanup(globals)

  # remove globals found in packages
  pkgs <- globals::packagesOf(globals)
  in_package <- vapply(
    attr(globals, "where"),
    function(x) !is.null(attr(x, "name")),
    logical(1)
  )
  globals <- globals[!in_package]
  attributes(globals) <- list(names = names(globals))

  # https://github.com/HenrikBengtsson/globals/issues/61
  globals$output <- NULL

  list(
    globals = globals,
    packages = pkgs
  )
}

strip_srcrefs <- function(x) {
  if (is.list(x)) {
    lapply(x, strip_srcrefs)
  } else if (is.function(x)) {
    removeSource(x)
  } else {
    x
  }
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

resourcePathReset <- function() {
  for (prefix in names(shiny::resourcePaths())) {
    shiny::removeResourcePath(prefix)
  }
}

is_ci <- function() isTRUE(as.logical(Sys.getenv("CI")))

"%||%" <- function(x, y) if (is.null(x)) y else x
