#' Data Download Server Module
#'
#' `output$download` binds to the download link in
#' `js/src/components/Download.tsx`, which also sends `input$file` and
#' `input$format`. `output$files` sends the file names for the file choice.
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
    output$files <- shinyreact::reactive_output({
      if (is.null(data())) return(NULL)
      names(data())
    })

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
