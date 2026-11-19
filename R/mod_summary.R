#' Summary UI Module
#'
#' Shows an overview of the loaded files, then summary statistics, variable
#' information, and the data (first 1,000 rows) for one file.
#'
#' @param id Namespace ID
#'
#' @return UI elements for the Summary tab
#'
#' @export
#'
mod_summary_ui <- function(id) {
  ns <- NS(id)
  bslib::card(
    bslib::card_body(
      uiOutput(ns("overview")),
      selectInput(
        inputId = ns("ds_input"),
        label = "Dataset",
        choices = ""
      ),
      h5("Summary statistics"),
      reactable::reactableOutput(ns("stats")),
      h5("Variable information"),
      reactable::reactableOutput(ns("vars")),
      h5("Data"),
      p(class = "text-muted small",
        "Shows the first 1,000 rows. Download the data for the full file."),
      reactable::reactableOutput(ns("table"))
    )
  )
}

#' Summary Server Module
#'
#' @param id Module ID
#' @param data Reactive named list of data frames from [load_tt_data()]
#'
#' @export
#'
mod_summary_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {

    observe({
      ds_names <- names(data())
      updateSelectInput(session, "ds_input",
        choices = ds_names %||% character(0), selected = ds_names[1])
    }) |>
      bindEvent(data(), ignoreNULL = FALSE)

    selected_df <- reactive({
      req(data(), input$ds_input %in% names(data()))
      data()[[input$ds_input]]
    })

    output$overview <- renderUI({
      req(data())
      dims <- vapply(data(), function(df) {
        paste0(format(nrow(df), big.mark = ","), " rows x ", ncol(df), " columns")
      }, character(1))
      tagList(
        p(strong(paste(length(data()), if (length(data()) == 1) "file" else "files"))),
        tags$ul(purrr::map2(names(dims), dims, function(nm, d) {
          tags$li(code(nm), ": ", d)
        }))
      )
    })

    # NULL (not req()) so htmlwidgets hides the old tables while loading
    output$stats <- reactable::renderReactable({
      if (is.null(data())) return(NULL)
      reactable::reactable(tt_file_summary(selected_df()),
        columns = list(
          metric = reactable::colDef(name = "Metric"),
          value  = reactable::colDef(name = "Value")
        ),
        bordered = TRUE, striped = TRUE)
    })

    output$vars <- reactable::renderReactable({
      if (is.null(data())) return(NULL)
      reactable::reactable(tt_var_info(selected_df()),
        columns = list(
          variable    = reactable::colDef(name = "Variable"),
          type        = reactable::colDef(name = "Type"),
          missing     = reactable::colDef(name = "Missing"),
          missing_pct = reactable::colDef(name = "Missing %",
            style = function(value) {
              if (value > 50) list(background = "#f8d7da")
              else if (value > 10) list(background = "#fff3cd")
            }),
          unique      = reactable::colDef(name = "Unique values")
        ),
        searchable = TRUE, sortable = TRUE, bordered = TRUE, striped = TRUE,
        defaultPageSize = 15)
    })

    output$table <- reactable::renderReactable({
      if (is.null(data())) return(NULL)
      reactable::reactable(
        utils::head(selected_df(), 1000),
        searchable          = TRUE,
        sortable            = TRUE,
        pagination          = TRUE,
        defaultPageSize     = 10,
        showPageSizeOptions = TRUE,
        pageSizeOptions     = c(5, 10, 20, 50),
        highlight           = TRUE,
        bordered            = TRUE,
        striped             = TRUE,
        resizable           = TRUE,
        wrap                = FALSE,
        defaultColDef = reactable::colDef(
          minWidth    = 100,
          headerStyle = list(background = "#f7f7f8")
        )
      )
    })
  })
}
