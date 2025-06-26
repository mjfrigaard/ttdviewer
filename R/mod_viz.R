#' Visualization UI Module (inspectdf-compatible)
#'
#' @param id Namespace ID
#'
#' @return UI output for one or more inspectdf plots
#'
#' @export
mod_viz_ui <- function(id) {
  ns <- NS(id)
  logr_msg("Initializing visualization UI module", level = "DEBUG")
  tryCatch({
      tagList(
        br(),
        selectInput(ns("plot_type"),
          label = "Choose plot type",
          choices = c(
            "Variable Types" = "type",
            "Missing Data" = "na",
            "Correlations" = "cor",
            "Numeric Variables" = "num",
            "Categorical Variables" = "cat"
          ),
          selected = "type"
        ),
        hr(),
        code("data()"),
        uiOutput(ns("dev"))
      )
    },
    error = function(e) {
      logr_msg(paste("Error creating visualization UI:", e$message), level = "ERROR")
      tagList(
        h4("Error loading visualization interface", class = "text-danger"),
        p("Please refresh the page.")
      )
    }
  )
}

#' Visualization Server Module (inspectdf-compatible) - Enhanced
#'
#' @param id Module ID
#' @param data A reactive expression returning the dataset list
#'
#' @return A reactive value containing the current plot type
#'
#' @export
mod_viz_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {

    logr_msg("Initializing visualization server module", level = "DEBUG")

    output$dev <- renderUI({
      req(data())
      listviewerlite::listview(x = data())
    })

  })
}
