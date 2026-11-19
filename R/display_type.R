#' Set the Shiny app display
#'
#' Sets `shiny.launch.browser` for RStudio or Positron. Does nothing outside
#' an interactive session or outside those IDEs.
#'
#' @param run Display mode: `"p"` (viewer pane), `"b"` (external browser),
#'   `"w"` (viewer window), or `"NULL"` (unset the option).
#'
#' @return `NULL`, invisibly. Called for its side effect on `options()`.
#'
#' @keywords internal
#'
display_type <- function(run = "w") {
  if (!interactive()) {
    logr_msg("App not running in interactive session", level = "INFO")
    return(invisible(NULL))
  }

  if (Sys.getenv("RSTUDIO") == "1") {
    switch(
      run,
      p = options(shiny.launch.browser = .rs.invokeShinyPaneViewer),
      b = options(shiny.launch.browser = .rs.invokeShinyWindowExternal),
      w = options(shiny.launch.browser = .rs.invokeShinyWindowViewer),
      NULL = options(shiny.launch.browser = NULL)
    )
    environment <- "RStudio"
    viewer_type <- getOption("shiny.launch.browser") |>
      attributes() |>
      unlist() |>
      unname()
  } else if (Sys.getenv("POSITRON") == "1") {
    # Positron routes utils::browseURL() for local URLs to the Viewer pane,
    # so "b" and "w" call the OS opener directly
    open_browser <- function(url) {
      switch(
        Sys.info()[["sysname"]],
        Darwin = system2("open", url),
        Windows = shell.exec(url),
        system2("xdg-open", url)
      )
    }
    switch(
      run,
      p = options(shiny.launch.browser = getOption("viewer")),
      b = options(shiny.launch.browser = open_browser),
      w = options(shiny.launch.browser = open_browser),
      NULL = options(shiny.launch.browser = NULL)
    )
    environment <- "Positron"
    viewer_type <- run
  } else {
    logr_msg("App not running in RStudio or Positron", level = "INFO")
    return(invisible(NULL))
  }

  logr_msg(paste("App running in", environment), level = "INFO")
  logr_msg(paste("shiny.launch.browser set to", viewer_type), level = "INFO")
  invisible(NULL)
}
