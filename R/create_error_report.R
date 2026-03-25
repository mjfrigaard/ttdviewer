#' Create Enhanced Error Report
#'
#' Writes a self-contained HTML file that describes a report-generation
#' failure, including the error message, dataset title, format, and a
#' timestamp. Called as a fallback when rendering fails.
#'
#' @param file Output file path (`.html`).
#' @param error_msg Character string containing the error message.
#' @param dataset_title Dataset title shown in the error page. Defaults to
#'   `"Unknown"`.
#' @param format Report format (`"rmarkdown"` or `"quarto"`). Defaults to
#'   `"rmarkdown"`.
#'
#' @return Called for its side-effect of writing `file`.
#'
#' @keywords internal
#'
create_error_report <- function(file, error_msg, dataset_title = "Unknown", format = "rmarkdown") {
  logr_msg(paste("Creating error report for", format), level = "INFO")

  error_html <- paste0(
    '<!DOCTYPE html>
    <html>
    <head>
      <title>Report Generation Error</title>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
      <style>
        body { margin: 40px; }
        .error-container { max-width: 800px; margin: 0 auto; }
      </style>
    </head>
    <body>
      <div class="error-container">
        <h1 class="text-danger"><i class="bi bi-exclamation-triangle"></i> Report Generation Failed</h1>

        <div class="alert alert-danger" role="alert">
          <h4 class="alert-heading">Error Details</h4>
          <p class="mb-0">', error_msg, '</p>
        </div>

        <div class="card mt-4">
          <div class="card-header">
            <h5 class="mb-0">Report Information</h5>
          </div>
          <div class="card-body">
            <dl class="row">
              <dt class="col-sm-3">Dataset:</dt>
              <dd class="col-sm-9">', dataset_title, '</dd>

              <dt class="col-sm-3">Format:</dt>
              <dd class="col-sm-9">', if (is.null(format) || length(format) == 0) "Unknown" else tools::toTitleCase(format), '</dd>

              <dt class="col-sm-3">Timestamp:</dt>
              <dd class="col-sm-9">', Sys.time(), '</dd>
            </dl>
          </div>
        </div>

        <div class="alert alert-info mt-4" role="alert">
          <h6 class="alert-heading">Troubleshooting Tips</h6>
          <ul class="mb-0">
            <li>Try selecting a different dataset</li>
            <li>Try a different report format</li>
            <li>Check your internet connection</li>
            <li>Contact support if the problem persists</li>
          </ul>
        </div>
      </div>
    </body>
    </html>'
  )

  writeLines(error_html, file)
}
