#' Convert Quarto Syntax to R Markdown
#'
#' Performs a best-effort conversion of a Quarto (`.qmd`) document's lines
#' to R Markdown-compatible syntax, replacing Quarto chunk options, callout
#' divs, and the YAML header.
#'
#' @param qmd_lines Character vector of lines read from a `.qmd` file.
#'
#' @return Character vector of lines suitable for use in an `.Rmd` file.
#'
#' @keywords internal
#'
convert_qmd_to_rmd <- function(qmd_lines) {
  # Basic conversions for compatibility
  rmd_lines <- qmd_lines

  # Convert Quarto chunk options to R Markdown
  rmd_lines <- gsub("#\\| ", "", rmd_lines)
  rmd_lines <- gsub("output: asis", "results='asis'", rmd_lines)
  rmd_lines <- gsub("include: false", "include=FALSE", rmd_lines)

  # Convert Quarto callouts to simple formatting
  rmd_lines <- gsub("::: \\{.callout-note\\}", "<div class='alert alert-info'>", rmd_lines)
  rmd_lines <- gsub("::: \\{.callout-tip\\}", "<div class='alert alert-success'>", rmd_lines)
  rmd_lines <- gsub(":::", "</div>", rmd_lines)

  # Update YAML header for R Markdown
  yaml_start <- which(rmd_lines == "---")[1]
  yaml_end <- which(rmd_lines == "---")[2]

  if (!is.na(yaml_start) && !is.na(yaml_end)) {
    new_yaml <- c(
      "---",
      "title: \"TidyTuesday Report\"",
      "output:",
      "  html_document:",
      "    theme: cosmo",
      "    toc: true",
      "    code_folding: hide",
      "params:",
      "  dataset_title: \"Dataset\"",
      "  title: \"TidyTuesday Report\"",
      "  data_list: NULL",
      "  plots: NULL",
      "  plot_type: \"type\"",
      "---"
    )

    rmd_lines <- c(new_yaml, rmd_lines[(yaml_end + 1):length(rmd_lines)])
  }

  return(rmd_lines)
}
