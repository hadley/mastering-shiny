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
