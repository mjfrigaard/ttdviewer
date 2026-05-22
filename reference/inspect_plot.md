# Inspect and Plot TidyTuesday Data

Analyzes TidyTuesday datasets and generates inspection plots based on
data characteristics and number of datasets.

## Usage

``` r
inspect_plot(ttd, plots = "all")
```

## Arguments

- ttd:

  A list of data frames from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

- plots:

  Character vector specifying which plots to generate. Options:

  - `"types"` - Column type distributions

  - `"mem"` - Memory usage analysis

  - `"na"` - Missing value analysis

  - `"cor"` - Correlation analysis (numeric columns)

  - `"imb"` - Feature imbalance (categorical columns)

  - `"num"` - Numeric column summaries

  - `"cat"` - Categorical column summaries

  - `"all"` - Generate all available plots (default)

## Value

Invisibly returns `NULL`. Called for side effects (plots are displayed).

## Examples

``` r
ttd <- load_tt_data("Moore’s Law")
#> INFO [2026-05-22 17:53:13] Starting import for cpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/cpu.csv
#> SUCCESS [2026-05-22 17:53:13] Successfully loaded cpu.csv
#> INFO [2026-05-22 17:53:13] Starting import for gpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/gpu.csv
#> SUCCESS [2026-05-22 17:53:13] Successfully loaded gpu.csv
#> INFO [2026-05-22 17:53:13] Starting import for ram.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/ram.csv
#> SUCCESS [2026-05-22 17:53:13] Successfully loaded ram.csv

inspect_plot(ttd)
#> INFO [2026-05-22 17:53:13] inspect_plot(): starting analysis
#> INFO [2026-05-22 17:53:13] Beginning plot type 'types'



#> SUCCESS [2026-05-22 17:53:14] Completed plot type 'types'
#> INFO [2026-05-22 17:53:14] Beginning plot type 'mem'



#> SUCCESS [2026-05-22 17:53:14] Completed plot type 'mem'
#> INFO [2026-05-22 17:53:14] Beginning plot type 'na'



#> SUCCESS [2026-05-22 17:53:15] Completed plot type 'na'
#> INFO [2026-05-22 17:53:15] Beginning plot type 'cor'



#> SUCCESS [2026-05-22 17:53:15] Completed plot type 'cor'
#> INFO [2026-05-22 17:53:15] Beginning plot type 'imb'



#> SUCCESS [2026-05-22 17:53:16] Completed plot type 'imb'
#> INFO [2026-05-22 17:53:16] Beginning plot type 'num'



#> SUCCESS [2026-05-22 17:53:17] Completed plot type 'num'
#> INFO [2026-05-22 17:53:17] Beginning plot type 'cat'
#> ERROR [2026-05-22 17:53:17] Error in plot type 'cat': In index: 1.
#> SUCCESS [2026-05-22 17:53:17] inspect_plot(): all requested plots finished
#> NULL
inspect_plot(ttd, plots = c("types", "mem"))
#> INFO [2026-05-22 17:53:17] inspect_plot(): starting analysis
#> INFO [2026-05-22 17:53:17] Beginning plot type 'types'



#> SUCCESS [2026-05-22 17:53:17] Completed plot type 'types'
#> INFO [2026-05-22 17:53:17] Beginning plot type 'mem'



#> SUCCESS [2026-05-22 17:53:18] Completed plot type 'mem'
#> SUCCESS [2026-05-22 17:53:18] inspect_plot(): all requested plots finished
#> NULL
inspect_plot(ttd, plots = "cor")
#> INFO [2026-05-22 17:53:18] inspect_plot(): starting analysis
#> INFO [2026-05-22 17:53:18] Beginning plot type 'cor'



#> SUCCESS [2026-05-22 17:53:18] Completed plot type 'cor'
#> SUCCESS [2026-05-22 17:53:18] inspect_plot(): all requested plots finished
#> NULL
```
