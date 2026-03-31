#' Timestamp
#'
#' Returns the current system time formatted as `"YYYY-MM-DD-HH.MM.SS"`.
#'
#' @return A character string of the current date and time.
#'
#' @export
#'
#' @examples
#' tstmp()
#' cat(paste("Last updated:", tstmp()))
#'
tstmp <- function() {
  format(Sys.time(), "%Y-%m-%d-%H.%M.%S")
}
