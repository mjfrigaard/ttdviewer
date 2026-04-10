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
#> {"time":"2026-04-10 16:29:45","level":"INFO","ns":"ttdviewer","ans":"global","topenv":"ttdviewer","fn":"logr_msg","node":"runnervm35a4x","arch":"x86_64","os_name":"Linux","os_release":"6.17.0-1010-azure","os_version":"#10~24.04.1-Ubuntu SMP Fri Mar  6 22:00:57 UTC 2026","pid":8138,"user":"runner","msg":"Starting import for cpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/cpu.csv"}
#> {"time":"2026-04-10 16:29:45","level":"SUCCESS","ns":"ttdviewer","ans":"global","topenv":"ttdviewer","fn":"logr_msg","node":"runnervm35a4x","arch":"x86_64","os_name":"Linux","os_release":"6.17.0-1010-azure","os_version":"#10~24.04.1-Ubuntu SMP Fri Mar  6 22:00:57 UTC 2026","pid":8138,"user":"runner","msg":"Successfully loaded cpu.csv"}
#> {"time":"2026-04-10 16:29:45","level":"INFO","ns":"ttdviewer","ans":"global","topenv":"ttdviewer","fn":"logr_msg","node":"runnervm35a4x","arch":"x86_64","os_name":"Linux","os_release":"6.17.0-1010-azure","os_version":"#10~24.04.1-Ubuntu SMP Fri Mar  6 22:00:57 UTC 2026","pid":8138,"user":"runner","msg":"Starting import for gpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/gpu.csv"}
#> {"time":"2026-04-10 16:29:45","level":"SUCCESS","ns":"ttdviewer","ans":"global","topenv":"ttdviewer","fn":"logr_msg","node":"runnervm35a4x","arch":"x86_64","os_name":"Linux","os_release":"6.17.0-1010-azure","os_version":"#10~24.04.1-Ubuntu SMP Fri Mar  6 22:00:57 UTC 2026","pid":8138,"user":"runner","msg":"Successfully loaded gpu.csv"}
#> {"time":"2026-04-10 16:29:45","level":"INFO","ns":"ttdviewer","ans":"global","topenv":"ttdviewer","fn":"logr_msg","node":"runnervm35a4x","arch":"x86_64","os_name":"Linux","os_release":"6.17.0-1010-azure","os_version":"#10~24.04.1-Ubuntu SMP Fri Mar  6 22:00:57 UTC 2026","pid":8138,"user":"runner","msg":"Starting import for ram.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/ram.csv"}
#> {"time":"2026-04-10 16:29:45","level":"SUCCESS","ns":"ttdviewer","ans":"global","topenv":"ttdviewer","fn":"logr_msg","node":"runnervm35a4x","arch":"x86_64","os_name":"Linux","os_release":"6.17.0-1010-azure","os_version":"#10~24.04.1-Ubuntu SMP Fri Mar  6 22:00:57 UTC 2026","pid":8138,"user":"runner","msg":"Successfully loaded ram.csv"}
ttd_length(ttd)
#> [1] 3

ttd <- load_tt_data("Moore's Law")
#> Error in load_tt_data("Moore's Law"): No entries found for title: 'Moore's Law'
ttd_length(ttd)
#> [1] 3
```
