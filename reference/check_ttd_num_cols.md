# Check for Numeric Columns in TidyTuesday Data

Checks all datasets in a TidyTuesday data list for numeric columns.

## Usage

``` r
check_ttd_num_cols(ttd)
```

## Arguments

- ttd:

  A list of data frames from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

## Value

A named list where each element contains column names of numeric type,
or 0 if no numeric columns exist in that dataset
