# Describe the variables in a TidyTuesday data file

Describe the variables in a TidyTuesday data file

## Usage

``` r
tt_var_info(df)
```

## Arguments

- df:

  A data frame.

## Value

A tibble with one row per column: `variable`, `type`, `missing`,
`missing_pct`, and `unique`.
