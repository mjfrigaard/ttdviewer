# Extract File Names from TidyTuesday Data Object

Extract File Names from TidyTuesday Data Object

Extract file names from TidyTuesday data object

## Usage

``` r
extract_file_names(tt_data)

extract_file_names(tt_data)
```

## Arguments

- tt_data:

  list of TidyTuesday data from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

## Value

Character vector of file names with extensions included

Character vector of file names with extensions included

## Examples

``` r
ttd <- load_tt_data("Moore's Law")
#> Error in load_tt_data("Moore's Law"): No entries found for title: 'Moore's Law'
extract_file_names(ttd)
#> Error: object 'ttd' not found


ttd <- load_tt_data("Moore’s Law")
#> INFO [2026-04-17 18:57:40] Starting import for cpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/cpu.csv
#> SUCCESS [2026-04-17 18:57:41] Successfully loaded cpu.csv
#> INFO [2026-04-17 18:57:41] Starting import for gpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/gpu.csv
#> SUCCESS [2026-04-17 18:57:41] Successfully loaded gpu.csv
#> INFO [2026-04-17 18:57:41] Starting import for ram.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/ram.csv
#> SUCCESS [2026-04-17 18:57:41] Successfully loaded ram.csv
extract_file_names(ttd)
#> [1] "cpu.csv" "gpu.csv" "ram.csv"
```
