# Check for Date Columns in TidyTuesday Data

Checks all datasets in a TidyTuesday data list for date/datetime
columns.

## Usage

``` r
check_ttd_date_cols(ttd)
```

## Arguments

- ttd:

  A list of data frames from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

## Value

A named list where each element contains column names of date/datetime
type, or 0 if no date columns exist in that dataset
