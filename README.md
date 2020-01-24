<!-- badges: start -->
[![Build Status](https://github.com/hadley/mastering-shiny/workflows/.github/workflows/build-book.yaml/badge.svg)](https://github.com/hadley/mastering-shiny/actions?workflow=.github/workflows/build-book.yaml)
<!-- badges: end -->

This is the work-in-progress repo for the book _Mastering Shiny_ by Hadley Wickham. It is licensed under the Creative Commons [Attribution-NonCommercial-NoDerivatives 4.0 International License](http://creativecommons.org/licenses/by-nc-nd/4.0/). 

Built with [bookdown](https://bookdown.org/yihui/bookdown/).

## Table of contents

1. Shiny 101

1. Shiny in action

1. Mastering UI
    1. Tables
    1. Graphics
       * `renderCachedPlot()`
       * [Interactive plots](https://shiny.rstudio.com/articles/plot-interaction.html)
       * [`renderImage()`](https://shiny.rstudio.com/articles/images.html)
    1. Multipage apps
    1. Dashboards
    1. Shiny gadgets
    1. Dynamic UI
    1. htmlwidgets
    1. Custom HTML

1. Mastering reactivity
    1. Reactive components 
    1. Dependency tracking
    1. Scoping
       * Code organisation
       * [Using scopes to manage object lifetimes](https://shiny.rstudio.com/articles/scoping.html)
       * Sharing working between users
       * Making an app in a function
       * Connecting to databases
    1. Advanced techniques
        * `reactiveValues()`
        * `isolate()`
    1. Async programming with promises

1. Shiny in production
    1. Troubleshooting and debugging
    1. Testing with shinytest
    1. Managing dependencies with packrat
    1. Performance and scalability
       *  Load testing with shinyloadtest
    1. Deployment options

1. Appendix
    1. Server-side selectize and DT
    1. R Markdown integration
    1. Reproducibility

## Images

There are three directories for images:

* `diagrams/` contains omnigraffle diagrams. Source of truth is `.graffle` 
  files. Can delete all subdirectories.
  
* `screenshots/` contains programmatic screenshots. Source of truth is 
  book code. Can delete all subdirectories.
  
* `images/` contains images created some other way. Images are source of
  truth and should not be deleted.
