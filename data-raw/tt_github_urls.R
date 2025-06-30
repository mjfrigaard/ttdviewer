## code to prepare `tt_github_urls` dataset goes here
library(dplyr)
library(glue)
tt_github_urls <- vroom::vroom("https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/static/tt_data_type.csv", delim = ",") |>
  dplyr::mutate(
    github_url = glue::glue(
      "https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/{year}/{Date}/{data_files}"
    )
  ) |>
  dplyr::rename(
    week = Week,
    date = Date
  )
usethis::use_data(tt_github_urls, overwrite = TRUE)
