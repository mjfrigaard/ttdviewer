#' Application Server
#'
#' Application server logic
#'
#' @note
#' last edited: 2025-06-14-23.23.36
#'
#' @param input Shiny input object
#' @param output Shiny output object
#' @param session Shiny session object
#'
#' @export
#'
app_server <- function(input, output, session) {
  logr_msg("Initializing app server", level = "INFO")

  # add session info logging
  logr_msg(paste("Session started for user:", session$user),
    level = "DEBUG"
  )

  tryCatch({
      # initialize modules
      title_input <- mod_input_server("input")
      # return the data and title
      selected_data <- title_input$data
      dataset_title <- title_input$ds_title

      logr_msg(
        message = "Variable input module initialized",
        level = "DEBUG"
      )

      # reactive values for list
      mod_list_server(id = "listviewerlite", data = selected_data)
      logr_msg(
        message = "Table module initialized",
        level = "DEBUG")

      # reactive values for visualization
      # viz_result <- mod_viz_server(id = "viz", data = selected_data)
      # logr_msg(
      #   message = "Visualization module initialized",
      #   level = "DEBUG"
      # )
      # ttd_reactive <- reactive(selected_data)
      mod_plot_server("viz", ttd = selected_data)

      # reactive values for table
      mod_table_server(id = "table", data = selected_data)
      logr_msg(
        message = "Table module initialized",
        level = "DEBUG")

      # initialize report modules
      report_format <- mod_report_input_server("rep_form")
      mod_report_desc_server("rep_desc", format = report_format)
      logr_msg(
        message = "Report module initialized",
        level = "DEBUG")
      # mod_report_download_server(id = "rep_dwnld",
      #   data = selected_data,
      #   selected_plot_type = viz_result,
      #   dataset_title = dataset_title)

      logr_msg(
        message = "All modules successfully initialized",
        level = "SUCCESS")

      # Add session end logging
      session$onSessionEnded(function() {
        logr_msg(
          message = paste("Session ended for user:", session$user),
          level = "INFO"
        )
      })
    },
    error = function(e) {
      logr_msg(
        message =
            paste("Critical error in app server initialization:", e$message),
        level = "FATAL"
      )

      # Show user-friendly error
      showNotification(
        "Application failed to initialize. Please refresh the page.",
        type = "error",
        duration = NULL
      )
    }
  )

  # reactive values for app
  output$dev <- renderUI({
    req(title_input)
    vals <- reactiveValuesToList(x = input, all.names = TRUE)
    listviewerlite::listview(vals)
  }) |>
    bindEvent(title_input)

}
