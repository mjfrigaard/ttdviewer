#' Test Logger (Test Utility)
#'
#' Emits structured log messages to the test output, suitable for bracketing
#' test blocks with start/end markers.
#'
#' @param start Optional character string for the start-of-test label.
#' @param end Optional character string for the end-of-test label.
#' @param msg Character string for the log message body.
#'
#' @return Called for its side-effect of writing to the log output.
#'
#' @keywords internal
#'
test_logger <- function(start = NULL, end = NULL, msg) {
  if (is.null(start) & is.null(end)) {
    cat("\n")
    logger::log_info("{msg}")
  } else if (!is.null(start) & is.null(end)) {
    cat("\n")
    logger::log_info("\n[ START {start} = {msg}]")
  } else if (is.null(start) & !is.null(end)) {
    cat("\n")
    logger::log_info("\n[ END {end} = {msg}]")
  } else {
    cat("\n")
    logger::log_info("\n[ START {start} = {msg}]")
    cat("\n")
    logger::log_info("\n[ END {end} = {msg}]")
  }
}
