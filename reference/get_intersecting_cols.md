# Get Intersecting Column Names Between Two Datasets

Helper function to find column names that exist in both datasets when
there are exactly two datasets in the
[TidyTuesday](https://github.com/rfordatascience/tidytuesday) data list.

Helper function to find column names that exist in both datasets when
there are exactly two datasets in the
[TidyTuesday](https://github.com/rfordatascience/tidytuesday) data list.

## Usage

``` r
get_intersecting_cols(ttd)

get_intersecting_cols(ttd)
```

## Arguments

- ttd:

  A list of data frames from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

## Value

A character vector of intersecting column names, or empty vector if no
intersections or if not exactly 2 datasets

A character vector of intersecting column names, or empty vector if no
intersections or if not exactly 2 datasets

## Examples

``` r
ttd <- load_tt_data("Moore's Law")
#> Error in load_tt_data("Moore's Law"): No entries found for title: 'Moore's Law'
get_intersecting_cols(ttd)
#> Error: object 'ttd' not found
ttd <- load_tt_data("Moore’s Law")
#> INFO [2026-04-10 16:29:32] Starting import for cpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/cpu.csv
#> SUCCESS [2026-04-10 16:29:32] Successfully loaded cpu.csv
#> INFO [2026-04-10 16:29:32] Starting import for gpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/gpu.csv
#> SUCCESS [2026-04-10 16:29:32] Successfully loaded gpu.csv
#> INFO [2026-04-10 16:29:32] Starting import for ram.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/ram.csv
#> SUCCESS [2026-04-10 16:29:32] Successfully loaded ram.csv
get_intersecting_cols(ttd)
#> character(0)
```
