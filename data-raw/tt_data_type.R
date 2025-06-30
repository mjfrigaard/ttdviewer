## code to prepare `tt_data_type` dataset goes here
# download.file("https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/static/tt_data_type.csv", destfile = "data-raw/tt_data_type.csv")
library(dplyr)
library(glue)
tt_data_type <- vroom::vroom("https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/static/tt_data_type.csv", delim = ",")
usethis::use_data(tt_data_type, overwrite = TRUE)
