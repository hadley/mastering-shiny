# https://atlas.oreilly.com/oreillymedia/mastering-shiny
library(tidyverse)
library(fs)

chapters <- setdiff(yaml::read_yaml("_bookdown.yml")$rmd_files, "index.Rmd")

# Build book --------------------------------------------------------------

render_clean <- function(path, ...) {
  message("Rendering ", path)
  callr::r(function(...) rmarkdown::render(...), list(path, ...), spinner = TRUE)
}

format <- rmarkdown::md_document(variant = "markdown-fenced_code_attributes-raw_attribute")
format$pandoc$args <- c(format$pandoc$args, "--wrap=none")

Sys.setenv(CI = "true") # don't rebuild demos
chapters %>% walk(
  render_clean,
  output_format = format,
  output_dir = "_oreilly"
)

# Convert from md to asciidoc ---------------------------------------------
replace_lines <- function(file, pattern, replacement) {
  str_replace_all(file, regex(pattern, multiline = TRUE), replacement)
}

# Regular expressions mostly contributed by Nicholas Adams, O'Reilly
md2asciidoc <- function(path) {
  file <- read_file(path)

  # Headings with and without ids
  file <- replace_lines(file, '(^# )(.*?)(\\{#)(.*?)(\\})', '[[\\4]]\n== \\2')     # Chapter heading with ID
  file <- replace_lines(file, '(^## )(.*?)(\\{#)(.*?)(\\})', '[[\\4]]\n=== \\2')   # A-Head with ID
  file <- replace_lines(file, '(^## )(.*?)', '=== \\2')                            # A-Head no ID
  file <- replace_lines(file, '(^### )(.*?)(\\{#)(.*?)(\\})', '[[\\4]]\n==== \\2') # B-Head with ID
  file <- replace_lines(file, '(^### )(.*?)', '==== \\2')                          # B-Head no ID

  # Code blocks
  file <- replace_lines(file, '(^ *)(```)(.*?)(\n)((.|\n)*?)(```)', '\\1[source,\\3]\n\\1----\n\\5----')

  # Figures
  file <- replace_lines(file, '(<img src=")(.*?)(")(.*?)(/>)(\n)(<p class="caption">)\n(.*?)\n(</p>)', '.\\8\nimage::\\2["\\8"]')
  file <- replace_lines(file, '(<img src=")(.*?)(")(.*?)(/>)', 'image::\\2[]')
  file <- replace_lines(file, '(::: \\{.figure\\})((.|\n)*?)(:::)', '\\2') # Remove figures

  # Cross refs
  file <- replace_lines(file, '(Section )(\\\\@ref\\()(.*?)(\\))', '<<\\3>>') # Section
  file <- replace_lines(file, '(Chapter )(\\\\@ref\\()(.*?)(\\))', '<<\\3>>') # Chapter
  file <- replace_lines(file, '(Figure )(\\\\@ref\\()(fig:)(.*?)(\\))', '<<fig-\\4>>') # Figures

  # Other formatting
  file <- replace_lines(file, '(::: \\{.rmdnote\\})((.|\n)*?)(:::)', '****\\2****') # Sidebar
  file <- replace_lines(file, '(<https:)(.*?)(>)', 'https:\\2[]') # Links
  file <- replace_lines(file, '(\\[.*?\\])(\\()(https?:)(.*?)(\\))', '\\3\\4\\1') # Links with anchor text
  file <- replace_lines(file, '(\\[\\^.*?\\])((.|\n)*?)(\\1: )(.*?)(\n)', 'footnote:[\\5]\\2') # Footnotes

  write_file(file, path_ext_set(path, ".asciidoc"))
}

path_ext_set(chapters, ".md") %>%
  path("_oreilly", .) %>%
  walk(md2asciidoc)

# parts - ([[unique_part_id]]\n[part])

# Copy additional resources -----------------------------------------------

resources <- tibble(chapter = chapters) %>%
  rowwise(chapter) %>%
  summarise(rmarkdown::find_external_resources(chapter))

paths <- resources %>% filter(web) %>% pull(path) %>% unique() %>% sort()
dirs <- paths %>% path_dir() %>% unique()
dir_create(path("_oreilly", dirs))
file_copy(paths, path("_oreilly", paths))

# Copy demos, since they're added dynamically
dir_copy("demos", "_oreilly")
rds <- dir_ls("_oreilly/demos", recurse = T, glob = "*.rds")
file_delete(rds)
