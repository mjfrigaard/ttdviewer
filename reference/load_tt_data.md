# Load TidyTuesday datasets from GitHub by title

Filters an internal dataset `all_tt_combined` by `title`, and loads
associated data files using appropriate methods depending on
`data_type`. Supports functional error handling and logging.

## Usage

``` r
load_tt_data(title)
```

## Arguments

- title:

  A character string matching the `title` field in `all_tt_combined`.

## Value

A named list of tibbles or data frames (one per file). Failed or skipped
datasets are excluded.

## Features

- Automatically selects the correct reader (`csv`, `tsv`, `xlsx`, `rds`)

- Logs messages using
  [`logr_msg()`](https://mjfrigaard.github.io/ttdviewer/reference/logr_msg.md)

- Adds a `clean_title` attribute to each dataset

- Skips unsupported formats (`vgz`, `zip`, `NA`)

## Supported file types

- `"csv"` / `"csv.gz"` →
  [`vroom::vroom()`](https://vroom.tidyverse.org/reference/vroom.html)

- `"tsv"` →
  [`vroom::vroom()`](https://vroom.tidyverse.org/reference/vroom.html)

- `"xlsx"` →
  [`readxl::read_excel()`](https://readxl.tidyverse.org/reference/read_excel.html)

- `"rds"` → [`readRDS()`](https://rdrr.io/r/base/readRDS.html) from a
  URL connection

## Unsupported

- `"vgz"`, `"zip"`, or `NA` → skipped with error logging

## Examples

``` r
load_tt_data("posit::conf talks")
#> INFO [2026-01-15 19:44:25] Starting import for conf2023.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2025/2025-01-14/conf2023.csv
#> SUCCESS [2026-01-15 19:44:25] Successfully loaded conf2023.csv
#> INFO [2026-01-15 19:44:25] Starting import for conf2024.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2025/2025-01-14/conf2024.csv
#> SUCCESS [2026-01-15 19:44:25] Successfully loaded conf2024.csv
#> $conf2023.csv
#> # A tibble: 116 × 9
#>    speaker_name speaker_affiliation session_type session_title block_track_title
#>    <chr>        <chr>               <chr>        <chr>         <chr>            
#>  1 Elaine McVey Chief               keynote      From Data Co… From Data Confus…
#>  2 David Meza   NASA                keynote      From Data Co… From Data Confus…
#>  3 Daniel Wood… Eli Lilly & Company regular      Developing a… Building effecti…
#>  4 Liz Roten    Metropolitan Counc… regular      How to grace… Building effecti…
#>  5 Andrew Holz  Posit               regular      Oops I'm a m… Building effecti…
#>  6 Patrick Ten… Meadows Mental Hea… regular      The Gonzalez… Building effecti…
#>  7 Natalia And… Pfizer              regular      Building a C… Pharma           
#>  8 Mike K Smith Pfizer R&D UK Ltd   regular      Open-source … Pharma           
#>  9 Ben Arancib… GSK                 regular      The Need for… Pharma           
#> 10 Colby T. Fo… Tuple, LLC / Amiss… regular      Succeed in t… Pharma           
#> # ℹ 106 more rows
#> # ℹ 4 more variables: session_date <date>, session_start <dttm>,
#> #   session_length <dbl>, session_abstract <chr>
#> 
#> $conf2024.csv
#> # A tibble: 106 × 5
#>    talk_title                              speaker_name track description yt_url
#>    <chr>                                   <chr>        <chr> <chr>       <chr> 
#>  1 A future of data science                Allen Downey Keyn… "In the hy… https…
#>  2 Beyond Dashboards: Dynamic Data Storyt… Sean Nguyen  Auto… "In this t… https…
#>  3 Quarto, AI, and the Art of Getting You… Tyler Morga… Auto… "Tired of … https…
#>  4 Creating reproducible static reports    Orla Doyle   Auto… "This talk… https…
#>  5 Quarto: A Multifaceted Publishing Powe… Joshua Cook  Auto… "Tradition… https…
#>  6 Adequate Tables? No, We Want Great Tab… Richard Ian… Beau… "Tables ar… https…
#>  7 Context is King                         Shannon Pil… Beau… "The quali… https…
#>  8 gtsummary: Streamlining Summary Tables… Daniel Sjob… Beau… "The gtsum… https…
#>  9 Stitch by Stitch: The Art of Engaging … Becca Krouse Beau… "In the wo… https…
#> 10 Open Source Software in Action: Expand… Gabriel Mor… Data… "The Urban… https…
#> # ℹ 96 more rows
#> 
```
