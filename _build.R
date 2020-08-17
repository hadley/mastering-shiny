library(fs)

# So we don't rebuild any demos
withr::local_envvar(list(CI = "true"))

dir_delete("_book")

rmarkdown::render_site(
  output_format = rmarkdown::md_document("markdown"),
  quiet = TRUE
)

file_delete(dir_ls("_book", glob = "*.html"))
dir_delete("_book/libs")
file_delete("_book/index.md")

# From r4ds  ----------------------------------------------------------------

chapters <- dir("_bookdown_files", full.names = TRUE, pattern = "_files$")

figures <- dir(chapters, full.names = TRUE, pattern = "-latex")

name <- figures %>%
  dirname() %>%
  basename() %>%
  str_replace("_files", "")

out_path <- file.path("figures", name)

dir.create("figures/")
out_path %>% walk(dir.create)

map2(figures, out_path, ~ file.copy(dir(.x, full.names = TRUE), .y))
