#' Alternative Quarto Rendering via R Markdown
#'
#' Converts a Quarto (`.qmd`) template to R Markdown and renders it with
#' `rmarkdown::render()`. Used as a fallback when the `quarto` package or
#' system Quarto binary is unavailable.
#'
#' @param template_path Path to the `.qmd` template file.
#' @param output_file Output file path.
#' @param params Named list of report parameters.
#'
#' @return Called for its side-effect of writing `output_file`.
#'
#' @keywords internal
#'
render_quarto_alternative <- function(template_path, output_file, params) {
  logr_msg(
    message = "Using alternative Quarto rendering method",
    level = "INFO")

  # create modified template for rmarkdown compatibility
  temp_rmd <- tempfile(fileext = ".Rmd")

  # Read quarto template and convert to R Markdown
  qmd_content <- readLines(template_path)

  # convert quarto-specific syntax to R Markdown
  rmd_content <- convert_qmd_to_rmd(qmd_content)

  # write modified content
  writeLines(rmd_content, temp_rmd)

  # render with rmarkdown
  rmarkdown::render(
    input = temp_rmd,
    output_file = output_file,
    params = params,
    envir = new.env(),
    quiet = TRUE
  )

  # clean
  unlink(temp_rmd)
}
