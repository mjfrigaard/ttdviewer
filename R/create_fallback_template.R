#' Create Fallback Report Template
#'
#' Dispatches to the appropriate fallback template creator based on the
#' requested report format.
#'
#' @param format Report format: `"rmarkdown"` or `"quarto"`.
#'
#' @return Path to the created temporary template file.
#'
#' @keywords internal
#'
create_fallback_template <- function(format = c("rmarkdown", "quarto")) {
  format <- match.arg(format)
  logr_msg(paste("Creating fallback", format, "template"), level = "INFO")

  if (format == "rmarkdown") {
    return(create_fallback_rmd_template())
  } else {
    return(create_fallback_qmd_template())
  }
}
