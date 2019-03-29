--- 
title: "Mastering Shiny"
author: "Joe Cheng"
site: bookdown::bookdown_site
output:
  - bookdown::gitbook
  - rmarkdown::md_document
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
github-repo: jcheng5/shiny-book
description: "The official guide to the Shiny web application framework for R."
---

# Welcome {-}

This is the online version of _Mastering Shiny_, a book **currently under early development** and intended for a late 2020 release by [O'Reilly Media](https://www.oreilly.com/).

[Shiny](https://shiny.rstudio.com/) is a framework for creating web applications using R code. It is designed primarily with data scientists in mind, and to that end, you can create pretty complicated Shiny apps with no knowledge of HTML, CSS, or JavaScript. On the other hand, Shiny doesn't limit you to creating trivial or prefabricated apps: its user interface components can be easily customized or extended, and its server uses reactive programming to let you create any type of backend logic you want. Shiny is designed to feel almost magically easy when you're getting started, and yet the deeper you get into how it works, the more you realize it's built out of general building blocks that have strong software engineering principles behind them.

Today, Shiny is used in almost as many niches and industries as R itself is. It's used in academia as a teaching tool for statistical concepts, a way to get undergrads excited about learning to write code, a splashy medium for showing off novel statistical methods or models. It's used by big pharma companies to speed collaboration between scientists and analysts during drug development. It's used by Silicon Valley tech companies to set up realtime metrics dashboards that incorporate advanced analytics.

This book complements [Shiny's online documentation](https://shiny.rstudio.com/) and is intended to help app authors develop a deeper understanding of Shiny. After reading this book, you'll be able to write apps that have more customized UI, more maintainable code, and better performance and scalability.

## About the author {-}

Joe Cheng is the principal developer of Shiny and several of its supporting packages ([htmltools](https://cran.r-project.org/package=htmltools), [httpuv](https://cran.r-project.org/package=httpuv), [later](https://cran.r-project.org/package=later), and [promises](https://cran.r-project.org/package=promises)), and now leads the team responsible for Shiny and Shiny Server. He is the CTO of RStudio, which he joined in 2009.

## License {-}

This book is licensed to you under [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/).

The code samples in this book are licensed under [Creative Commons CC0 1.0 Universal (CC0 1.0)](https://creativecommons.org/publicdomain/zero/1.0/), i.e. public domain.

