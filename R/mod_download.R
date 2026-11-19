#' Data Download UI Module
#'
#' @param id Namespace ID
#'
#' @return A format selector and download button
#'
#' @export
#'
mod_download_ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(
      inputId = ns("format"),
      label = strong("Download Data:"),
      choices = list(
        "CSV" = "csv",
        "Parquet" = "parquet",
        "Original format" = "original"
      ),
      selected = "csv",
      width = "100%"
    ),
    downloadButton(ns("download"), "Download Data",
      class = "btn-primary", style = "width: 100%;"),
    p(class = "text-muted small mt-2",
      "Several files download as one .zip.")
  )
}

#' Data Download Server Module
#'
#' @param id Module ID
#' @param data Reactive named list of data frames from [load_tt_data()]
#' @param title Reactive dataset title
#'
#' @export
#'
mod_download_server <- function(id, data, title) {
  moduleServer(id, function(input, output, session) {
    output$download <- downloadHandler(
      filename = function() {
        req(data())
        tt_download_filename(data(), input$format, title())
      },
      content = function(file) {
        req(data())
        write_tt_download(data(), input$format, file)
      }
    )
  })
}
