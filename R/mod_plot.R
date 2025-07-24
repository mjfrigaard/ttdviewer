#' Inspect Plot Module UI
#'
#' Let the user pick plots and see one panel per dataset × plot
#'
#' @param id Module id
#'
#' @return Shiny UI
#'
#' @export
#'
mod_plot_ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(
      ns("dataset"),
      "Choose dataset:",
      choices = NULL,
      selected = NULL
    ),
    checkboxGroupInput(
      ns("plots"),
      "Select plot type:",
      choices = c(
        "types"       = "types",
        "memory"      = "mem",
        "missing"     = "na",
        "correlation" = "cor",
        "imbalance"   = "imb",
        "numeric"     = "num",
        "categorical" = "cat"
      ),
      selected = c("types","mem","na")
    ),
    uiOutput(ns("plots_ui"))
  )
}

#' Inspect Plot Module Server
#'
#' Renders one plot per (dataset × plot-type)
#'
#' @param id Module id
#' @param ttd Reactive or a static named list of data.frames
#'
#' @export
#'
mod_plot_server <- function(id, ttd) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    logr_msg(
      message = sprintf("mod_single_plot_server[%s]: initializing", id),
      level = "INFO")

    # wrap static into reactive if needed
    ttd_r <- if (is.reactive(ttd)) {
      logr_msg(
        message = "ttd is reactive",
        level = "DEBUG")
      ttd
    } else {
      logr_msg(
        message = "ttd is static; wrapping in reactive()",
        level = "DEBUG")
      reactive(ttd)
    }

    # populate the dataset dropdown once ttd is available
    observe({
      tryCatch({
        ds <- names(ttd_r())
        if (is.null(ds) || length(ds) == 0) {
          ds <- seq_along(ttd_r()) %>% as.character()
          logr_msg(
            message = "No names in ttd; using indices",
            level = "WARN")
        }
        updateSelectInput(
          session, "dataset",
          choices  = ds,
          selected = ds[[1]]
        )
        logr_msg(
          message = sprintf("Populated dataset selector with: %s",
            paste(ds, collapse = ", ")),
          level = "SUCCESS")
      }, error = function(err) {
        logr_msg(
          message = sprintf("Error populating dataset selector: %s", err$message),
          level = "ERROR")
      })
    }) |>
      bindEvent(ttd_r(), once = FALSE)

    # render each selected plot type for chosen dataset
    observe({
        tryCatch({
          ds_list <- req(ttd_r())
          sel_ds  <- input$dataset
          req(sel_ds %in% names(ds_list))  # ensure dataset exists
          df <- ds_list[[sel_ds]]
          logr_msg(
            message = sprintf("Rendering plots for dataset '%s'", sel_ds),
            level = "INFO")

          purrr::walk(input$plots, function(plt) {
            out_id <- paste0("plt_", plt)
            output[[out_id]] <- renderPlot({
              tryCatch({
                inspect_plot(
                  ttd = setNames(list(df), sel_ds),
                  plots = plt
                )
              }, error = function(err2) {
                logr_msg(
                  message = sprintf("Error plotting %s:%s — %s",
                    sel_ds, plt, err2$message),
                  level = "ERROR")
                # display placeholder
                plot.new()
                text(0.5, 0.5, "Error generating plot", cex = 1.2, col = "red")
              })
            })
          })
        }, error = function(err) {
          logr_msg(
            message = sprintf("Error in plot observer: %s", err$message),
            level = "ERROR")
        })
      }) |>
      bindEvent(list(input$dataset, input$plots),
                ignoreNULL = TRUE)

    # dynamically generate UI for selected plot types
    output$plots_ui <- renderUI({
      tryCatch({
        req(input$dataset, input$plots)
        logr_msg(message =
            sprintf("Rendering UI for dataset '%s' and plots: %s",
                     input$dataset,
                     paste(input$plots, collapse = ", ")),
                 level = "DEBUG")

        purrr::map(input$plots, function(plt) {
          plot_id <- ns(paste0("plt_", plt))
          tagList(
            h4(plt),
            plotOutput(plot_id, height = "300px")
          )
        })
      }, error = function(err) {
        logr_msg(
          message = sprintf("Error in plots_ui renderUI: %s", err$message),
          level = "ERROR")
        tagList(
          p(style = "color:red;", "Failed to generate plot UI.")
        )
      })
    })


    logr_msg(
      message = sprintf("mod_plot_server[%s]: setup complete", id),
      level = "SUCCESS")

    return(
      reactive({
        list(
          "dataset" = input$dataset,
          "plots" = input$plots
        )
      })
    ) |>
      bindEvent(list(input$dataset, input$plots),
                ignoreNULL = TRUE)

  })
}
