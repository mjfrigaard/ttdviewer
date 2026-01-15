# Inspect and Plot TidyTuesday Data

A comprehensive function that analyzes TidyTuesday datasets and
generates appropriate inspection plots based on data characteristics and
number of datasets.

## Usage

``` r
inspect_plot(ttd, plots = "all")
```

## Arguments

- ttd:

  A list of data frames from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

- plot:

  Character vector specifying which plots to generate. Options include:

  - `"types"` - Column type distributions

  - `"mem"` - Memory usage analysis

  - `"na"` - Missing value analysis

  - `"cor"` - Correlation analysis (numeric columns)

  - `"imb"` - Feature imbalance (categorical columns)

  - `"num"` - Numeric column summaries

  - `"cat"` - Categorical column summaries

  - `"all"` - Generate all available plots (default)

## Value

Plots are displayed; function is called for side effects

## Examples

``` r
ttd <- load_tt_data("Moore’s Law")
#> INFO [2026-01-15 19:40:12] Starting import for cpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/cpu.csv
#> SUCCESS [2026-01-15 19:40:12] Successfully loaded cpu.csv
#> INFO [2026-01-15 19:40:12] Starting import for gpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/gpu.csv
#> SUCCESS [2026-01-15 19:40:12] Successfully loaded gpu.csv
#> INFO [2026-01-15 19:40:12] Starting import for ram.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/ram.csv
#> SUCCESS [2026-01-15 19:40:12] Successfully loaded ram.csv

# Generate all plots
inspect_plot(ttd)
#> INFO [2026-01-15 19:40:12] inspect_plot(): starting analysis
#> INFO [2026-01-15 19:40:12] Beginning plot type 'types'



#> SUCCESS [2026-01-15 19:40:13] Completed plot type 'types'
#> INFO [2026-01-15 19:40:13] Beginning plot type 'mem'



#> SUCCESS [2026-01-15 19:40:14] Completed plot type 'mem'
#> INFO [2026-01-15 19:40:14] Beginning plot type 'na'



#> SUCCESS [2026-01-15 19:40:14] Completed plot type 'na'
#> INFO [2026-01-15 19:40:14] Beginning plot type 'cor'



#> SUCCESS [2026-01-15 19:40:15] Completed plot type 'cor'
#> INFO [2026-01-15 19:40:15] Beginning plot type 'imb'



#> SUCCESS [2026-01-15 19:40:15] Completed plot type 'imb'
#> INFO [2026-01-15 19:40:15] Beginning plot type 'num'



#> SUCCESS [2026-01-15 19:40:16] Completed plot type 'num'
#> INFO [2026-01-15 19:40:16] Beginning plot type 'cat'
#> Warning: Ignoring unknown parameters: `size`

#> Warning: Ignoring unknown parameters: `size`

#> Warning: Ignoring unknown parameters: `size`

#> SUCCESS [2026-01-15 19:40:17] Completed plot type 'cat'
#> SUCCESS [2026-01-15 19:40:17] inspect_plot(): all requested plots finished
#> NULL

# Generate only specific plots
inspect_plot(ttd, plot = c("types", "mem"))
#> INFO [2026-01-15 19:40:17] inspect_plot(): starting analysis
#> INFO [2026-01-15 19:40:17] Beginning plot type 'types'



#> SUCCESS [2026-01-15 19:40:18] Completed plot type 'types'
#> INFO [2026-01-15 19:40:18] Beginning plot type 'mem'



#> SUCCESS [2026-01-15 19:40:18] Completed plot type 'mem'
#> SUCCESS [2026-01-15 19:40:18] inspect_plot(): all requested plots finished
#> NULL

# Generate single plot type
inspect_plot(ttd, plot = "cor")
#> INFO [2026-01-15 19:40:18] inspect_plot(): starting analysis
#> INFO [2026-01-15 19:40:18] Beginning plot type 'cor'



#> SUCCESS [2026-01-15 19:40:19] Completed plot type 'cor'
#> SUCCESS [2026-01-15 19:40:19] inspect_plot(): all requested plots finished
#> NULL
```
