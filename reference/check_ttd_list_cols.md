# Check for List Columns in TidyTuesday Data

Checks all datasets in a TidyTuesday data list for list columns.

## Usage

``` r
check_ttd_list_cols(ttd)
```

## Arguments

- ttd:

  A list of data frames from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

## Value

A named list where each element contains column names of list type, or 0
if no list columns exist in that dataset
