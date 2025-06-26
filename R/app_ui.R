#' Application UI
#'
#' Constructs the user interface using `bslib` components.
#'
#' @note
#' last edited: 2025-06-14-23.23.36
#'
#' @return A UI definition for a Shiny app
#'
#' @export
app_ui <- function() {
  bslib::page_sidebar(
    title = h4(strong("ttdviewer"), "(",em("explore #TidyTuesday data"), ")"),
    sidebar = bslib::sidebar(
      padding = c(12,12,12,12),
      width = "300px",
      mod_var_input_ui("var_input"),
          strong("Reactive values from ",
              code("app_server()")
            ),
          uiOutput("dev"),
          mod_report_ui("report")
    ),
    bslib::navset_tab(
      bslib::nav_panel("List Preview",
          mod_list_ui("listviewerlite")
        ),
      bslib::nav_panel("Data Table",
          mod_table_ui("table")
        ),
      bslib::nav_panel("Visualization",
          mod_viz_ui("viz")
        )
    )
  )
}
