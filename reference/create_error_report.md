# Create Enhanced Error Report

Writes a self-contained HTML file that describes a report-generation
failure, including the error message, dataset title, format, and a
timestamp. Called as a fallback when rendering fails.

## Usage

``` r
create_error_report(
  file,
  error_msg,
  dataset_title = "Unknown",
  format = "rmarkdown"
)

create_error_report(
  file,
  error_msg,
  dataset_title = "Unknown",
  format = "rmarkdown"
)
```

## Arguments

- file:

  Output file path

- error_msg:

  Error message

- dataset_title:

  Dataset title

- format:

  Report format

## Value

Called for its side-effect of writing `file`.
