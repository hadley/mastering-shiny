library(tidyverse)

logs <- vroom::vroom("cran-logs/2019-06-21.csv.gz", delim = ",")
logs


# Compare versions --------------------------------------------------------

r_version <- logs %>%
  filter(!is.na(r_version)) %>%
  separate(r_version, c("major", "minor", "patch")) %>%
  filter(major == 3) %>%
  select(package, major, minor, patch)
r_version

r_version %>%
  count(minor) %>%
  ggplot(aes(paste0("3.", minor), n / 1e3)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Binary downloads by R version",
    x = NULL,
    y = "Downloads (000s)"
  )

r_version %>%
  filter(package == "ggplot2") %>%
  count(minor) %>%
  ggplot(aes(paste0("3.", minor), n / 1e3)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Binary downloads by R version",
    x = NULL,
    y = "Downloads (000s)"
  )

r_version %>%
  mutate(pkg = ifelse(package == "ggplot2", "ggplot2", "other")) %>%
  count(pkg, minor) %>%
  group_by(pkg) %>%
  mutate(prop = n / sum(n)) %>%
  ggplot(aes(pkg, prop, fill = minor)) +
  geom_col() +
  scale_fill_viridis_d(guide = guide_legend(ncol = 2)) +
  coord_flip()


# Operating system --------------------------------------------------------

pkg <- logs %>% filter(package == "ggplot2")
pkg %>% count()
pkg %>% count(version = fct_lump(version, prop = 0.01), sort = TRUE)
pkg %>%
  count(os = fct_lump(fct_explicit_na(r_os, na_level = "(Source)"), prop = 0.01), sort = TRUE)

  filter(major == 3) %>%
  count(major, minor) %>%
  arrange(desc(major), desc(minor)) %>%
  mutate(prop = n / sum(n))

pkg %>%
  separate(r_version, c("major", "minor", "patch")) %>%
  count(patch)

