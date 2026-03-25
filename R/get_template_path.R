#' Get Template Path for Report Format
#'
#' Resolves the path to the bundled report template for the given format
#' using [system.file()].
#'
#' @param format Report format: `"rmarkdown"` or `"quarto"`.
#'
#' @return Character string path to the template file (empty string `""`
#'   if not found).
#'
#' @keywords internal
#'
get_template_path <- function(format) {
  template_file <- switch(format,
    "rmarkdown" = "report_template.Rmd",
    "quarto" = "report_template.qmd"
  )

  template_dir <- switch(format,
    "rmarkdown" = "rmarkdown",
    "quarto" = "quarto"
  )

  system.file(template_dir, template_file, package = "ttdviewer")
}
