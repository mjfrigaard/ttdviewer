# Determine length of TidyTuesday Data

Determine length of TidyTuesday Data

Determine Length of TidyTuesday Data

## Usage

``` r
ttd_length(ttd)

ttd_length(ttd)
```

## Arguments

- ttd:

  A list of data frames from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

## Value

integer length of `ttd`

Integer length of `ttd` (counting only data frames)

## Examples

``` r
ttd <- load_tt_data("Moore’s Law")
#> INFO [2026-11-19 21:51:21] Starting import for cpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/cpu.csv
#> SUCCESS [2026-11-19 21:51:21] Successfully loaded cpu.csv
#> INFO [2026-11-19 21:51:21] Starting import for gpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/gpu.csv
#> SUCCESS [2026-11-19 21:51:21] Successfully loaded gpu.csv
#> INFO [2026-11-19 21:51:21] Starting import for ram.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/ram.csv
#> SUCCESS [2026-11-19 21:51:21] Successfully loaded ram.csv
ttd_length(ttd)
#> [1] 3

ttd <- load_tt_data("Moore's Law")
#> Error in load_tt_data("Moore's Law"): No entries found for title: 'Moore's Law'
ttd_length(ttd)
#> [1] 3
```
