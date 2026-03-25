#' Check Quarto Availability
#'
#' Checks whether Quarto is available via the R package, system path, or
#' common installation locations.
#'
#' @return Logical `TRUE` if Quarto is available, `FALSE` otherwise.
#'
#' @keywords internal
#'
quarto_available <- function() {
  # check for quarto R package ----
  if (requireNamespace("quarto", quietly = TRUE)) {
    tryCatch({
        quarto::quarto_version()
        logr_msg(message = "Quarto R package available",
          level = "DEBUG")
        return(TRUE)
      },
      error = function(e) {
        logr_msg(message = "Quarto R package found but not functional",
          level = "DEBUG")
      })
  }

  # check for system quarto -----
  tryCatch({
      result <- system2("quarto",
        args = "--version",
        stdout = TRUE, stderr = TRUE, timeout = 5
      )
      if (!is.null(result) && length(result) > 0) {
        logr_msg(
          message = paste("System Quarto version:", result[1]),
          level = "DEBUG")
        return(TRUE)
      }},
    error = function(e) {
      logr_msg(
        message = "System Quarto not available",
        level = "DEBUG")
    }
  )

  # check common installation paths ----
  quarto_paths <- c(
    "/usr/local/bin/quarto",
    "/usr/bin/quarto",
    "C:/Program Files/Quarto/bin/quarto.exe",
    "C:/Users/*/AppData/Local/Programs/Quarto/bin/quarto.exe"
  )

  for (path in quarto_paths) {
    if (file.exists(path)) {
      logr_msg(
        message = paste("Found Quarto at:", path),
        level = "DEBUG")
      return(TRUE)
    }
  }

  logr_msg(
    message = "Quarto not available",
    level = "DEBUG")
  return(FALSE)
}
