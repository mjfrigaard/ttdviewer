# Determine length of TidyTuesday Data

Determine length of TidyTuesday Data

## Usage

``` r
ttd_length(ttd)
```

## Arguments

- ttd:

  A list of data frames from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

## Value

integer length of `ttd`

## Examples

``` r
ttd <- load_tt_data("Moore’s Law")
#> {"time":"2026-01-15 19:40:26","level":"INFO","ns":"ttdviewer","ans":"global","topenv":"ttdviewer","fn":"logr_msg","node":"runnervmi13qx","arch":"x86_64","os_name":"Linux","os_release":"6.11.0-1018-azure","os_version":"#18~24.04.1-Ubuntu SMP Sat Jun 28 04:46:03 UTC 2025","pid":7221,"user":"runner","msg":"Starting import for cpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/cpu.csv"}
#> {"time":"2026-01-15 19:40:26","level":"SUCCESS","ns":"ttdviewer","ans":"global","topenv":"ttdviewer","fn":"logr_msg","node":"runnervmi13qx","arch":"x86_64","os_name":"Linux","os_release":"6.11.0-1018-azure","os_version":"#18~24.04.1-Ubuntu SMP Sat Jun 28 04:46:03 UTC 2025","pid":7221,"user":"runner","msg":"Successfully loaded cpu.csv"}
#> {"time":"2026-01-15 19:40:26","level":"INFO","ns":"ttdviewer","ans":"global","topenv":"ttdviewer","fn":"logr_msg","node":"runnervmi13qx","arch":"x86_64","os_name":"Linux","os_release":"6.11.0-1018-azure","os_version":"#18~24.04.1-Ubuntu SMP Sat Jun 28 04:46:03 UTC 2025","pid":7221,"user":"runner","msg":"Starting import for gpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/gpu.csv"}
#> {"time":"2026-01-15 19:40:26","level":"SUCCESS","ns":"ttdviewer","ans":"global","topenv":"ttdviewer","fn":"logr_msg","node":"runnervmi13qx","arch":"x86_64","os_name":"Linux","os_release":"6.11.0-1018-azure","os_version":"#18~24.04.1-Ubuntu SMP Sat Jun 28 04:46:03 UTC 2025","pid":7221,"user":"runner","msg":"Successfully loaded gpu.csv"}
#> {"time":"2026-01-15 19:40:26","level":"INFO","ns":"ttdviewer","ans":"global","topenv":"ttdviewer","fn":"logr_msg","node":"runnervmi13qx","arch":"x86_64","os_name":"Linux","os_release":"6.11.0-1018-azure","os_version":"#18~24.04.1-Ubuntu SMP Sat Jun 28 04:46:03 UTC 2025","pid":7221,"user":"runner","msg":"Starting import for ram.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/ram.csv"}
#> {"time":"2026-01-15 19:40:26","level":"SUCCESS","ns":"ttdviewer","ans":"global","topenv":"ttdviewer","fn":"logr_msg","node":"runnervmi13qx","arch":"x86_64","os_name":"Linux","os_release":"6.11.0-1018-azure","os_version":"#18~24.04.1-Ubuntu SMP Sat Jun 28 04:46:03 UTC 2025","pid":7221,"user":"runner","msg":"Successfully loaded ram.csv"}
ttd_length(ttd)
#> [1] 3
```
