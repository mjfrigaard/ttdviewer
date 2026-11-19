#' Launch the #TidyTuesday Data Viewer
#'
#' @param mode `"start"` (default) calls [shiny::startApp()] and returns the
#'   `ShinyAppHandle`. The app runs in the background and the console stays
#'   available (see Details). `"run"` returns the `shiny.appobj` for
#'   [shiny::runApp()] to run; the console is blocked until the app stops.
#'   Use `"run"` in an `app.R` file for deployment.
#' @param options List of options passed to [shiny::shinyApp()].
#' @param run Display mode for interactive RStudio or Positron sessions,
#'   passed to [display_type()]. Default `"b"` (external browser).
#' @param ... In `mode = "start"`, additional arguments passed to
#'   [shiny::startApp()] (e.g., `port`, `host`). Ignored in `mode = "run"`.
#'
#' @details
#' `mode = "start"` needs Shiny >= 1.14.0. The returned handle has
#' `status()`, `url()`, `result()`, and `stop()`. Call `handle$stop()` from
#' the console to shut the app down; starting a new app stops the one
#' already running.
#'
#' @return `mode = "run"`: a `shiny.appobj`. `mode = "start"`: a
#'   `ShinyAppHandle`.
#'
#' @import shiny
#'
#' @export
#'
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # non-blocking: the console stays available while the app runs
#'   handle <- launch()
#'   handle$url()
#'   handle$stop()
#'
#'   # blocking: what app.R uses for deployment
#'   launch(mode = "run")
#' }
#' }
launch <- function(mode = c("start", "run"), options = list(), run = "b", ...) {
  mode <- match.arg(mode)
  display_type(run = run)
  # load_tt_data() looks up all_tt_combined in the global environment
  if (!exists("all_tt_combined", envir = .GlobalEnv)) {
    utils::data("all_tt_combined", package = "ttdviewer", envir = .GlobalEnv)
  }
  app <- shinyApp(ui = app_ui(), server = app_server, options = options)

  if (mode == "start") {
    return(startApp(app, ...))
  }
  app
}
