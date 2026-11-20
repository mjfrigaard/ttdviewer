# Determine Length of TidyTuesday Data

Determine Length of TidyTuesday Data

## Usage

``` r
ttd_length(ttd)
```

## Arguments

- ttd:

  A list of data frames from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

## Value

Integer length of `ttd` (counting only data frames)

## Examples

``` r
ttd <- load_tt_data("Moore's Law")
#> Error in load_tt_data("Moore's Law"): No entries found for title: 'Moore's Law'
ttd_length(ttd)
#> Error: object 'ttd' not found
```
