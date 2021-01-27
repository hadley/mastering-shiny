# https://atlas.oreilly.com/oreillymedia/mastering-shiny
library(tidyverse)
library(fs)

dir_delete("_oreilly")
dir_create("_oreilly")
Sys.setenv(CI = "true") # don't rebuild demos

chapters <- setdiff(yaml::read_yaml("_bookdown.yml")$rmd_files, "index.Rmd")

# Build book --------------------------------------------------------------

format <- rmarkdown::md_document(variant = "markdown-fenced_code_attributes-raw_attribute", ext = ".asciidoc")
format$pandoc$args <- c(format$pandoc$args, "--wrap=none")


# TODO: use callr::r() to run in clean session
chapters[[3]] %>% walk(
  rmarkdown::render,
  format,
  output_dir = "_oreilly",
  quiet = TRUE
)

regexp <- googlesheets4::read_sheet("1b3j_fgnN19uvIG7XhSS7zepBTZO5vhbuEOXB5a_oT4Q")
regexp$Pattern <- gsub("\\\\n", "\n", regexp$Pattern)
regexp$Replacement <- gsub("\\\\n", "\n", regexp$Replacement)

munge_file <- function(path) {
  file <- read_file(path)

  for (i in seq_len(nrow(regexp))) {
    file <- str_replace_all(file, regex(regexp$Pattern[[i]], multiline = TRUE), regexp$Replacement[[i]])
  }

  write_file(file, path)
}

asciidoc <- dir_ls("_oreilly/", glob = "*.asciidoc")
asciidoc %>% walk(munge_file)


# indented code blocks - done
# captions - done
# parts - ([[unique_part_id]]\n[part])

# Copy additional resources -----------------------------------------------
library(dplyr)

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
