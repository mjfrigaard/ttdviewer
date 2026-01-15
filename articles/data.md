# Data

``` r
library(ttdviewer)
library(dplyr)
library(tidyr)
library(ttmeta)
```

This document covers the `#TidyTuesday` data used in the application.

## TidyTuesday R packages

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

#### .files

The `.tt`

``` r
attr(tt_data, ".tt") |> 
  attr(".files")
#>         data_files data_type delim
#> 43     answers.csv       csv     ,
#> 44 color_ranks.csv       csv     ,
#> 45       users.csv       csv     ,
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

``` r
tt_meta <- get_tt_tbl(min_year = 2025L, max_year = this_year())
```

``` r
str(tt_meta)
#> tt_tbl [55 × 8] (S3: tt_tbl/tbl_df/tbl/data.frame)
#>  $ year         : int [1:55] 2025 2025 2025 2025 2025 2025 2025 2025 2025 2025 ...
#>  $ week         : int [1:55] 1 2 3 4 5 6 7 8 9 10 ...
#>  $ date         : Date[1:55], format: "2025-01-07" "2025-01-14" ...
#>  $ title        : chr [1:55] "Bring your own data from 2024!" "posit::conf talks" "The History of Himalayan Mountaineering Expeditions" "Water Insecurity" ...
#>  $ source_title : chr [1:55] "NA" "posit::conf attendee portal 2023, posit::conf attendee portal 2024" "The Himalayan Database" "US Census Data from tidycensus" ...
#>  $ source_urls  :List of 55
#>   ..$ : chr(0) 
#>   ..$ : chr [1:2] "https://reg.conf.posit.co/flow/posit/positconf23/attendee-portal/page/sessioncatalog" "https://reg.conf.posit.co/flow/posit/positconf24/attendee-portal/page/sessioncatalog"
#>   ..$ : chr "https://www.himalayandatabase.com/downloads.html"
#>   ..$ : chr "https://cran.r-project.org/package=tidycensus"
#>   ..$ : chr "https://www.kaggle.com/datasets/prashant111/the-simpsons-dataset"
#>   ..$ : chr "https://archive.org/details/20250128-cdc-datasets"
#>   ..$ : chr "https://cde.ucr.cjis.gov/LATEST/webapp/#/pages/docApi"
#>   ..$ : chr "https://www.ajog.org/article/S0002-9378(24)00775-0/fulltext"
#>   ..$ : chr "https://data.longbeach.gov/explore/dataset/animal-shelter-intakes-and-outcomes/information/"
#>   ..$ : chr "https://erictleung.com/pixarfilms/index.html"
#>   ..$ : chr "https://github.com/EmilHvitfeldt/palmtrees"
#>   ..$ : chr "https://ir.aboutamazon.com/annual-reports-proxies-and-shareholder-letters/default.aspx"
#>   ..$ : chr "https://github.com/williamorim/pokemon/"
#>   ..$ : chr "https://data.cms.gov/provider-data/dataset/apyc-v239"
#>   ..$ : chr "https://www.r-project.org/"
#>   ..$ : chr "https://osf.io/qnrg6/"
#>   ..$ : chr "https://user2025.r-project.org/"
#>   ..$ : chr "https://grant-watch.us/nsf-data.html"
#>   ..$ : chr "https://www.ingv.it/"
#>   ..$ : chr [1:2] "https://www.beachwatch.nsw.gov.au/waterMonitoring/waterQualityData" "https://open-meteo.com/"
#>   ..$ : chr "https://www.dndbeyond.com/srd"
#>   ..$ : chr "https://docs.ropensci.org/gutenbergr/"
#>   ..$ : chr "https://github.com/ropensci/historydata"
#>   ..$ : chr "https://apis.guru"
#>   ..$ : chr "https://immunizationdata.who.int/global?topic=Provisional-measles-and-rubella-data&location="
#>   ..$ : chr "https://www.eia.gov/dnav/pet/xls/PET_PRI_GND_DCUS_NUS_W.xls"
#>   ..$ : chr "https://xkcd.com/color/colorsurvey.tar.gz"
#>   ..$ : chr "https://docs.google.com/spreadsheets/d/1uxjiuWYZrALF2mthmiYbUPieu1dEdEwv9GB8dEAizso/edit?gid=0#gid=0"
#>   ..$ : chr "https://data.ny.gov/Transportation/MTA-Permanent-Art-Catalog-Beginning-1980/4y8j-9pkd/about_data"
#>   ..$ : chr [1:4] "https://assets.ctfassets.net/4cd45et68cgf/inuAnzotdsAEgbInGLzH5/1be323ba419b2af3a96bffa29acc31a3/What_We_Watche"| __truncated__ "https://assets.ctfassets.net/4cd45et68cgf/2PoZlfdc46dH2gQvI8eUzI/9db5840720c47acfcf7b89ffe2402860/What_We_Watch"| __truncated__ "https://assets.ctfassets.net/4cd45et68cgf/6XSmoEjBjVMPRtYybT9d1E/8c0b0b2645b8712d5597b0bdbe0d64e2/What_We_Watch"| __truncated__ "https://assets.ctfassets.net/4cd45et68cgf/mplcXj5ulHDfbCPCr0f0I/5dbb6ec09f03df89706476e380e9b8bd/What_We_Watche"| __truncated__
#>   ..$ : chr "https://ourworldindata.org"
#>   ..$ : chr "https://carbonbrief.org"
#>   ..$ : chr "https://www.hills-database.co.uk/downloads.html"
#>   ..$ : chr "https://docs.google.com/spreadsheets/d/1j1AUgtMnjpFTz54UdXgCKZ1i4bNxFjf01ImJ-BqBEt0/edit?gid=1974823090#gid=1974823090"
#>   ..$ : chr "https://www.frogid.net.au/explore"
#>   ..$ : chr "https://api.henleypassportindex.com/api/v3/countries"
#>   ..$ : chr "https://cran.r-project.org/package=tastyR"
#>   ..$ : chr "https://ratings.fide.com/download_lists.phtml"
#>   ..$ : chr "https://www.hornborga.com/naturen/transtatistik/"
#>   ..$ : chr "https://github.com/natanast/EuroleagueBasketball"
#>   ..$ : chr "https://www.fao.org/faostat/en/#data/FS"
#>   ..$ : chr "https://www.data.gov.uk/dataset/17ba3bbe-0e98-4a8c-9937-bd1d50fdc3c5/historic-monthly-meteorological-station-data"
#>   ..$ : chr "https://data.post45.org/posts/british-literary-prizes/"
#>   ..$ : chr "https://onlinelibrary.wiley.com/doi/pdf/10.1111/test.12187?casa_token=av3lP7OmqS0AAAAA:QAF3yU5kGzsUkqi1VlXkMlIN"| __truncated__
#>   ..$ : chr "https://github.com/seabbs/getTBinR/"
#>   ..$ : chr "https://github.com/EmilHvitfeldt/sherlock"
#>   ..$ : chr "https://datacatalog.worldbank.org/search/dataset/0037996/Statistical-Performance-Indicators"
#>   ..$ : chr "https://github.com/philshem/Sechselaeuten-data"
#>   ..$ : chr "https://profmusgrave.github.io/qatarcars/"
#>   ..$ : chr "https://github.com/EmilHvitfeldt/roundabouts"
#>   ..$ : chr "https://github.com/glottolog/glottolog-cldf/tree/master/cldf"
#>   ..$ : chr "https://www.gutenberg.org/"
#>   ..$ : chr(0) 
#>   ..$ : chr "https://en.wikipedia.org/wiki/Languages_of_Africa"
#>   ..$ : chr "https://api.nasa.gov/"
#>  $ article_title: chr [1:55] "NA" "posit::conf(2025) in-person registration is now open!" "The Expedition Archives of Elizabeth Hawley" "Mapping water insecurity in R with tidycensus" ...
#>  $ article_urls :List of 55
#>   ..$ : chr(0) 
#>   ..$ : chr "https://posit.co/blog/positconf2025-in-person-registration-is-now-open/"
#>   ..$ : chr "https://www.himalayandatabase.com/index.html"
#>   ..$ : chr "https://waterdata.usgs.gov/blog/acs-maps/"
#>   ..$ : chr "https://toddwschneider.com/posts/the-simpsons-by-the-data/"
#>   ..$ : chr "https://www.npr.org/sections/shots-health-news/2025/01/31/nx-s1-5282274/trump-administration-purges-health-websites"
#>   ..$ : chr "https://le.fbi.gov/cjis-division/cjis-link/uniform-crime-reporting-program-still-vital-after-90-years-"
#>   ..$ : chr "https://katcorr.github.io/this-art-is-HARD/"
#>   ..$ : chr "https://www.longbeach.gov/press-releases/long-beach-animal-care-services-hits-highest-adoption-rate-ever-surpas"| __truncated__
#>   ..$ : chr "https://erictleung.com/pixarfilms/articles/pixar_film_ratings.html"
#>   ..$ : chr "https://www.nature.com/articles/s41597-019-0189-0"
#>   ..$ : chr "https://gregoryvdvinne.github.io/Text-Mining-Amazon-Budgets.html"
#>   ..$ : chr "https://medium.com/@hanahshih46/pokemon-data-visualization-and-analysis-with-r-60970c8e37f4"
#>   ..$ : chr "https://www.visualcapitalist.com/mapped-emergency-room-visit-times-by-state/"
#>   ..$ : chr "https://zenodo.org/records/14902740"
#>   ..$ : chr "https://osf.io/preprints/osf/tzcsy_v1"
#>   ..$ : chr "https://user2025.r-project.org/"
#>   ..$ : chr "https://www.nytimes.com/2025/04/22/science/trump-national-science-foundation-grants.html"
#>   ..$ : chr "https://www.ingv.it/somma-vesuvio"
#>   ..$ : chr "https://www.abc.net.au/news/2025-01-10/pollution-risks-in-sydney-beaches-contaminated-waterways-rain/104790856"
#>   ..$ : chr "https://www.dndbeyond.com/posts/1949-you-can-now-publish-your-own-creations-using-the"
#>   ..$ : chr "https://www.gutenberg.org/about/background/50years.html"
#>   ..$ : chr "https://ropensci.org/blog/2023/02/07/what-does-it-mean-to-maintain-a-package/"
#>   ..$ : chr "https://dslc-io.github.io/club-wapir/slides/intro.html"
#>   ..$ : chr "https://abcnews.go.com/Health/measles-cases-reach-1046-us-infections-confirmed-30/story?id=122108194"
#>   ..$ : chr "https://www.eia.gov/petroleum/gasdiesel/"
#>   ..$ : chr "https://blog.xkcd.com/2010/05/03/color-survey-results/"
#>   ..$ : chr "https://anjackson.net/2024/11/29/british-library-funding-breakdown-trends/#income-streams"
#>   ..$ : chr "https://www.mta.info/agency/arts-design/permanent-art"
#>   ..$ : chr "https://about.netflix.com/en/news/what-we-watched-the-first-half-of-2025"
#>   ..$ : chr "https://ourworldindata.org/income-inequality-before-and-after-taxes"
#>   ..$ : chr "https://interactive.carbonbrief.org/attribution-studies/index.html"
#>   ..$ : chr "https://www.hills-database.co.uk/TMS_heighting_accuracy.pdf"
#>   ..$ : chr "https://substack.com/home/post/p-170266824"
#>   ..$ : chr "https://australian.museum/blog/amri-news/frogid-dataset-6/"
#>   ..$ : chr "https://edition.cnn.com/2025/07/22/travel/world-most-powerful-passports-july-2025"
#>   ..$ : chr "https://www.brians.works/i-scraped-14k-recipes-so-you-wont-have-to/"
#>   ..$ : chr "https://www.fide.com/fide-september-2025-rating-list-vincent-keymer-debuts-in-top-10-open/"
#>   ..$ : chr "https://www.datawrapper.de/blog/the-dancing-cranes-of-lake-hornborga"
#>   ..$ : chr "https://en.wikipedia.org/wiki/EuroLeague"
#>   ..$ : chr "https://en.wikipedia.org/wiki/World_Food_Day"
#>   ..$ : chr "https://www.metoffice.gov.uk/research/climate/maps-and-data/historic-station-data"
#>   ..$ : chr "https://theconversation.com/why-we-still-need-a-womens-prize-for-fiction-257494"
#>   ..$ : chr "https://academic.oup.com/jrssig/article/14/2/16/7029247"
#>   ..$ : chr "https://samabbott.co.uk/getTBinR/index.html"
#>   ..$ : chr "https://sherlock-holm.es/ascii/"
#>   ..$ : chr "https://worldbank.github.io/SPI/measuring-the-statistical-performance-of-countries-an-overview-of-the-statistic"| __truncated__
#>   ..$ : chr "https://www.meteoswiss.admin.ch/weather/weather-and-climate-from-a-to-z/boeoegg-prediction.html"
#>   ..$ : chr "https://musgrave.substack.com/p/introducing-the-qatar-cars-dataset"
#>   ..$ : chr "https://www.kittelson.com/ideas/how-many-roundabouts-are-in-the-united-states/"
#>   ..$ : chr "https://glottolog.org/"
#>   ..$ : chr "https://github.com/ropensci/gutenbergr/issues/95"
#>   ..$ : chr(0) 
#>   ..$ : chr "https://en.wikipedia.org/wiki/Languages_of_Africa"
#>   ..$ : chr "https://apod.nasa.gov/apod/astropix.html"
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
#> Rows: 810 Columns: 6
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr  (3): data_files, data_type, delim
#> dbl  (2): Week, year
#> date (1): Date
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
dplyr::glimpse(tt_github_urls)
#> Rows: 810
#> Columns: 7
#> $ week       <dbl> 3, 2, 52, 52, 52, 51, 51, 51, 50, 49, 48, 47, 46, 45, 44, 4…
#> $ date       <date> 2026-01-20, 2026-01-13, 2025-12-30, 2025-12-30, 2025-12-30…
#> $ year       <dbl> 2026, 2026, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025,…
#> $ data_files <chr> "apod.csv", "africa.csv", "christmas_novel_authors.csv", "c…
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
#> Rows: 378
#> Columns: 9
#> $ year          <int> 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 20…
#> $ week          <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 1…
#> $ date          <date> 2025-01-07, 2025-01-14, 2025-01-21, 2025-01-28, 2025-02…
#> $ title         <chr> "Bring your own data from 2024!", "posit::conf talks", "…
#> $ clean_title   <chr> "bring_your_own_data_from_2024", "posit_conf_talks", "th…
#> $ source_title  <chr> "NA", "posit::conf attendee portal 2023, posit::conf att…
#> $ source_urls   <list> <>, <"https://reg.conf.posit.co/flow/posit/positconf23/…
#> $ article_title <chr> "NA", "posit::conf(2025) in-person registration is now o…
#> $ article_urls  <list> <>, "https://posit.co/blog/positconf2025-in-person-regi…
```

### All TidyTuesday Meta

The `all_tt_meta.rda` dataset contains all years (2018 - current) from
the `ttmeta::load_tt_datasets_metadata()`. This dataset the following
columns:

``` r
dplyr::glimpse(all_tt_meta)
#> Rows: 765
#> Columns: 6
#> $ year             <int> 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025,…
#> $ week             <int> 1, 2, 2, 3, 3, 4, 4, 5, 5, 5, 5, 6, 6, 6, 7, 8, 8, 9,…
#> $ dataset_name     <chr> NA, "conf2023", "conf2024", "exped_tidy", "peaks_tidy…
#> $ variables        <int> NA, 9, 5, 69, 29, 7, 7, 4, 14, 3, 13, 27, 6, 6, 10, 6…
#> $ observations     <int> NA, 116, 106, 882, 480, 848, 854, 6722, 151, 4459, 31…
#> $ variable_details <list> <NULL>, [<tbl_df[9 x 6]>], [<tbl_df[5 x 6]>], [<tbl_…
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
#> Rows: 24,450
#> Columns: 20
#> $ title         <chr> "posit::conf talks", "posit::conf talks", "posit::conf t…
#> $ clean_title   <chr> "posit_conf_talks", "posit_conf_talks", "posit_conf_talk…
#> $ dataset_name  <chr> "conf2023", "conf2023", "conf2023", "conf2023", "conf202…
#> $ year          <dbl> 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 2025, 20…
#> $ week          <dbl> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,…
#> $ date          <date> 2025-01-14, 2025-01-14, 2025-01-14, 2025-01-14, 2025-01…
#> $ variables     <int> 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 5,…
#> $ observations  <int> 116, 116, 116, 116, 116, 116, 116, 116, 116, 116, 116, 1…
#> $ variable      <chr> "speaker_name", "speaker_name", "speaker_affiliation", "…
#> $ class         <chr> "character", "character", "character", "character", "cha…
#> $ n_unique      <int> 115, 115, 81, 81, 3, 3, 110, 110, 28, 28, 2, 2, 39, 39, …
#> $ min           <list> "Aaron Chafetz", "Aaron Chafetz", "A Plus Associates, P…
#> $ max           <list> "Wyl Schuth", "Wyl Schuth", "Washington State Departmen…
#> $ description   <chr> "The name of the speaker. The data is indexed by this fi…
#> $ source_title  <chr> "posit::conf attendee portal 2023, posit::conf attendee …
#> $ article_title <chr> "posit::conf(2025) in-person registration is now open!",…
#> $ data_files    <chr> "conf2023.csv", "conf2024.csv", "conf2023.csv", "conf202…
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
#> INFO [2026-01-15 19:33:41] Starting import for netflix_titles.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2021/2021-04-20/netflix_titles.csv
#> SUCCESS [2026-01-15 19:33:41] Successfully loaded netflix_titles.csv
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
#> INFO [2026-01-15 19:33:42] Starting import for agencies.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-01-15/agencies.csv
#> SUCCESS [2026-01-15 19:33:42] Successfully loaded agencies.csv
#> INFO [2026-01-15 19:33:42] Starting import for launches.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-01-15/launches.csv
#> SUCCESS [2026-01-15 19:33:42] Successfully loaded launches.csv
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
#> INFO [2026-01-15 19:33:42] Starting import for cpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/cpu.csv
#> SUCCESS [2026-01-15 19:33:42] Successfully loaded cpu.csv
#> INFO [2026-01-15 19:33:42] Starting import for gpu.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/gpu.csv
#> SUCCESS [2026-01-15 19:33:42] Successfully loaded gpu.csv
#> INFO [2026-01-15 19:33:42] Starting import for ram.csv from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2019/2019-09-03/ram.csv
#> SUCCESS [2026-01-15 19:33:42] Successfully loaded ram.csv
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
#> INFO [2026-01-15 19:33:42] Starting import for colors.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/colors.csv.gz
#> SUCCESS [2026-01-15 19:33:43] Successfully loaded colors.csv.gz
#> INFO [2026-01-15 19:33:43] Starting import for elements.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/elements.csv.gz
#> SUCCESS [2026-01-15 19:33:43] Successfully loaded elements.csv.gz
#> INFO [2026-01-15 19:33:43] Starting import for inventories.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/inventories.csv.gz
#> SUCCESS [2026-01-15 19:33:43] Successfully loaded inventories.csv.gz
#> INFO [2026-01-15 19:33:43] Starting import for inventory_minifigs.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/inventory_minifigs.csv.gz
#> SUCCESS [2026-01-15 19:33:43] Successfully loaded inventory_minifigs.csv.gz
#> INFO [2026-01-15 19:33:43] Starting import for inventory_parts.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/inventory_parts.csv.gz
#> SUCCESS [2026-01-15 19:33:44] Successfully loaded inventory_parts.csv.gz
#> INFO [2026-01-15 19:33:44] Starting import for inventory_sets.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/inventory_sets.csv.gz
#> SUCCESS [2026-01-15 19:33:44] Successfully loaded inventory_sets.csv.gz
#> INFO [2026-01-15 19:33:44] Starting import for minifigs.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/minifigs.csv.gz
#> SUCCESS [2026-01-15 19:33:44] Successfully loaded minifigs.csv.gz
#> INFO [2026-01-15 19:33:44] Starting import for part_categories.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/part_categories.csv.gz
#> SUCCESS [2026-01-15 19:33:44] Successfully loaded part_categories.csv.gz
#> INFO [2026-01-15 19:33:44] Starting import for part_relationships.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/part_relationships.csv.gz
#> SUCCESS [2026-01-15 19:33:44] Successfully loaded part_relationships.csv.gz
#> INFO [2026-01-15 19:33:44] Starting import for parts.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/parts.csv.gz
#> SUCCESS [2026-01-15 19:33:45] Successfully loaded parts.csv.gz
#> INFO [2026-01-15 19:33:45] Starting import for sets.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/sets.csv.gz
#> SUCCESS [2026-01-15 19:33:45] Successfully loaded sets.csv.gz
#> INFO [2026-01-15 19:33:45] Starting import for themes.csv.gz from https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2022/2022-09-06/themes.csv.gz
#> SUCCESS [2026-01-15 19:33:45] Successfully loaded themes.csv.gz
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
#> INFO [2026-01-15 19:33:45] Datasets in list: netflix_titles.csv
#> INFO [2026-01-15 19:33:45] Created metadata tibble with 14 rows covering 1 datasets
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
#> INFO [2026-01-15 19:33:45] Datasets in list: agencies.csv, launches.csv
#> INFO [2026-01-15 19:33:45] Created metadata tibble with 33 rows covering 2 datasets
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
#> INFO [2026-01-15 19:33:45] Datasets in list: cpu.csv, gpu.csv, ram.csv
#> INFO [2026-01-15 19:33:45] Created metadata tibble with 30 rows covering 3 datasets
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
#> INFO [2026-01-15 19:33:45] Datasets in list: colors.csv.gz, elements.csv.gz, inventories.csv.gz, inventory_minifigs.csv.gz, inventory_parts.csv.gz, inventory_sets.csv.gz, minifigs.csv.gz, part_categories.csv.gz, part_relationships.csv.gz, parts.csv.gz, sets.csv.gz, themes.csv.gz
#> INFO [2026-01-15 19:33:45] Created metadata tibble with 67 rows covering 12 datasets
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
