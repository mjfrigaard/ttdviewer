#' Report Input UI Module with Format Selection
#'
#' @param id Namespace ID
#'
#' @return UI elements for report format input
#'
#' @export
mod_report_input_ui <- function(id) {
  ns <- NS(id)
  logr_msg("Initializing report input UI module", level = "DEBUG")
  tryCatch({
      tagList( # tagList ----
        # Format selection
        selectInput(
          inputId = ns("format"),
          label = strong("Download Report:"),
          choices = list(
            "R Markdown" = "rmarkdown",
            "Quarto" = "quarto"
          ),
          selected = "rmarkdown",
          width = "100%"
        )
      )
    }, # end tagList ----
    error = function(e) {
      logr_msg(paste("Error creating report input UI:", e$message), level = "ERROR")
      bslib::card(
        bslib::card_header("Report Error"),
        bslib::card_body(
          h4("Error loading report input interface",
            class = "text-danger"
          ),
          p("Please refresh the page.")
        )
      )
    }
  )
}

#' Report Input Server Module
#'
#' @param id Module ID
#'
#' @export
#'
mod_report_input_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    logr_msg(message = "Initializing report input server module", level = "DEBUG")
    return(
      reactive(
        list("format" = input$format)
      )
    )
  })
}
