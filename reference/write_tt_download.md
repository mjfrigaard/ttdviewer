# Write TidyTuesday data for download

Writes every data frame in `data` as CSV or parquet, or fetches the
original file from its `github_url` attribute. One file is written
straight to `file`; several files are zipped into `file`.

## Usage

``` r
write_tt_download(data, format = c("csv", "parquet", "original"), file)
```

## Arguments

- data:

  Named list of data frames from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md).

- format:

  One of `"csv"`, `"parquet"`, or `"original"`.

- file:

  Path to write the download to.

## Value

`file`, invisibly.
