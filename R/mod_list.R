#' List UI Module (listviewerlite)
#'
#' @param id Namespace ID
#'
#' @return UI element for list output using listviewerlite
#'
#' @export
#'
mod_list_ui <- function(id) {
  ns <- NS(id)
  logr_msg(
    message = "Initializing list UI module", level = "DEBUG")

  tryCatch({

      bslib::card(
        # bslib::card_header(""),
        bslib::card_body(
          markdown("Below is a preview of the [#TidyTuesday](https://github.com/rfordatascience/tidytuesday) dataset(s) provided by [`listviewerlite`](https://long39ng.github.io/listviewerlite/)"),
          uiOutput(ns("list"))
        )
      )
    },
    error = function(e) {
      logr_msg(
        message = paste("Error creating list UI:", e$message),
        level = "ERROR")
      bslib::card(
        bslib::card_header("List Error"),
        bslib::card_body(
          h4("Error loading list interface", class = "text-danger")
        )
      )
    }
  )
}

#' Table Server Module (listviewerlite)
#'
#' @param id Module ID
#' @param data A reactive expression returning the dataset list
#'
#' @export
#'
mod_list_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    logr_msg("Initializing list server module", level = "DEBUG")
    output$list <- renderUI({
      req(data())
      listviewerlite::listview(data())
    })
  })
}
