# Name a TidyTuesday data download

A single file keeps its own name (with the extension for `format`).
Several files are bundled into one `.zip` named after the dataset title.

## Usage

``` r
tt_download_filename(data, format = c("csv", "parquet"), title)
```

## Arguments

- data:

  Named list of data frames from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md).

- format:

  One of `"csv"` or `"parquet"`.

- title:

  The dataset title.

## Value

A file name.
