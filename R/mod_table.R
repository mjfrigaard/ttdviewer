#' Table UI Module (reactable)
#'
#' @param id Namespace ID
#'
#' @return UI element for data table output using reactable
#'
#' @export
#'
mod_table_ui <- function(id) {
  ns <- NS(id)
  logr_msg(message = "Initializing table UI module", level = "DEBUG")
  tryCatch({
      bslib::card(
        # bslib::card_header(""),
        bslib::card_body(
          selectInput(
            inputId = ns("ds_input"),
            label = "Dataset",
            choices = c(
              c("", NULL)
            ),
            selected = ""
          ),
          markdown("The table display below is provided by [`reactable`](https://glin.github.io/reactable/):"),
          reactable::reactableOutput(ns("table")),
          # uiOutput(ns("dev"))
        )
      )
    },
    error = function(e) {
      logr_msg(
        message = paste("Error creating table UI:", e$message),
        level = "ERROR"
      )
      bslib::card(
        bslib::card_header("Table Error"),
        bslib::card_body(
          h4("Error loading table interface", class = "text-danger")
        )
      )
    }
  )
}

#' Table Server Module (reactable)
#'
#' @param id Module ID
#'
#' @param data A reactive expression returning the dataset list
#'
#' @export
#'
mod_table_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {

    logr_msg(
      message = "Initializing table server module",
      level = "DEBUG")

    observe({
      req(data())
      ds_names <- names(data())
      updateSelectInput(
        inputId = "ds_input",
        choices = ds_names, selected = ds_names[1]
      )
    }) |>
      bindEvent(data())

    observe({
      req(data())
    output$table <- reactable::renderReactable({
      tryCatch({
          req(data())
          if (length(data()) == 0) {
            logr_msg(
              message = "No data available for table rendering",
              level = "WARN")
            return(NULL)
          }
          ds_list <- data()

          ds_selected <- as.character(input$ds_input)
          display_ds <- ds_list[[ds_selected]]
          display_ds_name <- names(ds_list)[ds_selected]

          logr_msg(message =
              paste("Rendering table for file:", ds_selected,
                "with", nrow(display_ds), "rows and",
                ncol(display_ds), "columns"),
            level = "INFO")

          if (!is.data.frame(display_ds)) {
            logr_msg(
              message = "First dataset is not a data frame",
              level = "ERROR")
            return(NULL)
          }

          # limit to first 1000 rows
          display_ds <- if (nrow(display_ds) > 1000) {
            logr_msg(
              message = "Large dataset detected - limiting to first 1000 rows",
              level = "INFO")
            head(display_ds, 1000)
          } else {
            display_ds
          }

          # subtitle showing which file and if there are more
          subtitle <- if (length(ds_list) > 1) {
            paste("Showing:", ds_selected, "(", length(ds_list), "files total )")
          } else {
            paste("File:", ds_selected)
          }

          reactable::reactable(
            display_ds,
            searchable = TRUE,
            sortable = TRUE,
            pagination = TRUE,
            defaultPageSize = 10,
            showPageSizeOptions = TRUE,
            pageSizeOptions = c(5, 10, 20, 50),
            highlight = TRUE,
            bordered = TRUE,
            striped = TRUE,
            resizable = TRUE,
            wrap = FALSE,
            defaultColDef = reactable::colDef(
              minWidth = 100,
              headerStyle = list(background = "#f7f7f8")
            )
          )
        },
        error = function(e) {
          logr_msg(
            message = paste("Error rendering table:", e$message),
            level = "ERROR")
          # return empty reactable with error message
          reactable::reactable(
            data.frame(Error = paste("Failed to load data:", e$message)),
            searchable = FALSE,
            sortable = FALSE,
            pagination = FALSE
          )
          })
        })
      }) |>
      bindEvent(data())

    # output$dev <- renderUI({
      #   req(data())
      #   listviewerlite::listview(data())
    # })


  })
}
