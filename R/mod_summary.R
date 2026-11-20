#' Summary Server Module
#'
#' Sends a file overview (`output$overview`) and the file names
#' (`output$choices`) to the client, and renders summary statistics, variable
#' information, and the data (first 1,000 rows) for the file in
#' `input$ds_input`. The client side is `js/src/components/SummaryTab.tsx`.
#'
#' @param id Module ID
#' @param data Reactive named list of data frames from [load_tt_data()]
#'
#' @export
#'
mod_summary_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {

    output$choices <- shinyreact::reactive_output({
      if (is.null(data())) return(NULL)
      names(data())
    })

    selected_df <- reactive({
      req(data(), input$ds_input %in% names(data()))
      data()[[input$ds_input]]
    })

    output$overview <- shinyreact::reactive_output({
      if (is.null(data())) return(NULL)
      dates <- unique(purrr::map_chr(data(), ~ format(attr(.x, "date") %||% NA)))
      list(
        dates = dates[dates != "NA"],
        files = unname(purrr::imap(data(), function(df, nm) {
          list(name = nm, rows = nrow(df), cols = ncol(df))
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
