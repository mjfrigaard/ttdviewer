# Launch the Tidy Tuesday Explorer App

This function launches the Shiny application for exploring Tidy Tuesday
datasets.

## Usage

``` r
launch(..., log_file = NULL, json = FALSE)
```

## Arguments

- ...:

  Additional arguments passed to shinyApp()

- log_file:

  Optional path to log file for application logs

- json:

  Logical, whether to use JSON logging format

## Value

A Shiny app object
