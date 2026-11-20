#' Data Download Server Module
#'
#' `output$download` binds to the download link in
#' `js/src/components/Download.tsx`, which also sends `input$format`.
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
