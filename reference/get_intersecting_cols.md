# Get Intersecting Column Names Between Two Datasets

Helper function to find column names that exist in both datasets when
there are exactly two datasets in the
[TidyTuesday](https://github.com/rfordatascience/tidytuesday) data list.

## Usage

``` r
get_intersecting_cols(ttd)
```

## Arguments

- ttd:

  A list of data frames from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

## Value

A character vector of intersecting column names, or empty vector if no
intersections or if not exactly 2 datasets

## Examples

``` r
ttd <- load_tt_data("Moore's Law")
#> Error in load_tt_data("Moore's Law"): No entries found for title: 'Moore's Law'
get_intersecting_cols(ttd)
#> Error: object 'ttd' not found
```
