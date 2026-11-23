# Log Messages to Console and File

A utility function for logging messages to the console and (optionally)
to a plain text log file.

## Usage

``` r
logr_msg(message, level = "INFO", log_file = NULL)
```

## Arguments

- message:

  A character string representing the message to be logged.

- level:

  A character string indicating the log level. One of:

  - `"FATAL"`

  - `"ERROR"`

  - `"WARN"`

  - `"SUCCESS"`

  - `"INFO"` (default)

  - `"DEBUG"`

  - `"TRACE"`

- log_file:

  A character string specifying the path to the log file. If `NULL`,
  logs are not saved to a file, and only console logging is performed.
  Defaults to `NULL`.

## Value

The function is called for its side effects of logging messages and does
not return a value.

## Details

- **Console Logging**: All messages are always logged to the console.

- **File Logging**: If `log_file` is specified, messages are also
  written to the file as plain text lines.

## Note

`logr_msg()` uses the `logger` package for console and file logging.

## See also

- [`logger::log_appender()`](https://daroczig.github.io/logger/reference/log_appender.html)
  for configuring log destinations.

- [`logger::log_formatter()`](https://daroczig.github.io/logger/reference/log_formatter.html)
  for customizing log message formats.

## Examples

``` r
# log a simple informational message to the console
logr_msg("Application started.")
#> INFO [2026-11-23 23:16:04] Application started.

# log an error message to the console and a plain text file
logr_msg(
  message = "Failed to connect to the database.",
  level = "ERROR",
  log_file = file.path(tempdir(), "error_log.txt")
)
#> ERROR [2026-11-23 23:16:04] Failed to connect to the database.

# log a warning message to the console only
logr_msg(
  message = "Low memory warning.",
  level = "WARN"
)
#> WARN [2026-11-23 23:16:04] Low memory warning.
```
