<!-- badges: start -->
[![Travis build status](https://travis-ci.org/jcheng5/shiny-book.svg?branch=master)](https://travis-ci.org/jcheng5/shiny-book)
<!-- badges: end -->

This is the work-in-progress repo for the book _Mastering Shiny_ by Joe Cheng.

Built with [bookdown](https://bookdown.org/yihui/bookdown/).

## Table of contents

1. Shiny 101
    1. Your first Shiny app
    2. Basic UI
    3. Basic reactivity

2. Case study: Data explorer
    1. Upload or choose data set
    2. Select variables
    3. Filter rows
    4. Visualize
    5. Select data points for drilldown

3. Shiny in action
    1. Uploading/downloading data
    1. Generating static reports from Shiny
    1. Tables
    1. Graphics
       * `renderCachedPlot()`
       * [Interactive plots](https://shiny.rstudio.com/articles/plot-interaction.html)
       * [`renderImage()`](https://shiny.rstudio.com/articles/images.html)
    1. Multipage apps and modules
    1. Programming the tidyverse

4. Mastering UI
    1. Dashboards
    1. Shiny gadgets
    1. Dynamic UI
    1. User feedback
        * [Progress bars](https://shiny.rstudio.com/articles/progress.html)
        * [Validation](https://shiny.rstudio.com/articles/validation.html)
        * [Notifications](https://shiny.rstudio.com/articles/notifications.html)
    1. Custom HTML
    1. htmlwidgets

5. Mastering reactivity
    1. Reactive programming in depth
       * [Execution scheduling](https://shiny.rstudio.com/articles/execution-scheduling.html)
    1. Side-effects
        * `isolate()`
        * `actionButton()`
    1. Scoping
       * Code organisation
       * [Using scopes to manage object lifetimes](https://shiny.rstudio.com/articles/scoping.html)
       * Sharing working between users
       * Making an app in a function
       * Connecting to databases
    1. Async programming with promises
    1. Reactivity implementation details

5. Taming Shiny
    1. Troubleshooting and debugging
    1. Testing with shinytest
    1. Managing dependencies with packrat
    1. Performance and scalability
       *  Load testing with shinyloadtest
    1. Deployment options

7. Appendix
    1. Bookmarkable state
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
