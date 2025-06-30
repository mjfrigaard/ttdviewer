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
      mod_var_input_ui("input"),
      mod_report_input_ui("rep_form"),
      mod_report_desc_ui("rep_desc"),
      mod_report_download_ui("rep_dwnld"),
      strong(
        code("app_server()"),
        "reactive values:"
      ),
      # dev values
      uiOutput("dev")
    ),
    bslib::navset_tab(
      bslib::nav_panel(
        "List",
        mod_list_ui("listviewerlite")
      ),
      bslib::nav_panel(
        "Data",
        mod_table_ui("data")
      ),
      bslib::nav_panel(
        "Visualization",
        mod_viz_ui("viz")
      )
    )
  )
}
