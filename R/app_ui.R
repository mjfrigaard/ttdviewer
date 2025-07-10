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
    title = h4(strong("#TidyTuesday Viewer")),
    sidebar = bslib::sidebar(
      padding = c(12, 12, 12, 12),
      width = "300px",
      mod_input_ui("input"),
      # br(),
      mod_report_input_ui("rep_form"),
      br(),
      mod_report_desc_ui("rep_desc"),
      mod_report_download_ui("rep_dwnld"),
      tags$details(
        tags$summary(
          strong(
            code("app_server()"),
              "reactive values:")
            ),
        uiOutput("dev")
      )
    ),
    bslib::navset_tab(
      bslib::nav_panel(
        "List",
        mod_list_ui("listviewerlite")
      ),
      bslib::nav_panel(
        "Table",
        mod_table_ui("table")
      ),
      bslib::nav_panel(
        "Graphs",
        mod_plot_ui("viz")
      )
    )
  )
}
