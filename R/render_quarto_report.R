#' Render Quarto Report with Enhanced Error Handling
#'
#' Renders a Quarto (`.qmd`) report using the `quarto` R package when
#' available, falling back to a system call or alternative rendering method
#' on failure.
#'
#' @param template_path Path to the `.qmd` template file.
#' @param output_file Output file path.
#' @param params Named list of report parameters.
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

        # create params file
        params_file <- file.path(temp_dir, "params.yml")
        yaml_content <- yaml::as.yaml(list(params = params))
        writeLines(yaml_content, params_file)

        # render with quarto package
        quarto::quarto_render(
          input = temp_qmd,
          output_file = basename(output_file),
          execute_params = params,
          quiet = TRUE
        )

        # clean
        unlink(c(temp_qmd, params_file))

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
