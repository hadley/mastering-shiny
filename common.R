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


