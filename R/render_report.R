#' Render Report Based on Format Type
#'
#' A utility function that renders either R Markdown or Quarto reports based
#' on the specified format. Validates and cleans parameters, resolves the
#' template path (creating a fallback if needed), delegates to the
#' appropriate renderer, and writes a self-contained HTML error page if
#' rendering fails.
#'
#' @param format Character string: `"rmarkdown"` or `"quarto"`.
#' @param output_file Path to the output file.
#' @param params Named list of parameters to pass to the report template.
#' @param template_path Optional custom template path. When `NULL`
#'   (default), the bundled template for `format` is used.
#'
#' @return The path to the rendered (or error-fallback) file, invisibly.
#'
#' @seealso [render_rmarkdown_report()], [render_quarto_report()],
#'   [validate_and_clean_params()], [validate_quarto_params()],
#'   [get_template_path()], [create_fallback_template()],
#'   [create_error_report()]
#'
#' @keywords internal
#'
render_report <- function(format = c("rmarkdown", "quarto"),
                          output_file,
                          params = list(),
                          template_path = NULL) {
  format <- match.arg(format)

  logr_msg(
    message = paste("Starting", format, "report rendering"),
    level = "INFO"
  )

  logr_msg(
    message = paste("Parameters:", paste(names(params), collapse = ", ")),
    level = "DEBUG"
  )

  tryCatch({
      # get_template_path() ----
      if (is.null(template_path)) {
        template_path <- get_template_path(format)
      }

      logr_msg(paste("Using template:", template_path), level = "DEBUG")

      # create_fallback_template() ----
      if (!file.exists(template_path)) {
        logr_msg("Template not found, creating fallback", level = "WARN")
        template_path <- create_fallback_template(format)
      }

      # validate_and_clean_params() ----
      params <- validate_and_clean_params(params)

      if (format == "rmarkdown") {
        # render_rmarkdown_report() ----
        render_rmarkdown_report(template_path, output_file, params)
      } else {
        # render_quarto_report() ----
        render_quarto_report(template_path, output_file, params)
      }

      logr_msg(
        message = paste("Successfully rendered", format, "report"),
        level = "SUCCESS"
      )

      return(output_file)
    },
    error = function(e) {
      logr_msg(
        message = paste("Error rendering", format, "report:", e$message),
        level = "ERROR"
      )

      # create_error_report() ----
      create_error_report(
        output_file,
        e$message,
        params$dataset_title %||% "Unknown",
        format
      )

      return(output_file)
    }
  )
}
