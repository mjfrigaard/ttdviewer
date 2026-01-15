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
ttd <- load_tt_data("Moore’s Law")
#> INFO [2026-01-15 19:44:15] Starting import for cpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/cpu.csv
#> SUCCESS [2026-01-15 19:44:15] Successfully loaded cpu.csv
#> INFO [2026-01-15 19:44:15] Starting import for gpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/gpu.csv
#> SUCCESS [2026-01-15 19:44:15] Successfully loaded gpu.csv
#> INFO [2026-01-15 19:44:15] Starting import for ram.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/ram.csv
#> SUCCESS [2026-01-15 19:44:15] Successfully loaded ram.csv
get_intersecting_cols(ttd)
#> character(0)
```
