#' Log Messages to Console and File
#'
#' A utility function for logging messages to the console and (optionally) to
#' a plain text log file.
#'
#' @param message A character string representing the message to be logged.
#' @param level A character string indicating the log level. One of:
#'   - `"FATAL"`
#'   - `"ERROR"`
#'   - `"WARN"`
#'   - `"SUCCESS"`
#'   - `"INFO"` (default)
#'   - `"DEBUG"`
#'   - `"TRACE"`
#' @param log_file A character string specifying the path to the log file. If
#' `NULL`, logs are not saved to a file, and only console logging is performed.
#' Defaults to `NULL`.
#'
#' @details
#' - **Console Logging**: All messages are always logged to the console.
#' - **File Logging**: If `log_file` is specified, messages are also written
#'  to the file as plain text lines.
#'
#' @note
#' `logr_msg()` uses the `logger` package for console and file logging.
#'
#' @return
#' The function is called for its side effects of logging messages and does
#' not return a value.
#'
#' @examples
#' # log a simple informational message to the console
#' logr_msg("Application started.")
#'
#' # log an error message to the console and a plain text file
#' logr_msg(
#'   message = "Failed to connect to the database.",
#'   level = "ERROR",
#'   log_file = file.path(tempdir(), "error_log.txt")
#' )
#'
#' # log a warning message to the console only
#' logr_msg(
#'   message = "Low memory warning.",
#'   level = "WARN"
#' )
#'
#' @seealso
#' - [logger::log_appender()] for configuring log destinations.
#' - [logger::log_formatter()] for customizing log message formats.
#'
#' @export
#'
logr_msg <- function(message, level = "INFO", log_file = NULL) {
  # Set default formatter
  logger::log_formatter(formatter = logger::formatter_glue)

  # Log to file only if log_file is specified
  if (!is.null(log_file)) {
    log_dir <- dirname(log_file)

    if (!dir.exists(log_dir)) {
      dir.create(log_dir, recursive = TRUE)
    }

    if (!file.exists(log_file)) {
      file.create(log_file)
    }

    logger::log_appender(logger::appender_tee(log_file))
    logger::log_layout(logger::layout_simple)
  }

  # Log to console by default
  switch(level,
    "FATAL"   = logger::log_fatal("{message}"),
    "ERROR"   = logger::log_error("{message}"),
    "WARN"    = logger::log_warn("{message}"),
    "SUCCESS" = logger::log_success("{message}"),
    "DEBUG"   = logger::log_debug("{message}"),
    "TRACE"   = logger::log_trace("{message}"),
    logger::log_info("{message}") # Default fallback
  )
}
