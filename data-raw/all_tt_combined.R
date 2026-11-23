## code to prepare `all_tt_combined` dataset goes here
load("data/all_tt_data.rda")
load("data/all_tt_meta.rda")
load("data/tt_github_urls.rda")
all_tt_combined <- dplyr::left_join(
  x = all_tt_meta,
  y = all_tt_data,
  by = c("year", "week")
) |>
  dplyr::select(
    title,
    clean_title,
    dataset_name,
    year,
    week,
    date,
    variables,
    observations,
    variable_details,
    source_title,
    article_title
  ) |>
  # keep weeks with no variable metadata (e.g., 2025-04-15 penguins)
  tidyr::unnest(variable_details, keep_empty = TRUE)

# join on year and week only: ttmeta dates can be a day off from the
# tt_data_type.csv dates (e.g., 2018-04-03 vs 2018-04-02)
all_tt_combined <- dplyr::left_join(
  x = all_tt_combined,
  y = dplyr::select(tt_github_urls, -date),
  by = c("year", "week"),
  relationship = "many-to-many"
)

usethis::use_data(all_tt_combined, overwrite = TRUE)
