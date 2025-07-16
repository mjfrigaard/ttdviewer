#' Variable Input UI Module
#'
#' @param id Namespace ID
#'
#' @return UI elements for dataset title selection
#'
#' @export
#'
mod_input_ui <- function(id) {
  ns <- NS(id)
  logr_msg(
    message = "Initializing variable input UI module",
    level = "DEBUG")
  tryCatch({
      choices <- unique(all_tt_combined$title)
      logr_msg(
        message = paste("Available dataset choices:", length(choices)),
        level = "INFO")
      tagList(
        selectInput(
          inputId = ns("ds_title"),
          label = strong("Choose Dataset Title:"),
          choices = choices,
          selected = "Space Launches"
        ),
        tags$details(
          tags$summary(
            em("View download details:")
          ),
          verbatimTextOutput(ns("vals"))
        )
      )
    },
    error = function(e) {
      logr_msg(paste("Error creating variable input UI:", e$message), level = "ERROR")
      # return minimal UI with error message
      tagList(
        h4("Error loading dataset choices", class = "text-danger"),
        p("Please check the data availability.")
      )
    }
  )
}

#' Variable Input Server Module
#'
#' @param id Module ID
#'
#' @return A list with the reactive data from `load_tt_data()` and the dataset title.
#'
#' @export
#'
mod_input_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    logr_msg("Initializing variable input server module", level = "DEBUG")

    data <- reactive({
      req(input$ds_title)
      logr_msg(
        message = paste("User selected dataset:", input$ds_title),
        level = "INFO")
      tryCatch({
          # load data ----
          result <- load_tt_data(input$ds_title)
          if (length(result) == 0) {
            logr_msg(
              message = "Empty dataset returned",
              level = "WARN")
            showNotification("No data available for selected dataset",
              type = "warning", duration = 5
            )
          } else {
            logr_msg(
              message = "Dataset successfully loaded in reactive",
              level = "SUCCESS")
          }
          return(result)
        },
        error = function(e) {
          logr_msg(
            message = paste("Error in data reactive:", e$message),
            level = "ERROR")
          showNotification(paste("Error loading data:", e$message),
            type = "error", duration = 10
          )
          return(list())
        })
    }) |>
      bindEvent(input$ds_title)

    # print names of datasets from title
    output$vals <- renderPrint({
      req(data())
      ds_names <- names(data())
      cat(
        paste("Downloaded", ds_names, "data.",
          collapse = "\n"
        )
      )
    })
    # return both data and dataset title
    return(
        list(
          data = data,
          'ds_title' = reactive(input$ds_title)
        )
      )
  })
}
