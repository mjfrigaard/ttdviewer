#' Report Description UI Module with Format Selection
#'
#' @param id Namespace ID
#'
#' @return UI elements for report format descriptions
#' @export
mod_report_desc_ui <- function(id) {
  ns <- NS(id)
  logr_msg(
    message = "Initializing report description UI module",
    level = "DEBUG")
  tryCatch({
      tagList(
        # description
        uiOutput(outputId = ns("desc"))
      )
    },
    error = function(e) {
      logr_msg(
        message = paste("Error creating report description UI:", e$message),
        level = "ERROR"
      )
      bslib::card(
        bslib::card_header("Report Description Error"),
        bslib::card_body(
          h4("Error loading report description interface",
            class = "text-danger"
          ),
          p("Please refresh the page.")
        )
      )
    }
  )
}

#' Report Description Format Server Module
#'
#' @param id Module ID
#' @param format A reactive expression returning the report format
#'
#' @export
#'
mod_report_desc_server <- function(id, format) {
  moduleServer(id, function(input, output, session) {
    logr_msg(
      message = "Initializing report description server module",
      level = "DEBUG"
    )

    desc_inputs <- reactive({
      req(format())
      # check quarto availability ----
      # return the quarto_status
      quarto_status <- if (format()$format == "quarto") {
        if (quarto_available()) {
          list(
            available = TRUE,
            message = "Quarto is available and ready to use."
          )
        } else {
          list(
            available = FALSE,
            message = "Quarto not detected. Will fall back to R Markdown if selected."
          )
        }
      } else {
        list(
          available = TRUE,
          message = "Quarto is available and ready to use."
        )
      }
      # report format description ----
      # uses quarto_status, from report format input
      description <- switch(format()$format,
        "rmarkdown" = list(
          icon = "bi-file-earmark-code",
          title = "R Markdown",
          desc = "Traditional R Markdown report. Compatible with all R installations.",
          note = "Recommended for maximum compatibility."
        ),
        ## includes quarto_status$note ----
        "quarto" = list(
          icon = "bi-file-earmark-richtext",
          title = "Quarto",
          desc = "Modern scientific publishing with enhanced features and interactivity.",
          note = quarto_status$message
        )
      )

      # alert_class ----
      alert_class <- if (format()$format == "quarto" && !quarto_status$available) {
        "alert-warning"
      } else {
        "alert-light"
      }
      return(
        list(
          "quarto_status" = quarto_status,
          "description" = description,
          "alert_class" = alert_class
        )
      )
    })

    observe({ # observer browser() ----
      # format description reactive ----
      output$desc <- renderUI({
        ## UI output ----
        tags$div(
          class = paste(
            "alert border-start border-primary border-3 py-2",
            desc_inputs()$alert_class
          ),
          tags$div(
            class = "d-flex align-items-center mb-1",
            tags$i(class = paste("bi", desc_inputs()$description$icon, "me-2")),
            tags$strong(desc_inputs()$description$title)
          ),
          tags$p(desc_inputs()$description$desc, class = "mb-1 small"),
          tags$small(desc_inputs()$description$note, class = "text-muted")
        )
      })
    }) |> # observer browser() ----
      bindEvent(format())
  })
}
