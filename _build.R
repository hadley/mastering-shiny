library(tidyverse)
library(fs)

chapters <- setdiff(yaml::read_yaml("_bookdown.yml")$rmd_files, "index.Rmd")
chapters_md <- path("_oreilly", path_ext_set(chapters, ".md"))
names(chapters_md) <- path_ext_remove(path_file(chapters_md))

# Build book --------------------------------------------------------------

render_clean <- function(path, ...) {
  message("Rendering ", path)
  callr::r(function(...) rmarkdown::render(...), list(path, ...), spinner = TRUE)
}

format <- rmarkdown::md_document(variant = "markdown-fenced_code_attributes-raw_attribute")
format$pandoc$args <- c(format$pandoc$args, "--wrap=preserve")

Sys.setenv(CI = "true") # don't rebuild demos
chapters %>% walk(
  render_clean,
  output_format = format,
  output_dir = "_oreilly"
)

# Convert from md to asciidoc ---------------------------------------------
#
# replace_lines <- function(file, pattern, replacement, comments = FALSE) {
#   str_replace_all(file, regex(pattern, multiline = TRUE, comments = comments), replacement)
# }
#
# # Regular expressions mostly contributed by Nicholas Adams, O'Reilly
# md2asciidoc <- function(file) {
#   # Headings with and without ids
#   file <- replace_lines(file, r"(
#     ^\#\ \(PART\\\*\) # standard part marker
#     (.*?)\            # title
#     \{\#
#       ([-a-zA-Z]+)         # id
#       (\ .unnumbered)?
#     \}
#     )", "[part]\n== \\1", comments = TRUE)
#   file <- replace_lines(file, '(^# )(.*?)(\\{#)(.*?)(\\})', '[[\\4]]\n== \\2')     # Chapter heading with ID
#   file <- replace_lines(file, '(^# )(.*?)(\\{#)(.*?)(\\})', '[[\\4]]\n== \\2')     # Chapter heading with ID
#   file <- replace_lines(file, '(^## )(.*?)(\\{#)(.*?)(\\})', '[[\\4]]\n=== \\2')   # A-Head with ID
#   file <- replace_lines(file, '(^## )(.*?)', '=== \\2')                            # A-Head no ID
#   file <- replace_lines(file, '(^### )(.*?)(\\{#)(.*?)(\\})', '[[\\4]]\n==== \\2') # B-Head with ID
#   file <- replace_lines(file, '(^### )(.*?)', '==== \\2')                          # B-Head no ID
#
#   # Code blocks
#   file <- replace_lines(file, '(^ *)(```)(.*?)(\n)((.|\n)*?)(```)', '\\1[source,\\3]\n\\1----\n\\5----')
#
#   # Figures
#   file <- replace_lines(file, '(<img src=")(.*?)(")(.*?)(/>)(\n)(<p class="caption">)\n(.*?)\n(</p>)', '.\\8\nimage::\\2["\\8"]')
#   file <- replace_lines(file, '(<img src=")(.*?)(")(.*?)(/>)', 'image::\\2[]')
#   file <- replace_lines(file, '(::: \\{.figure\\})((.|\n)*?)(:::)', '\\2') # Remove figures
#
#   # Cross refs
#   file <- replace_lines(file, '(Section )(\\\\@ref\\()(.*?)(\\))', '<<\\3>>') # Section
#   file <- replace_lines(file, '(Chapter )(\\\\@ref\\()(.*?)(\\))', '<<\\3>>') # Chapter
#   file <- replace_lines(file, '(Figure )(\\\\@ref\\()(fig:)(.*?)(\\))', '<<fig-\\4>>') # Figures
#
#   # Other formatting
#   file <- replace_lines(file, '(::: \\{.rmdnote\\})((.|\n)*?)(:::)', '****\\2****') # Sidebar
#   file <- replace_lines(file, '(<https:)(.*?)(>)', 'https:\\2[]') # Links
#   file <- replace_lines(file, '(\\[.*?\\])(\\()(https?:)(.*?)(\\))', '\\3\\4\\1') # Links with anchor text
#   file <- replace_lines(file, '(\\[\\^.*?\\])((.|\n)*?)(\\1: )(.*?)(\n)', 'footnote:[\\5]\\2') # Footnotes
#   file
# }
#
# asciidoc <- chapters_md %>% map(~ md2asciidoc(read_file(.)))
#
# walk2(asciidoc, path_ext_set(chapters_md, ".asciidoc"), write_file)

# Copy over images ------------------------------------------------------------

dir_copy("demos", "_oreilly")
file_delete(dir_ls("_oreilly/demos", recurse = T, glob = "*.rds"))

dir_copy("diagrams", "_oreilly")
file_delete(dir_ls("_oreilly/diagrams", recurse = T, glob = "*.graffle"))

dir_copy("images", "_oreilly")


# Copy everything into O'Reilly git repo ----------------------------------
# https://atlas.oreilly.com/oreillymedia/mastering-shiny

system("cp -r _oreilly/* ../oreilly")
