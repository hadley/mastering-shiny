# https://atlas.oreilly.com/oreillymedia/mastering-shiny
library(fs)
library(dplyr)

dir_create("_oreilly")
Sys.setenv(CI = "true") # don't rebuild demos

chapters <- setdiff(yaml::read_yaml("_bookdown.yml")$rmd_files, "index.Rmd")

# Build book --------------------------------------------------------------
# Clean out caches, figures, and previously built files

asciidoc <- rmarkdown::output_format(
  knitr = list(), # already set in common
  keep_md = TRUE,
  pandoc = rmarkdown::pandoc_options(
    to = "asciidoc",
    from = rmarkdown::from_rmarkdown(implicit_figures = FALSE)
  ),
  clean_supporting = FALSE
)

rmarkdown::render("basic-app.Rmd", asciidoc, output_dir = "_oreilly")
rmarkdown::render("basic-ui.Rmd", asciidoc, output_dir = "_oreilly")

# why aren't demos producing figures?
# why are heading ids and figures getting lost?
# captions?
# need to render in clean session
# how to handle sidebars

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
