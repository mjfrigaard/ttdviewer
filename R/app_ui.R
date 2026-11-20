#' Application UI
#'
#' Serves the React client built from `js/` into `inst/www/` (`ui.js` and
#' `ui.css`) with [shinyreact::page_react()]. Bootstrap 5 comes from
#' [bslib::bs_theme()] so the client can use Bootstrap classes.
#'
#' @return A UI definition for a Shiny app
#'
#' @export
app_ui <- function() {
  shinyreact::page_react(
    useBusyIndicators(spinners = TRUE, pulse = TRUE),
    src_dir = system.file("www", package = "ttdviewer"),
    theme = bslib::bs_theme(version = 5),
    title = "#TidyTuesday Viewer"
  )
}
