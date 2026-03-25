#' Render R Markdown Report
#'
#' Renders an R Markdown (`.Rmd`) template to the specified output file
#' using `rmarkdown::render()`.
#'
#' @param template_path Path to the `.Rmd` template file.
#' @param output_file Output file path.
#' @param params Named list of report parameters.
#'
#' @return Called for its side-effect of writing `output_file`.
#'
#' @keywords internal
#'
render_rmarkdown_report <- function(template_path, output_file, params) {
  logr_msg(
    message = "Rendering R Markdown report",
    level = "DEBUG")
  logr_msg(
    message = paste("Output file:", output_file),
    level = "DEBUG")

  # clean environment
  render_env <- new.env(parent = globalenv())

  # add libraries/required
  render_env$library <- library
  render_env$require <- require

  # log params
  logr_msg(
    message = paste("Rendering with dataset_title:", params$dataset_title),
    level = "DEBUG")
  logr_msg(
    message = paste("Rendering with title:", params$title),
    level = "DEBUG")

  rmarkdown::render(
    input = template_path,
    output_file = output_file,
    params = params,
    envir = render_env,
    quiet = FALSE,
    clean = TRUE
  )
}
