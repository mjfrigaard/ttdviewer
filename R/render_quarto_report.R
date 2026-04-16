#' Render Quarto Report with Enhanced Error Handling
#'
#' Renders a Quarto (`.qmd`) report using the `quarto` R package when
#' available, falling back to a system call or alternative rendering method
#' on failure.
#'
#' Before calling [quarto::quarto_render()], any `data_list` element in
#' `params` is written to a temporary `.rds` file and replaced with a
#' `data_list_path` string. This is required because
#' `quarto::quarto_render()` validates all `execute_params` for `NA` values
#' (via an internal `check_params_for_na()` call), and data frames
#' containing `NA`s cannot be passed directly.
#'
#' @param template_path Path to the `.qmd` template file.
#' @param output_file Output file path.
#' @param params Named list of report parameters. `data_list` (a named list
#'   of data frames) is serialised to a temp `.rds` file; all other
#'   parameters are passed as-is via `execute_params`.
#'
#' @return Called for its side-effect of writing `output_file`.
#'
#' @keywords internal
#'
render_quarto_report <- function(template_path, output_file, params) {

  logr_msg(
    message = "Rendering Quarto report",
    level = "DEBUG")
  logr_msg(
    message = paste("Template:", template_path),
    level = "DEBUG")
  logr_msg(
    message = paste("Output:", output_file),
    level = "DEBUG")

  # check quarto
  if (!quarto_available()) {
    stop("Quarto is not available. Please install Quarto or use R Markdown format.")
  }

  # validate parameters for Quarto
  params <- validate_quarto_params(params)

  tryCatch({

        # method 1  using quarto R package
      if (requireNamespace("quarto", quietly = TRUE)) {
        logr_msg("Using quarto R package", level = "DEBUG")

        # create temporary directory for rendering
        temp_dir <- tempdir()
        temp_qmd <- file.path(temp_dir, "temp_report.qmd")

        # copy template to temp location
        file.copy(template_path, temp_qmd, overwrite = TRUE)

        # write data_list to RDS — quarto::quarto_render() validates execute_params
        # via check_params_for_na(), which errors on any NA in any column of a
        # data frame. Passing data frames with NAs directly is not supported.
        data_list_path <- ""
        if (!is.null(params$data_list) && length(params$data_list) > 0) {
          data_list_path <- file.path(temp_dir, "data_list.rds")
          saveRDS(params$data_list, data_list_path)
          logr_msg(
            message = paste("Wrote data_list to:", data_list_path),
            level = "DEBUG")
        }
        quarto_params <- params
        quarto_params$data_list <- NULL
        quarto_params$data_list_path <- data_list_path

        # render with quarto package
        quarto::quarto_render(
          input = temp_qmd,
          output_file = basename(output_file),
          execute_params = quarto_params,
          quiet = TRUE
        )

        # clean
        unlink(c(temp_qmd, data_list_path))

      } else {
        # method 2 system call fallback
        render_quarto_system_call(template_path, output_file, params)
      }

      logr_msg(
        message = "Quarto rendering completed successfully",
        level = "SUCCESS")
    },
    error = function(e) {

      logr_msg(
        message = paste("Quarto rendering error:", e$message),
        level = "ERROR")

      # fallback method
      if (grepl("quarto", e$message, ignore.case = TRUE)) {
        logr_msg(
          message = "Trying alternative rendering method",
          level = "INFO")

        render_quarto_alternative(template_path, output_file, params)

      } else {

        stop(e)

      }}
  )
}
