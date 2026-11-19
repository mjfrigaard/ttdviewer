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
#> INFO [2026-11-19 21:51:08] Starting import for cpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/cpu.csv
#> SUCCESS [2026-11-19 21:51:09] Successfully loaded cpu.csv
#> INFO [2026-11-19 21:51:09] Starting import for gpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/gpu.csv
#> SUCCESS [2026-11-19 21:51:09] Successfully loaded gpu.csv
#> INFO [2026-11-19 21:51:09] Starting import for ram.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/ram.csv
#> SUCCESS [2026-11-19 21:51:09] Successfully loaded ram.csv

inspect_plot(ttd)
#> INFO [2026-11-19 21:51:09] inspect_plot(): starting analysis
#> INFO [2026-11-19 21:51:09] Beginning plot type 'types'



#> SUCCESS [2026-11-19 21:51:10] Completed plot type 'types'
#> INFO [2026-11-19 21:51:10] Beginning plot type 'mem'



#> SUCCESS [2026-11-19 21:51:10] Completed plot type 'mem'
#> INFO [2026-11-19 21:51:10] Beginning plot type 'na'



#> SUCCESS [2026-11-19 21:51:10] Completed plot type 'na'
#> INFO [2026-11-19 21:51:10] Beginning plot type 'cor'



#> SUCCESS [2026-11-19 21:51:11] Completed plot type 'cor'
#> INFO [2026-11-19 21:51:11] Beginning plot type 'imb'



#> SUCCESS [2026-11-19 21:51:11] Completed plot type 'imb'
#> INFO [2026-11-19 21:51:11] Beginning plot type 'num'



#> SUCCESS [2026-11-19 21:51:12] Completed plot type 'num'
#> INFO [2026-11-19 21:51:12] Beginning plot type 'cat'



#> SUCCESS [2026-11-19 21:51:13] Completed plot type 'cat'
#> SUCCESS [2026-11-19 21:51:13] inspect_plot(): all requested plots finished
#> NULL
inspect_plot(ttd, plots = c("types", "mem"))
#> INFO [2026-11-19 21:51:13] inspect_plot(): starting analysis
#> INFO [2026-11-19 21:51:13] Beginning plot type 'types'



#> SUCCESS [2026-11-19 21:51:13] Completed plot type 'types'
#> INFO [2026-11-19 21:51:13] Beginning plot type 'mem'



#> SUCCESS [2026-11-19 21:51:14] Completed plot type 'mem'
#> SUCCESS [2026-11-19 21:51:14] inspect_plot(): all requested plots finished
#> NULL
inspect_plot(ttd, plots = "cor")
#> INFO [2026-11-19 21:51:14] inspect_plot(): starting analysis
#> INFO [2026-11-19 21:51:14] Beginning plot type 'cor'



#> SUCCESS [2026-11-19 21:51:14] Completed plot type 'cor'
#> SUCCESS [2026-11-19 21:51:14] inspect_plot(): all requested plots finished
#> NULL
```
