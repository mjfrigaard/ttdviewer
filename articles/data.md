# Data

``` r
library(ttdviewer)
library(dplyr)
library(tidyr)
library(ttmeta)
```

This document covers the `#TidyTuesday` data used in the application.

## Other \#TidyTuesday R packages

Below is an overview of other R packages that access \#TidyTuesday data.

### [tidytuesdayR](https://dslc-io.github.io/tidytuesdayR/)

The [`tidytuesdayR`](https://dslc-io.github.io/tidytuesdayR/) package is
designed for, “*providing functions to quickly import data posted to the
Tidy Tuesday repository.*”

``` r
library(tidytuesdayR)
```

The
[`tt_load()`](https://dslc-io.github.io/tidytuesdayR/reference/tt_load.html)
function downloads the data using a date input.

``` r
tt_data <- tt_load("2025-07-08")
#> ---- Compiling #TidyTuesday Information for 2025-07-08 ----
#> --- There are 3 files available ---
#> 
#> 
#> ── Downloading files ───────────────────────────────────────────────────────────
#> 
#>   1 of 3: "answers.csv"
#>   2 of 3: "color_ranks.csv"
#>   3 of 3: "users.csv"
```

The downloaded object is a list, but with a few additional attributes.

``` r
str(tt_data)
#> List of 3
#>  $ answers    : spc_tbl_ [1,058,211 × 3] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ user_id: num [1:1058211] 1 2 2 2 2 2 2 2 4 4 ...
#>   ..$ hex    : chr [1:1058211] "#8240EA" "#4B31EA" "#584601" "#DA239C" ...
#>   ..$ rank   : num [1:1058211] 1 3 5 4 1 2 3 3 1 2 ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   user_id = col_double(),
#>   .. ..   hex = col_character(),
#>   .. ..   rank = col_double()
#>   .. .. )
#>   ..- attr(*, "problems")=<externalptr> 
#>  $ color_ranks: spc_tbl_ [949 × 3] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ color: chr [1:949] "purple" "green" "blue" "pink" ...
#>   ..$ rank : num [1:949] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ hex  : chr [1:949] "#7e1e9c" "#15b01a" "#0343df" "#ff81c0" ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   color = col_character(),
#>   .. ..   rank = col_double(),
#>   .. ..   hex = col_character()
#>   .. .. )
#>   ..- attr(*, "problems")=<externalptr> 
#>  $ users      : spc_tbl_ [152,401 × 5] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ user_id     : num [1:152401] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ monitor     : chr [1:152401] "LCD" "LCD" "LCD" "LCD" ...
#>   ..$ y_chromosome: num [1:152401] 1 1 1 0 1 1 1 1 1 1 ...
#>   ..$ colorblind  : num [1:152401] 0 0 0 0 0 0 0 0 0 0 ...
#>   ..$ spam_prob   : num [1:152401] 0.00209 0.07458 0.0164 0.00156 0.00238 ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   user_id = col_double(),
#>   .. ..   monitor = col_character(),
#>   .. ..   y_chromosome = col_double(),
#>   .. ..   colorblind = col_double(),
#>   .. ..   spam_prob = col_double()
#>   .. .. )
#>   ..- attr(*, "problems")=<externalptr> 
#>  - attr(*, ".tt")= 'tt' chr [1:3] "answers.csv" "color_ranks.csv" "users.csv"
#>   ..- attr(*, ".files")='data.frame':    3 obs. of  3 variables:
#>   .. ..$ data_files: chr [1:3] "answers.csv" "color_ranks.csv" "users.csv"
#>   .. ..$ data_type : chr [1:3] "csv" "csv" "csv"
#>   .. ..$ delim     : chr [1:3] "," "," ","
#>   ..- attr(*, ".readme")=List of 2
#>   .. ..$ node:<externalptr> 
#>   .. ..$ doc :<externalptr> 
#>   .. ..- attr(*, "class")= chr [1:2] "xml_document" "xml_node"
#>   ..- attr(*, ".date")= Date[1:1], format: "2025-07-08"
#>  - attr(*, "class")= chr "tt_data"
```

### Class

The `tt_data` list has it’s own special class (`"tt_data"`).

``` r
attr(tt_data, "class")
#> [1] "tt_data"
```

The `.tt` attribute prints the available datasets for the `date`.

``` r
attr(tt_data, ".tt")
#> Available datasets in this TidyTuesday:
#>  answers.csv 
#>  color_ranks.csv 
#>  users.csv 
#>  
```

The `.tt` attribute also lists the available datasets, a `.files`
dataset with file type and delim, the `.readme` (as html), and the
`.date`:

``` r
str(attr(tt_data, ".tt"))
#>  'tt' chr [1:3] "answers.csv" "color_ranks.csv" "users.csv"
#>  - attr(*, ".files")='data.frame':   3 obs. of  3 variables:
#>   ..$ data_files: chr [1:3] "answers.csv" "color_ranks.csv" "users.csv"
#>   ..$ data_type : chr [1:3] "csv" "csv" "csv"
#>   ..$ delim     : chr [1:3] "," "," ","
#>  - attr(*, ".readme")=List of 2
#>   ..$ node:<externalptr> 
#>   ..$ doc :<externalptr> 
#>   ..- attr(*, "class")= chr [1:2] "xml_document" "xml_node"
#>  - attr(*, ".date")= Date[1:1], format: "2025-07-08"
```

The `.tt` attribute also has `.files`, `.readme`, and `.date`
attributes.

#### .files

``` r
attr(tt_data, ".tt") |> 
  attr(".files")
#>         data_files data_type delim
#> 70     answers.csv       csv     ,
#> 71 color_ranks.csv       csv     ,
#> 72       users.csv       csv     ,
```

#### .readme

``` r
attr(tt_data, ".tt") |> 
  attr(".readme")
#> {html_document}
#> <html>
#> [1] <body><div id="file" class="md" data-path="data/2025/2025-07-08/readme.md ...
```

#### .date

``` r
attr(tt_data, ".tt") |> 
  attr(".date")
#> [1] "2025-07-08"
```

### [ttmeta](https://r4ds.github.io/ttmeta/)

The [`ttmeta`](https://r4ds.github.io/ttmeta/) package provides, “*a
summary of each weekly TidyTuesday post, information about the articles
and data sources linked in those posts, and details about the datasets
themselves, including variable names and classes.*”

``` r
library(ttmeta)
```

The
[`get_tt_tbl()`](https://r4ds.github.io/ttmeta/reference/get_tt_tbl.html)
function allows users to download a “*`tibble` of information about
TidyTuesday weeks in the requested timeframe*”

``` r
tt_meta <- get_tt_tbl(min_year = 2025L, max_year = this_year())
```

``` r
dplyr::glimpse(tt_meta)
#> Rows: 68
#> Columns: 8
#> $ year          <int> 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 20…
#> $ week          <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 1…
#> $ date          <date> 2025-01-07, 2025-01-14, 2025-01-21, 2025-01-28, 2025-02…
#> $ title         <chr> "Bring your own data from 2024!", "posit::conf talks", "…
#> $ source_title  <chr> "NA", "posit::conf attendee portal 2023, posit::conf att…
#> $ source_urls   <list> <>, <"https://reg.conf.posit.co/flow/posit/positconf23/…
#> $ article_title <chr> "NA", "posit::conf(2025) in-person registration is now o…
#> $ article_urls  <list> <>, "https://posit.co/blog/positconf2025-in-person-regi…
```

## GitHub URLs

The [\#TidyTuesday
repository](https://github.com/rfordatascience/tidytuesday) has [a .csv
file](https://github.com/rfordatascience/tidytuesday/blob/main/static/tt_data_type.csv)
with the `Week`, `Date`, `year`, `data_files`, `data_type`, and `delim`:

This file is used to create the `tt_github_urls` data:

``` r
tt_github_urls <- vroom::vroom(
  file = "https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/static/tt_data_type.csv",
  delim = ",") |>
  # create github_url column
  dplyr::mutate(
    github_url = glue::glue(
      "https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/{year}/{Date}/{data_files}"
    )
  ) |>
  # clean names
  dplyr::rename(
    week = Week,
    date = Date
  ) 
#> Rows: 837 Columns: 6
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr  (3): data_files, data_type, delim
#> dbl  (2): Week, year
#> date (1): Date
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
dplyr::glimpse(tt_github_urls)
#> Rows: 837
#> Columns: 7
#> $ week       <dbl> 16, 16, 16, 15, 15, 15, 15, 14, 14, 13, 13, 12, 11, 11, 10,…
#> $ date       <date> 2026-04-21, 2026-04-21, 2026-04-21, 2026-04-14, 2026-04-14…
#> $ year       <dbl> 2026, 2026, 2026, 2026, 2026, 2026, 2026, 2026, 2026, 2026,…
#> $ data_files <chr> "financing_schemes.csv", "health_spending.csv", "spending_p…
#> $ data_type  <chr> "csv", "csv", "csv", "csv", "csv", "csv", "csv", "csv", "cs…
#> $ delim      <chr> ",", ",", ",", ",", ",", ",", ",", ",", ",", ",", ",", ",",…
#> $ github_url <glue> "https://raw.githubusercontent.com/rfordatascience/tidytue…
```

The `tt_github_urls` data comes from the [.csv file in TidyTuesday
repo](https://github.com/rfordatascience/tidytuesday/blob/main/static/tt_data_type.csv):

### All TidyTuesday Data

The `all_tt_data.rda` dataset contains all years (2018 - current) from
the
[`ttmeta::get_tt_tbl()`](https://r4ds.github.io/ttmeta/reference/get_tt_tbl.html)
function. This datasets contain the following columns:

``` r
dplyr::glimpse(all_tt_data)
#> Rows: 409
#> Columns: 9
#> $ year          <int> 2026, 2026, 2026, 2026, 2026, 2026, 2025, 2025, 2025, 20…
#> $ week          <int> 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,…
#> $ date          <date> 2026-01-06, 2026-01-13, 2026-01-20, 2026-01-27, 2026-02…
#> $ title         <chr> "Bring your own data from 2025!", "The Languages of Afri…
#> $ clean_title   <chr> "bring_your_own_data_from_2025", "the_languages_of_afric…
#> $ source_title  <chr> "NA", "Languages of Africa", "NASA API", "Open data CNPJ…
#> $ source_urls   <list> <>, "https://en.wikipedia.org/wiki/Languages_of_Africa"…
#> $ article_title <chr> "NA", "Languages of Africa", "Astronomy Picture of the D…
#> $ article_urls  <list> <>, "https://en.wikipedia.org/wiki/Languages_of_Africa"…
```

### All TidyTuesday Meta

The `all_tt_meta.rda` dataset contains all years (2018 - current) from
the `ttmeta::load_tt_datasets_metadata()`. This dataset the following
columns:

``` r
dplyr::glimpse(all_tt_meta)
#> Rows: 814
#> Columns: 6
#> $ year             <int> 2026, 2026, 2026, 2026, 2026, 2026, 2026, 2026, 2026,…
#> $ week             <int> 1, 2, 3, 4, 4, 4, 4, 5, 6, 1, 2, 2, 3, 3, 4, 4, 5, 5,…
#> $ dataset_name     <chr> NA, "africa", "apod", "companies", "legal_nature", "q…
#> $ variables        <int> NA, 4, 7, 6, 2, 2, 2, 20, 21, NA, 9, 5, 69, 29, 7, 7,…
#> $ observations     <int> NA, 796, 6888, 141332, 91, 68, 4, 140, 1866, NA, 116,…
#> $ variable_details <list> <NULL>, [<tbl_df[4 x 6]>], [<tbl_df[7 x 6]>], [<tbl_…
```

### All TidyTuesday Variable Details

The `all_tt_var_details.rda` dataset contains the following columns:

``` r
dplyr::glimpse(all_tt_var_details)
#> Rows: 8,958
#> Columns: 11
#> $ year         <int> 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 202…
#> $ week         <int> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, …
#> $ dataset_name <chr> "conf2023", "conf2023", "conf2023", "conf2023", "conf2023…
#> $ variables    <int> 9, 9, 9, 9, 9, 9, 9, 9, 9, 5, 5, 5, 5, 5, 69, 69, 69, 69,…
#> $ observations <int> 116, 116, 116, 116, 116, 116, 116, 116, 116, 106, 106, 10…
#> $ variable     <chr> "speaker_name", "speaker_affiliation", "session_type", "s…
#> $ class        <chr> "character", "character", "character", "character", "char…
#> $ n_unique     <int> 115, 81, 3, 110, 28, 2, 39, 3, 110, 106, 105, 25, 102, 10…
#> $ min          <list> "Aaron Chafetz", "A Plus Associates, Posit PBC(Contracto…
#> $ max          <list> "Wyl Schuth", "Washington State Department of Agricultur…
#> $ description  <chr> "The name of the speaker. The data is indexed by this fie…
```

### All TidyTuesday Combined

The `all_tt_combined.rda` dataset is `all_tt_meta` left-joined with
`all_tt_data` by `year` and `week`.

``` r
dplyr::glimpse(all_tt_combined)
#> Rows: 25,727
#> Columns: 20
#> $ title         <chr> "The Languages of Africa", "The Languages of Africa", "T…
#> $ clean_title   <chr> "the_languages_of_africa", "the_languages_of_africa", "t…
#> $ dataset_name  <chr> "africa", "africa", "africa", "africa", "apod", "apod", …
#> $ year          <dbl> 2026, 2026, 2026, 2026, 2026, 2026, 2026, 2026, 2026, 20…
#> $ week          <dbl> 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4,…
#> $ date          <date> 2026-01-13, 2026-01-13, 2026-01-13, 2026-01-13, 2026-01…
#> $ variables     <int> 4, 4, 4, 4, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6, 6, 6, 6, 6, 6,…
#> $ observations  <int> 796, 796, 796, 796, 6888, 6888, 6888, 6888, 6888, 6888, …
#> $ variable      <chr> "language", "family", "native_speakers", "country", "cop…
#> $ class         <chr> "character", "character", "double", "character", "charac…
#> $ n_unique      <int> 502, 17, 250, 51, 2252, 6888, 6767, 3, 5151, 6802, 6476,…
#> $ min           <list> "Abon", "Afro-Asiatic", 12, "Algeria", NA, 2007-01-01, …
#> $ max           <list> "ǂKxʼaoǁʼae", "Ubangian", 1.5e+08, "Zimbabwe", NA, 2025…
#> $ description   <chr> "Name of popular African language.", "Group of languages…
#> $ source_title  <chr> "Languages of Africa", "Languages of Africa", "Languages…
#> $ article_title <chr> "Languages of Africa", "Languages of Africa", "Languages…
#> $ data_files    <chr> "africa.csv", "africa.csv", "africa.csv", "africa.csv", …
#> $ data_type     <chr> "csv", "csv", "csv", "csv", "csv", "csv", "csv", "csv", …
#> $ delim         <chr> ",", ",", ",", ",", ",", ",", ",", ",", ",", ",", ",", "…
#> $ github_url    <glue> "https://raw.githubusercontent.com/rfordatascience/tidy…
```

The `clean_title` variable has been added to create an attribute we can
use to join to the `all_tt_var_details` data.

## load_tt_data()

The
[`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)
function uses the `title` from `all_tt_combined` to the return the
datasets from the GitHub repo.

### A single dataset

If the tile contains a single dataset, the list returns `ttd` with a
single element:

``` r
ttd <- load_tt_data("Netflix Titles")
#> INFO [2026-04-17 18:58:14] Starting import for netflix_titles.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2021/2021-04-20/netflix_titles.csv
#> SUCCESS [2026-04-17 18:58:15] Successfully loaded netflix_titles.csv
```

``` r
ttd_nms <- names(ttd)
ttd_nms
#> [1] "netflix_titles.csv"
```

The `clean_title` attribute can be used to join each dataset back to
`all_tt_combined` or `all_tt_data`:

``` r
attr(ttd[["netflix_titles.csv"]], "clean_title")
#> [1] "netflix_titles"
```

### Two datasets

If `ttd` has two datasets, we can subset the list with the name
position:

``` r
ttd2 <- load_tt_data("Space Launches")
#> INFO [2026-04-17 18:58:15] Starting import for agencies.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-01-15/agencies.csv
#> SUCCESS [2026-04-17 18:58:15] Successfully loaded agencies.csv
#> INFO [2026-04-17 18:58:15] Starting import for launches.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-01-15/launches.csv
#> SUCCESS [2026-04-17 18:58:15] Successfully loaded launches.csv
# store names 
ttd2_nms <- names(ttd2)
# check attr
purrr::map(.x = ttd2, .f = attr, "clean_title")
#> $agencies.csv
#> [1] "space_launches"
#> 
#> $launches.csv
#> [1] "space_launches"
# check first dataset 
dplyr::glimpse(ttd2[[ttd2_nms[1]]])
#> Rows: 74
#> Columns: 19
#> $ agency             <chr> "RVSN", "UNKS", "NASA", "USAF", "AE", "AFSC", "VKSR…
#> $ count              <dbl> 1528, 904, 469, 388, 258, 247, 200, 181, 128, 105, …
#> $ ucode              <chr> "RVSN", "GUKOS", "NASA", "USAF", "AE", "AFSC", "GUK…
#> $ state_code         <chr> "SU", "SU", "US", "US", "F", "US", "RU", "CN", "RU"…
#> $ type               <chr> "O/LA", "O/LA", "O/LA/LV/PL/S", "O/LA/S", "O/LA", "…
#> $ class              <chr> "D", "D", "C", "D", "B", "D", "D", "C", "C", "B", "…
#> $ tstart             <chr> "1960", "1986 Apr 24", "1958 Oct  1", "1947 Sep 18"…
#> $ tstop              <chr> "1991 Dec", "1991", "-", "-", "*", "1992 Jul  1", "…
#> $ short_name         <chr> "RVSN", "UNKS", "NASA", "USAF", "Arianespace", "AFS…
#> $ name               <chr> "Rakentiye Voiska Strategicheskogo Naznacheniye", "…
#> $ location           <chr> "Mosvka?", "Moskva", "Washington, D.C.", "Washingto…
#> $ longitude          <chr> "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "…
#> $ latitude           <chr> "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "…
#> $ error              <chr> "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "…
#> $ parent             <chr> "-", "MO", "-", "-", "-", "USAF", "RVSN", "CASC", "…
#> $ short_english_name <chr> "-", "-", "-", "-", "Arianespace", "-", "-", "CALT"…
#> $ english_name       <chr> "Strategic Rocket Forces", "-", "-", "-", "-", "-",…
#> $ unicode_name       <chr> "Ракетные войска стратегического назначения", "Упра…
#> $ agency_type        <chr> "state", "state", "state", "state", "private", "sta…
# check second dataset
dplyr::glimpse(ttd2[[ttd2_nms[2]]])
#> Rows: 5,726
#> Columns: 11
#> $ tag         <chr> "1967-065", "1967-080", "1967-096", "1968-042", "1968-092"…
#> $ JD          <dbl> 2439671, 2439726, 2439775, 2440000, 2440153, 2440426, 2440…
#> $ launch_date <date> 1967-06-29, 1967-08-23, 1967-10-11, 1968-05-23, 1968-10-2…
#> $ launch_year <dbl> 1967, 1967, 1967, 1968, 1968, 1969, 1970, 1970, 1971, 1971…
#> $ type        <chr> "Thor Burner 2", "Thor Burner 2", "Thor Burner 2", "Thor B…
#> $ variant     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ mission     <chr> "Secor Type II S/N 10", "DAPP 3419", "DAPP 4417", "DAPP 54…
#> $ agency      <chr> "US", "US", "US", "US", "US", "US", "US", "US", "US", "US"…
#> $ state_code  <chr> "US", "US", "US", "US", "US", "US", "US", "US", "US", "US"…
#> $ category    <chr> "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"…
#> $ agency_type <chr> "state", "state", "state", "state", "state", "state", "sta…
```

### Three datasets

If there are three datasets, we can see the names are assigned to each
element in the list:

``` r
ttd3 <- load_tt_data("Moore’s Law")
#> INFO [2026-04-17 18:58:15] Starting import for cpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/cpu.csv
#> SUCCESS [2026-04-17 18:58:15] Successfully loaded cpu.csv
#> INFO [2026-04-17 18:58:15] Starting import for gpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/gpu.csv
#> SUCCESS [2026-04-17 18:58:15] Successfully loaded gpu.csv
#> INFO [2026-04-17 18:58:15] Starting import for ram.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/ram.csv
#> SUCCESS [2026-04-17 18:58:15] Successfully loaded ram.csv
ttd3_nms <- names(ttd3)
# attr
purrr::map(.x = ttd3, .f = attr, "clean_title")
#> $cpu.csv
#> [1] "moores_law"
#> 
#> $gpu.csv
#> [1] "moores_law"
#> 
#> $ram.csv
#> [1] "moores_law"
dplyr::glimpse(ttd3[[ttd3_nms[1]]])
#> Rows: 176
#> Columns: 6
#> $ processor            <chr> "MP944 (20-bit, 6-chip)", "Intel 4004 (4-bit, 16-…
#> $ transistor_count     <dbl> NA, 2250, 3500, 2500, 2800, 3000, 4100, 6000, 800…
#> $ date_of_introduction <dbl> 1970, 1971, 1972, 1973, 1973, 1974, 1974, 1974, 1…
#> $ designer             <chr> "Garrett AiResearch", "Intel", "Intel", "NEC", "T…
#> $ process              <dbl> NA, 10000, 10000, 7500, 6000, 10000, 6000, 6000, …
#> $ area                 <dbl> NA, 12, 14, NA, 32, 12, 16, 20, 11, 21, NA, NA, 2…
dplyr::glimpse(ttd3[[ttd3_nms[2]]])
#> Rows: 112
#> Columns: 8
#> $ processor            <chr> "µPD7220 GDC", "ARTC HD63484", "YM7101 VDP", "Tom…
#> $ transistor_count     <dbl> 4.0e+04, 6.0e+04, 1.0e+05, 7.5e+05, 1.0e+06, 1.0e…
#> $ date_of_introduction <dbl> 1982, 1984, 1988, 1993, 1994, 1994, 1995, 1996, 1…
#> $ designer_s           <chr> "NEC", "Hitachi", "Sega", "Flare", "Sega", "Toshi…
#> $ manufacturer_s       <chr> "NEC", "Hitachi", "Yamaha", "IBM", "Hitachi", "LS…
#> $ process              <dbl> 5000, NA, NA, NA, 500, 500, 500, 350, 350, 500, 5…
#> $ area                 <dbl> NA, NA, NA, NA, NA, NA, 90, 81, NA, NA, NA, 90, 1…
#> $ ref                  <chr> "[107]", "[108]", "[109]", "[109]", "[110][111]",…
dplyr::glimpse(ttd3[[ttd3_nms[3]]])
#> Rows: 47
#> Columns: 10
#> $ chip_name            <chr> "N/A", "N/A", "?", "SP95", "TMC3162", "?", "?", "…
#> $ capacity_bits        <dbl> 1, 1, 8, 16, 16, NA, 256, 64, 144, 256, 1, 1, 1, …
#> $ bit_units            <chr> "Bits", "Bits", "Bits", "Bits", "Bits", NA, "Bits…
#> $ ram_type             <chr> "SRAM (cell)", "DRAM (cell)", "SRAM (bipolar)", "…
#> $ transistor_count     <dbl> 6, 1, 48, 80, 96, NA, 256, 384, 864, 1536, 768, 3…
#> $ date_of_introduction <dbl> 1963, 1965, 1965, 1965, 1966, 1966, 1968, 1968, 1…
#> $ manufacturer_s       <chr> "Fairchild", "Toshiba", "SDS, Signetics", "IBM", …
#> $ process              <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 12000, NA, 80…
#> $ area                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 10, N…
#> $ ref                  <chr> "[162]", "[163][164]", "[162]", "[165]", "[160]",…
```

### Many datasets

If there are more than two datasets, the same rules apply.

``` r
ttd_many <- load_tt_data("LEGO database")
#> INFO [2026-04-17 18:58:15] Starting import for colors.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/colors.csv.gz
#> SUCCESS [2026-04-17 18:58:15] Successfully loaded colors.csv.gz
#> INFO [2026-04-17 18:58:15] Starting import for elements.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/elements.csv.gz
#> SUCCESS [2026-04-17 18:58:16] Successfully loaded elements.csv.gz
#> INFO [2026-04-17 18:58:16] Starting import for inventories.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/inventories.csv.gz
#> SUCCESS [2026-04-17 18:58:16] Successfully loaded inventories.csv.gz
#> INFO [2026-04-17 18:58:16] Starting import for inventory_minifigs.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/inventory_minifigs.csv.gz
#> SUCCESS [2026-04-17 18:58:16] Successfully loaded inventory_minifigs.csv.gz
#> INFO [2026-04-17 18:58:16] Starting import for inventory_parts.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/inventory_parts.csv.gz
#> SUCCESS [2026-04-17 18:58:16] Successfully loaded inventory_parts.csv.gz
#> INFO [2026-04-17 18:58:16] Starting import for inventory_sets.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/inventory_sets.csv.gz
#> SUCCESS [2026-04-17 18:58:16] Successfully loaded inventory_sets.csv.gz
#> INFO [2026-04-17 18:58:16] Starting import for minifigs.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/minifigs.csv.gz
#> SUCCESS [2026-04-17 18:58:17] Successfully loaded minifigs.csv.gz
#> INFO [2026-04-17 18:58:17] Starting import for part_categories.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/part_categories.csv.gz
#> SUCCESS [2026-04-17 18:58:17] Successfully loaded part_categories.csv.gz
#> INFO [2026-04-17 18:58:17] Starting import for part_relationships.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/part_relationships.csv.gz
#> SUCCESS [2026-04-17 18:58:17] Successfully loaded part_relationships.csv.gz
#> INFO [2026-04-17 18:58:17] Starting import for parts.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/parts.csv.gz
#> SUCCESS [2026-04-17 18:58:17] Successfully loaded parts.csv.gz
#> INFO [2026-04-17 18:58:17] Starting import for sets.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/sets.csv.gz
#> SUCCESS [2026-04-17 18:58:17] Successfully loaded sets.csv.gz
#> INFO [2026-04-17 18:58:17] Starting import for themes.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/themes.csv.gz
#> SUCCESS [2026-04-17 18:58:17] Successfully loaded themes.csv.gz
ttd_many_nms <- names(ttd_many)
# check attr
purrr::map(.x = ttd_many, .f = attr, "clean_title")
#> $colors.csv.gz
#> [1] "lego_database"
#> 
#> $elements.csv.gz
#> [1] "lego_database"
#> 
#> $inventories.csv.gz
#> [1] "lego_database"
#> 
#> $inventory_minifigs.csv.gz
#> [1] "lego_database"
#> 
#> $inventory_parts.csv.gz
#> [1] "lego_database"
#> 
#> $inventory_sets.csv.gz
#> [1] "lego_database"
#> 
#> $minifigs.csv.gz
#> [1] "lego_database"
#> 
#> $part_categories.csv.gz
#> [1] "lego_database"
#> 
#> $part_relationships.csv.gz
#> [1] "lego_database"
#> 
#> $parts.csv.gz
#> [1] "lego_database"
#> 
#> $sets.csv.gz
#> [1] "lego_database"
#> 
#> $themes.csv.gz
#> [1] "lego_database"
```

## Meta data

The
[`get_tt_title_meta()`](https://mjfrigaard.github.io/ttdviewer/reference/get_tt_title_meta.md)
function returns info on the columns in each dataset in a `ttd` list.

``` r
ttd_meta <- get_tt_title_meta(ttd = ttd)
#> INFO [2026-04-17 18:58:17] Datasets in list: netflix_titles.csv
#> INFO [2026-04-17 18:58:17] Created metadata tibble with 14 rows covering 1 datasets
ttd_meta
#> # A tibble: 14 × 4
#>    clean_title    dataset            col          col_type 
#>    <chr>          <chr>              <chr>        <chr>    
#>  1 netflix_titles netflix_titles.csv release_year numeric  
#>  2 netflix_titles netflix_titles.csv NA           logical  
#>  3 netflix_titles netflix_titles.csv show_id      character
#>  4 netflix_titles netflix_titles.csv type         character
#>  5 netflix_titles netflix_titles.csv title        character
#>  6 netflix_titles netflix_titles.csv director     character
#>  7 netflix_titles netflix_titles.csv cast         character
#>  8 netflix_titles netflix_titles.csv country      character
#>  9 netflix_titles netflix_titles.csv date_added   character
#> 10 netflix_titles netflix_titles.csv rating       character
#> 11 netflix_titles netflix_titles.csv duration     character
#> 12 netflix_titles netflix_titles.csv listed_in    character
#> 13 netflix_titles netflix_titles.csv description  character
#> 14 netflix_titles netflix_titles.csv NA           list
```

``` r
ttd_meta |>
  dplyr::filter(col_type == "character") |>
  dplyr::count(clean_title, dataset, col_type, name = "chr_cols") |>
  dplyr::arrange(desc(chr_cols))
#> # A tibble: 1 × 4
#>   clean_title    dataset            col_type  chr_cols
#>   <chr>          <chr>              <chr>        <int>
#> 1 netflix_titles netflix_titles.csv character       11
```

``` r
ttd2_meta <- get_tt_title_meta(ttd = ttd2)
#> INFO [2026-04-17 18:58:17] Datasets in list: agencies.csv, launches.csv
#> INFO [2026-04-17 18:58:17] Created metadata tibble with 33 rows covering 2 datasets
head(ttd2_meta)
#> # A tibble: 6 × 4
#>   clean_title    dataset      col        col_type 
#>   <chr>          <chr>        <chr>      <chr>    
#> 1 space_launches agencies.csv count      numeric  
#> 2 space_launches agencies.csv NA         logical  
#> 3 space_launches agencies.csv agency     character
#> 4 space_launches agencies.csv ucode      character
#> 5 space_launches agencies.csv state_code character
#> 6 space_launches agencies.csv type       character
```

``` r
ttd3_meta <- get_tt_title_meta(ttd = ttd3)
#> INFO [2026-04-17 18:58:17] Datasets in list: cpu.csv, gpu.csv, ram.csv
#> INFO [2026-04-17 18:58:17] Created metadata tibble with 30 rows covering 3 datasets
head(ttd3_meta)
#> # A tibble: 6 × 4
#>   clean_title dataset col                  col_type 
#>   <chr>       <chr>   <chr>                <chr>    
#> 1 moores_law  cpu.csv transistor_count     numeric  
#> 2 moores_law  cpu.csv date_of_introduction numeric  
#> 3 moores_law  cpu.csv process              numeric  
#> 4 moores_law  cpu.csv area                 numeric  
#> 5 moores_law  cpu.csv NA                   logical  
#> 6 moores_law  cpu.csv processor            character
```

``` r
ttd_many_meta <- get_tt_title_meta(ttd = ttd_many)
#> INFO [2026-04-17 18:58:17] Datasets in list: colors.csv.gz, elements.csv.gz, inventories.csv.gz, inventory_minifigs.csv.gz, inventory_parts.csv.gz, inventory_sets.csv.gz, minifigs.csv.gz, part_categories.csv.gz, part_relationships.csv.gz, parts.csv.gz, sets.csv.gz, themes.csv.gz
#> INFO [2026-04-17 18:58:17] Created metadata tibble with 67 rows covering 12 datasets
head(ttd_many_meta)
#> # A tibble: 6 × 4
#>   clean_title   dataset         col        col_type 
#>   <chr>         <chr>           <chr>      <chr>    
#> 1 lego_database colors.csv.gz   id         numeric  
#> 2 lego_database colors.csv.gz   is_trans   logical  
#> 3 lego_database colors.csv.gz   name       character
#> 4 lego_database colors.csv.gz   rgb        character
#> 5 lego_database colors.csv.gz   NA         list     
#> 6 lego_database elements.csv.gz element_id numeric
```

Below is the number of numeric columns per `dataset` and `clean_title`:

``` r
ttd_many_meta |>
  dplyr::filter(col_type == "numeric") |>
  dplyr::count(clean_title, dataset, col_type, name = "num_cols") |>
  dplyr::arrange(desc(num_cols))
#> # A tibble: 12 × 4
#>    clean_title   dataset                   col_type num_cols
#>    <chr>         <chr>                     <chr>       <int>
#>  1 lego_database inventory_parts.csv.gz    numeric         3
#>  2 lego_database sets.csv.gz               numeric         3
#>  3 lego_database elements.csv.gz           numeric         2
#>  4 lego_database inventories.csv.gz        numeric         2
#>  5 lego_database inventory_minifigs.csv.gz numeric         2
#>  6 lego_database inventory_sets.csv.gz     numeric         2
#>  7 lego_database themes.csv.gz             numeric         2
#>  8 lego_database colors.csv.gz             numeric         1
#>  9 lego_database minifigs.csv.gz           numeric         1
#> 10 lego_database part_categories.csv.gz    numeric         1
#> 11 lego_database part_relationships.csv.gz numeric         1
#> 12 lego_database parts.csv.gz              numeric         1
```
