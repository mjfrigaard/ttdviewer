#' Render Quarto Report via System Call
#'
#' Invokes the `quarto` CLI directly via [system2()] to render a `.qmd`
#' template. Used when the `quarto` R package is not available.
#'
#' @param template_path Path to the `.qmd` template file.
#' @param output_file Output file path.
#' @param params Named list of report parameters.
#'
#' @return Called for its side-effect of writing `output_file`.
#'
#' @keywords internal
#'
render_quarto_system_call <- function(template_path, output_file, params) {

  logr_msg(
    message = "Using system call for Quarto rendering",
    level = "DEBUG")

  # temporary parameter file
  temp_dir <- tempdir()
  param_file <- file.path(temp_dir, "params.yml")

  # YAML parameters
  param_yaml <- c(
    "params:",
    paste0("  dataset_title: \"", params$dataset_title, "\""),
    paste0("  title: \"", params$title, "\""),
    paste0("  plot_type: \"", params$plot_type, "\"")
  )

  writeLines(param_yaml, param_file)

  # quarto command
  cmd_args <- c(
    "render",
    template_path,
    "--output", output_file,
    "--execute-params", param_file
  )

  # system call
  result <- system2("quarto",
    args = cmd_args,
    stdout = TRUE, stderr = TRUE
  )

  # errors
  if (!is.null(attr(result, "status")) && attr(result, "status") != 0) {
    stop(paste("Quarto system call failed:", paste(result, collapse = "\n")))
  }

  # clean up
  unlink(param_file)
}
