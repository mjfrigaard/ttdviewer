#' Report Download UI Module with Format Selection
#'
#' @param id Namespace ID
#'
#' @return UI elements for report generation with format options
#' @export
mod_report_download_ui <- function(id) {
  ns <- NS(id)
  logr_msg("Initializing report download UI module", level = "DEBUG")
  tryCatch(
    {
      tagList( # tagList ----
        # Download button
        tags$div(
          class = "d-grid",
          downloadButton(
            ns("download_report"),
            "Download Report",
            class = "btn btn-primary",
            icon = icon("download")
          )
        ),
        # Help text
        tags$small(
          class = "text-muted",
          "Report includes: data visualization, summary statistics, data preview, and variable information."
        )
      )
    }, # end tagList ----
    error = function(e) {
      logr_msg(paste("Error creating report UI:", e$message), level = "ERROR")
      bslib::card(
        bslib::card_header("Report Error"),
        bslib::card_body(
          h4("Error loading report interface", class = "text-danger"),
          p("Please refresh the page.")
        )
      )
    }
  )
}

#' Report Download Server Module with Enhanced Quarto Error Handling
#'
#' @param id Module ID
#' @param format A reactive expression returning the report format
#' @param data A reactive expression returning the dataset list
#' @param selected_plot_type A reactive expression returning the selected plot type
#' @param dataset_title A reactive expression returning the dataset title
#'
#' @export
mod_report_download_server <- function(id, format, data, selected_plot_type, dataset_title) {
  moduleServer(id, function(input, output, session) {
    logr_msg(message = "Initializing report server module", level = "DEBUG")

    # downloadHandler() ----
    output$download_report <- downloadHandler(
      ## FILENAME ----
      filename = function() {
        tryCatch(
          {
            # get dataset title from the data
            current_data <- data()

            actual_title <- if (!is.null(current_data) && length(current_data) > 0) {
              # try to get title from variable input module
              # or use first dataset name
              first_dataset_name <- names(current_data)[1]

              if (!is.null(first_dataset_name) && first_dataset_name != "") {
                gsub("\\.csv$", "", first_dataset_name) # Remove .csv extension
              } else {
                "tidytuesday_dataset"
              }
            } else {
              "tidytuesday_dataset"
            }

            # clean title for filename ----
            clean_title <- gsub("[^A-Za-z0-9_-]", "_", actual_title)

            timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")

            format_suffix <- switch(input$report_format,
              "rmarkdown" = "rmd",
              "quarto" = "qto"
            )

            filename <- paste0(
              clean_title, "_", format_suffix, "_", timestamp, ".html"
            )

            logr_msg(
              message = paste("Generated report filename:", filename),
              level = "DEBUG"
            )

            return(filename)
          },
          error = function(e) {
            logr_msg(
              message = paste("Error generating filename:", e$message),
              level = "ERROR"
            )
            return("tidytuesday_report.html")
          }
        )
      },
      # CONTENT ----
      content = function(file) {
        tryCatch(
          {
            logr_msg(paste("Starting", input$report_format, "report generation"),
              level = "INFO"
            )
            # validate inputs
            current_data <- data()
            if (is.null(current_data) || length(current_data) == 0) {
              logr_msg("No data available for report generation",
                level = "ERROR"
              )
              stop("No data available. Please select a dataset first.")
            }

            # Enhanced format checking for Quarto
            if (input$report_format == "quarto") {
              if (!quarto_available()) {
                logr_msg("Quarto not available, falling back to R Markdown",
                  level = "WARN"
                )
                showNotification(
                  "Quarto not available. Generating R Markdown report instead.",
                  type = "warning",
                  duration = 5
                )
                actual_format <- "rmarkdown"
              } else {
                logr_msg("Quarto available, proceeding with Quarto rendering",
                  level = "INFO"
                )
                actual_format <- "quarto"
              }
            } else {
              actual_format <- input$report_format
            }

            # progress notification ----
            progress_msg <- paste(
              "Generating",
              tools::toTitleCase(actual_format),
              "report..."
            )
            showNotification(
              progress_msg,
              type = "message",
              duration = 8,
              id = "report_progress"
            )
            # Get current parameters with proper dataset title
            current_plot_type <- selected_plot_type() %||% "type"

            # Extract actual dataset title from data or use fallback
            actual_dataset_title <- if (!is.null(current_data) && length(current_data) > 0) {
              # Get first dataset name and clean it
              first_name <- names(current_data)[1]
              if (!is.null(first_name) && first_name != "") {
                # Remove .csv extension and format nicely
                clean_name <- gsub("\\.csv$", "", first_name)
                tools::toTitleCase(gsub("_", " ", clean_name))
              } else {
                "TidyTuesday Dataset"
              }
            } else {
              "TidyTuesday Dataset"
            }

            logr_msg(
              message = paste(
                "Report parameters - Dataset:",
                actual_dataset_title, "Plot type:", current_plot_type,
                "Format:", actual_format
              ),
              level = "INFO"
            )

            # Generate plots for the report
            plots <- tryCatch(
              {
                ttdviewer::inspect_plot(ttd = current_data, plot = current_plot_type)
              },
              error = function(e) {
                logr_msg(
                  message = paste("Error generating plots for report:", e$message),
                  level = "WARN"
                )
                NULL
              }
            )

            # prepare params ----
            params <- list(
              dataset_title = actual_dataset_title,
              title = paste("TidyTuesday Report:", actual_dataset_title),
              data_list = current_data,
              plots = plots,
              plot_type = current_plot_type
            )

            # log parameter summary
            logr_msg(
              message = "Parameters prepared:",
              level = "DEBUG"
            )
            logr_msg(
              message = paste("  - dataset_title:", params$dataset_title),
              level = "DEBUG"
            )
            logr_msg(
              message = paste("  - data_list length:", length(params$data_list)),
              level = "DEBUG"
            )
            logr_msg(
              message = paste("  - plots class:", class(params$plots)),
              level = "DEBUG"
            )

            # render report ----
            # with enhanced error handling
            tryCatch(
              {
                render_report(
                  format = actual_format,
                  output_file = file,
                  params = params
                )
              },
              error = function(render_error) {
                logr_msg(
                  message = paste("Render error:", render_error$message),
                  level = "ERROR"
                )

                # if quarto fails, try R Markdown as fallback
                if (actual_format == "quarto") {
                  logr_msg(
                    message = "Quarto failed, trying R Markdown fallback",
                    level = "WARN"
                  )
                  render_report(
                    format = "rmarkdown",
                    output_file = file,
                    params = params
                  )
                  showNotification(
                    "Quarto failed, generated R Markdown report instead.",
                    type = "warning",
                    duration = 5
                  )
                } else {
                  stop(render_error)
                }
              }
            )

            logr_msg(
              message = "Report generation completed successfully",
              level = "SUCCESS"
            )
            # remove progress notification/show success
            removeNotification("report_progress")
            showNotification(
              paste(
                tools::toTitleCase(actual_format),
                "report generated successfully!"
              ),
              type = "message",
              duration = 3
            )
          },
          error = function(e) {
            error_msg <- paste("Failed to generate report:", e$message)
            logr_msg(error_msg, level = "ERROR")

            # Remove progress notification
            removeNotification("report_progress")

            ### Show error notification ----
            showNotification(
              paste("Report generation failed:", e$message),
              type = "error",
              duration = 10
            )

            ## create error report ----
            create_error_report(
              file, error_msg,
              actual_dataset_title %||% "Unknown",
              input$report_format
            )
          }
        )
      }
    )
  })
}
