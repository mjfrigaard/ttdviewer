# Log Messages to Console and File with Optional JSON Format

A utility function for logging messages to the console or (optionally)
to a log file. Messages can be stored as plain text (default) or in JSON
format.

## Usage

``` r
logr_msg(message, level = "INFO", log_file = NULL, json = FALSE)
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

- json:

  A logical value indicating whether to save logs in JSON format.
  Defaults to `FALSE`. When `TRUE`, logs are written to the specified
  `log_file` as JSON objects.

## Value

The function is called for its side effects of logging messages and does
not return a value.

## Details

- **Console Logging**: All messages are always logged to the console.

- **File Logging**: If `log_file` is specified, messages are logged to
  the file in either plain text or JSON format, depending on the value
  of `json`.

- **JSON Logs**: When `json = TRUE`, log messages are stored as
  structured JSON objects with the fields:

  - `timestamp`: The time the message was logged.

  - `level`: The severity level of the log.

  - `message`: The actual log message.

## Note

`logr_msg()` uses the `logger` package for console and plain text
logging and integrates JSON logging using the `jsonlite` package.

## See also

- [`logger::log_appender()`](https://daroczig.github.io/logger/reference/log_appender.html)
  for configuring log destinations.

- [`logger::log_formatter()`](https://daroczig.github.io/logger/reference/log_formatter.html)
  for customizing log message formats.

- [`jsonlite::toJSON()`](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html)
  for converting R objects to JSON.

## Examples

``` r
# log a simple informational message to the console
logr_msg("Application started.")
#> INFO [2026-01-15 19:40:23] Application started.

# log an error message to the console and a file in plain text format
logr_msg(
  message = "Failed to connect to the database.",
  level = "ERROR",
  log_file = "error_log.txt"
)
#> ERROR [2026-01-15 19:40:23] Failed to connect to the database.

# log a success message in JSON format
logr_msg(
  message = "User login successful.",
  level = "SUCCESS",
  log_file = "app_log.json",
  json = TRUE
)
#> SUCCESS [2026-01-15 19:40:23] User login successful.

# log a warning message to the console only
logr_msg(
  message = "Low memory warning.",
  level = "WARN"
)
#> {"time":"2026-01-15 19:40:23","level":"WARN","ns":"ttdviewer","ans":"global","topenv":"ttdviewer","fn":"logr_msg","node":"runnervmi13qx","arch":"x86_64","os_name":"Linux","os_release":"6.11.0-1018-azure","os_version":"#18~24.04.1-Ubuntu SMP Sat Jun 28 04:46:03 UTC 2025","pid":7221,"user":"runner","msg":"Low memory warning."}
```
