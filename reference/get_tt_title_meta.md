# Get Dataset Metadata

Analyzes the column types across all datasets in a TidyTuesday data list
and returns a `tibble` with column type information.

## Usage

``` r
get_tt_title_meta(ttd)
```

## Arguments

- ttd:

  A list of data frames from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

## Value

A tibble with four columns:

- `clean_title`: Clean title of data

- `col_type`: Type of column (numeric, logical, character, list)

- `dataset`: Name of the dataset

- `col`: Column name (NA if no columns of that type exist)

## See also

[`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

## Examples

``` r
ttd <- load_tt_data("Moore’s Law")
#> INFO [2026-01-15 19:40:11] Starting import for cpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/cpu.csv
#> SUCCESS [2026-01-15 19:40:11] Successfully loaded cpu.csv
#> INFO [2026-01-15 19:40:11] Starting import for gpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/gpu.csv
#> SUCCESS [2026-01-15 19:40:11] Successfully loaded gpu.csv
#> INFO [2026-01-15 19:40:11] Starting import for ram.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/ram.csv
#> SUCCESS [2026-01-15 19:40:11] Successfully loaded ram.csv
meta <- get_tt_title_meta(ttd)
#> INFO [2026-01-15 19:40:11] Datasets in list: cpu.csv, gpu.csv, ram.csv
#> INFO [2026-01-15 19:40:11] Created metadata tibble with 30 rows covering 3 datasets
print(meta)
#> # A tibble: 30 × 4
#>    clean_title dataset col                  col_type 
#>    <chr>       <chr>   <chr>                <chr>    
#>  1 moores_law  cpu.csv transistor_count     numeric  
#>  2 moores_law  cpu.csv date_of_introduction numeric  
#>  3 moores_law  cpu.csv process              numeric  
#>  4 moores_law  cpu.csv area                 numeric  
#>  5 moores_law  cpu.csv NA                   logical  
#>  6 moores_law  cpu.csv processor            character
#>  7 moores_law  cpu.csv designer             character
#>  8 moores_law  cpu.csv NA                   list     
#>  9 moores_law  gpu.csv transistor_count     numeric  
#> 10 moores_law  gpu.csv date_of_introduction numeric  
#> # ℹ 20 more rows
```
