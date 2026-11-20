#' Application Server
#'
#' Application server logic
#'
#' @note
#' last edited: 2025-07-10-07.47.57
#'
#' @param input Shiny input object
#' @param output Shiny output object
#' @param session Shiny session object
#'
#' @export
#'
app_server <- function(input, output, session) {

  logr_msg(message = "Initializing app server", level = "INFO")

  # add session info logging
  logr_msg(message = paste("Session started for user:", session$user),
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

      mod_download_server("download", data = selected_data, title = dataset_title)

      logr_msg(
        message = "Download module initialized",
        level = "DEBUG")

      mod_summary_server("summary", data = selected_data)

      logr_msg(
        message = "Summary module initialized",
        level = "DEBUG")

      # reactive values for list
      mod_list_server(id = "listviewerlite", data = selected_data)

      logr_msg(
        message = "List module initialized",
        level = "DEBUG")

      # reactive values for visualization
      selected_plots <- mod_plot_server("viz", ttd = selected_data)

      logr_msg(
        message = "Plot module initialized",
        level = "DEBUG")

      logr_msg(
        message = "All modules successfully initialized",
        level = "SUCCESS")

      # add session end logging
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

      # user-friendly error
      showNotification(
        "Application failed to initialize. Please refresh the page.",
        type = "error",
        duration = NULL
      )
    }
  )

  # reactive values for app
  output$dev <- renderUI({
    vals <- list(
      "data" = selected_data(),
      "title" = dataset_title(),
      "dataset" = selected_plots()[['dataset']],
      "plots" = selected_plots()[['plots']]
    )
    # vals <- reactiveValuesToList(x = input, all.names = TRUE)
    # listviewerlite::listview(selected_plots())
    # listview() errors on NULL elements (before a title loads, during the purge)
    listviewerlite::listview(purrr::compact(vals))
  })

}
