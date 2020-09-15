# load shiny first to avoid any conflict messages later
library(shiny)

knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  # cache = TRUE,
  fig.retina = 0.8, # figures are either vectors or 300 dpi diagrams
  dpi = 300,
  out.width = "70%",
  fig.align = 'center',
  fig.width = 6,
  fig.asp = 0.618,  # 1 / phi
  fig.show = "hold",
  eval.after = 'fig.cap' # so captions can use link to demos
)

options(digits = 3)

# In final book can go up to 81
# http://oreillymedia.github.io/production-resources/styleguide/#code
# See preamble.tex for tweak that makes this work in pdf output
knitr::opts_chunk$set(width = 81)
options(width = 81)

# Suppress crayon since it's falsely on in GHA
options(crayon.enabled = FALSE)

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

# Reactive console simulation  -------------------------------------------------
# See discussion at https://github.com/rstudio/shiny/issues/2518

reactive_console_funs <- list(
  reactiveVal = function(value = NULL, label = NULL) {
    if (missing(label)) {
      call <- sys.call()
      label <- shiny:::rvalSrcrefToLabel(attr(call, "srcref", exact = TRUE))
    }

    rv <- shiny::reactiveVal(value, label)
    function(x) {
      if (missing(x)) {
        rv()
      } else {
        on.exit(shiny:::flushReact(), add = TRUE, after = FALSE)
        rv(x)
      }
    }
  },
  reactiveValues = function(...) {
    rv <- shiny::reactiveValues(...)
    class(rv) <- c("rv_flush_on_write", class(rv))
    rv
  },
  `$<-.rv_flush_on_write` = function(x, name, value) {
    on.exit(shiny:::flushReact(), add = TRUE, after = FALSE)
    NextMethod()
  }
)

consoleReactive <- function(state) {
  if (state) {
    options(shiny.suppressMissingContextError = TRUE)
    attach(reactive_console_funs, name = "reactive_console", warn.conflicts = FALSE)
  } else {
    options(shiny.suppressMissingContextError = FALSE)
    detach("reactive_console")
  }
}

# Code extraction ---------------------------------------------------------

section_get <- function(path, name) {
  lines <- vroom::vroom_lines(path)
  start <- which(grepl(paste0("^\\s*#<< ", name), lines))

  if (length(start) == 0) {
    stop("Couldn't find '#<<", name, "'", call. = FALSE)
  }
  if (length(start) > 1) {
    stop("Found multiple '#<< ", name, "'", call. = FALSE)
  }

  # need to build stack of #<< #>> so we can have nested components

  end <- which(grepl("\\s*#>>", lines))
  end <- end[end > start]

  if (length(end) == 0) {
    stop("Couldn't find '#>>", call. = FALSE)
  }
  end <- end[[1]]

  lines[(start + 1):(end - 1)]
}

section_strip <- function(path) {
  lines <- vroom::vroom_lines(path)
  sections <- grepl("^#(>>|<<)", lines)
  lines[!sections]
}
