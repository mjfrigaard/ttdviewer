#' Data Download UI Module
#'
#' @param id Namespace ID
#'
#' @return A file selector, a format selector, and a download button
#'
#' @export
#'
mod_download_ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(
      inputId = ns("file"),
      label = strong("Download Data:"),
      choices = list("All files" = "all"),
      selected = "all",
      width = "100%"
    ),
    selectInput(
      inputId = ns("format"),
      label = "Format:",
      choices = list("CSV" = "csv", "Parquet" = "parquet"),
      selected = "csv",
      width = "100%"
    ),
    downloadButton(ns("download"), "Download Data",
      class = "btn-primary", style = "width: 100%;"),
    p(class = "text-muted small mt-2",
      "All files from a title with several files download as one .zip.")
  )
}

#' Data Download Server Module
#'
#' `input$file` is `"all"` or one file name from `data()`. A file name that
#' is not in `data()` (e.g., after a new title loads) downloads all files.
#'
#' @param id Module ID
#' @param data Reactive named list of data frames from [load_tt_data()]
#' @param title Reactive dataset title
#'
#' @export
#'
mod_download_server <- function(id, data, title) {
  moduleServer(id, function(input, output, session) {
    observe({
      files <- names(data())
      updateSelectInput(session, "file",
        choices = c("All files" = "all", stats::setNames(files, files)),
        selected = "all")
    }) |>
      bindEvent(data(), ignoreNULL = FALSE)

    # the chosen file, or every file
    chosen <- reactive({
      req(data())
      if (isTRUE(input$file %in% names(data()))) data()[input$file] else data()
    })

    output$download <- downloadHandler(
      filename = function() {
        tt_download_filename(chosen(), input$format, title())
      },
      content = function(file) {
        write_tt_download(chosen(), input$format, file)
      }
    )
  })
}
