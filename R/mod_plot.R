#' Plot types for `mod_plot_server()`
#'
#' Must match `PLOT_TYPES` in `js/src/components/GraphsTab.tsx`.
#'
#' @noRd
PLOT_TYPES <- c("types", "mem", "na", "cor", "imb", "num", "cat")

#' Inspect Plot Module Server
#'
#' Sends the file names to the client (`output$datasets`) and renders one
#' plot per type (`output$plt_<type>`) for the file in `input$dataset`. A plot
#' renders only while its type is in `input$plots`. The client side is
#' `js/src/components/GraphsTab.tsx`.
#'
#' @param id Module id
#' @param ttd Reactive or a static named list of data.frames
#'
#' @return A reactive list with the selected `dataset` and `plots`
#'
#' @export
#'
mod_plot_server <- function(id, ttd) {
  moduleServer(id, function(input, output, session) {
    logr_msg(
      message = sprintf("mod_plot_server[%s]: initializing", id),
      level = "INFO")

    ttd_r <- if (is.reactive(ttd)) ttd else reactive(ttd)

    output$datasets <- shinyreact::reactive_output({
      if (is.null(ttd_r())) return(NULL)
      names(ttd_r())
    })

    selected <- reactive({
      req(ttd_r(), input$dataset %in% names(ttd_r()))
      ttd_r()[input$dataset]
    })

    purrr::walk(PLOT_TYPES, function(plt) {
      output[[paste0("plt_", plt)]] <- renderPlot({
        req(plt %in% input$plots)
        ds <- selected() # outside tryCatch() so req() is not caught as an error
        tryCatch(
          inspect_plot(ttd = ds, plots = plt),
          error = function(err) {
            logr_msg(
              message = sprintf("Error plotting %s:%s: %s",
                input$dataset, plt, err$message),
              level = "ERROR")
            plot.new()
            text(0.5, 0.5, "Error generating plot", cex = 1.2, col = "red")
          }
        )
      })
    })

    reactive(list(dataset = input$dataset, plots = input$plots))
  })
}
