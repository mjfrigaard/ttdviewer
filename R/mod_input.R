#' Dataset Title Input Server Module
#'
#' Sends the dataset titles to the client (`output$titles`) and loads the
#' title the client sends back (`input$ds_title`). The client side is
#' `js/src/components/TitleInput.tsx`.
#'
#' @param id Module ID
#'
#' @return A list with the reactive data from `load_tt_data()` and the dataset title.
#'
#' @export
#'
mod_input_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    logr_msg("Initializing variable input server module", level = "DEBUG")

    # Load in two passes: first set the title to NULL so every tab clears,
    # then load the new title once that cleared state reaches the browser.
    # Outputs recalculate during the load, which shows the busy spinners.
    title <- reactiveVal(NULL)

    # titles with at least one data file ("Bring your own data" weeks have none)
    output$titles <- shinyreact::reactive_output(
      unique(all_tt_combined$title[!is.na(all_tt_combined$data_files)]))

    observe({
      title(NULL)
      new_title <- input$ds_title
      session$onFlushed(function() title(new_title), once = TRUE)
    }) |>
      bindEvent(input$ds_title)

    data <- reactive({
      if (is.null(title())) return(NULL)
      logr_msg(
        message = paste("User selected dataset:", title()),
        level = "INFO")
      tryCatch({
          result <- load_tt_data(title())
          if (length(result) == 0) {
            logr_msg(
              message = "Empty dataset returned",
              level = "WARN")
            showNotification("No data available for selected dataset",
              type = "warning", duration = 5
            )
          } else {
            logr_msg(
              message = "Dataset successfully loaded in reactive",
              level = "SUCCESS")
          }
          return(result)
        },
        error = function(e) {
          logr_msg(
            message = paste("Error in data reactive:", e$message),
            level = "ERROR")
          showNotification(paste("Error loading data:", e$message),
            type = "error", duration = 10
          )
          return(list())
        })
    })

    return(
      list(
        data = data,
        'ds_title' = reactive(input$ds_title)
      )
    )
  })
}
