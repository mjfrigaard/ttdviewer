# Launch the \#TidyTuesday Data Viewer

Launch the \#TidyTuesday Data Viewer

## Usage

``` r
launch(mode = c("start", "run"), options = list(), run = "b", ...)
```

## Arguments

- mode:

  `"start"` (default) calls
  [`shiny::startApp()`](https://rdrr.io/pkg/shiny/man/startApp.html) and
  returns the `ShinyAppHandle`. The app runs in the background and the
  console stays available (see Details). `"run"` returns the
  `shiny.appobj` for
  [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html) to run;
  the console is blocked until the app stops. Use `"run"` in an `app.R`
  file for deployment.

- options:

  List of options passed to
  [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html).

- run:

  Display mode for interactive RStudio or Positron sessions, passed to
  [`display_type()`](https://mjfrigaard.github.io/ttdviewer/reference/display_type.md).
  Default `"b"` (external browser).

- ...:

  In `mode = "start"`, additional arguments passed to
  [`shiny::startApp()`](https://rdrr.io/pkg/shiny/man/startApp.html)
  (e.g., `port`, `host`). Ignored in `mode = "run"`.

## Value

`mode = "run"`: a `shiny.appobj`. `mode = "start"`: a `ShinyAppHandle`.

## Details

`mode = "start"` needs Shiny \>= 1.14.0. The returned handle has
`status()`, [`url()`](https://rdrr.io/r/base/connections.html),
`result()`, and [`stop()`](https://rdrr.io/r/base/stop.html). Call
`handle$stop()` from the console to shut the app down; starting a new
app stops the one already running.

## Examples

``` r
if (FALSE) { # \dontrun{
if (interactive()) {
  # non-blocking: the console stays available while the app runs
  handle <- launch()
  handle$url()
  handle$stop()

  # blocking: what app.R uses for deployment
  launch(mode = "run")
}
} # }
```
