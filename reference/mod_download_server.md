# Data Download Server Module

`input$file` is `"all"` or one file name from
[`data()`](https://rdrr.io/r/utils/data.html). A file name that is not
in [`data()`](https://rdrr.io/r/utils/data.html) (e.g., after a new
title loads) downloads all files.

## Usage

``` r
mod_download_server(id, data, title)
```

## Arguments

- id:

  Module ID

- data:

  Reactive named list of data frames from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

- title:

  Reactive dataset title
