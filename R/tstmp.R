#' Timestamp
#'
#' @returns character string of date/time.
#'
#' @export
#'
#' @examples
#' tstmp()
#' cat(paste("Last updated:", tstmp()))
tstmp <- function() {
  # Format current system time as "YYYY-MM-DD-HH.MM.SS-"
  format(Sys.time(), "%Y-%m-%d-%H.%M.%S")
}
