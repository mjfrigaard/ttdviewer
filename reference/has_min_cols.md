# Check if Dataset Has Minimum Required Columns

Helper function to determine if a specific dataset has sufficient
columns of a given type for analysis.

## Usage

``` r
has_min_cols(col_list, dataset_idx, min_count = 1)
```

## Arguments

- col_list:

  A named list of column vectors (output from
  [`check_col_types()`](https://mjfrigaard.github.io/ttdviewer/reference/check_col_types.md))

- dataset_idx:

  Integer index of the dataset to check

- min_count:

  Minimum number of columns required (default: 1)

## Value

Logical indicating whether the dataset has sufficient columns

## Examples

``` r
ttd <- load_tt_data("Moore’s Law")
#> INFO [2026-01-15 19:40:12] Starting import for cpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/cpu.csv
#> SUCCESS [2026-01-15 19:40:12] Successfully loaded cpu.csv
#> INFO [2026-01-15 19:40:12] Starting import for gpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/gpu.csv
#> SUCCESS [2026-01-15 19:40:12] Successfully loaded gpu.csv
#> INFO [2026-01-15 19:40:12] Starting import for ram.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/ram.csv
#> SUCCESS [2026-01-15 19:40:12] Successfully loaded ram.csv
num_cols <- check_col_types(ttd, "num")
has_min_cols(num_cols, 1, min_count = 2)
#> [1] TRUE
```
