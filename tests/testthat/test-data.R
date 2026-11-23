test_that("every listed TidyTuesday file is in all_tt_combined", {
  urls <- tt_github_urls[!is.na(tt_github_urls$data_files), ]
  listed <- unique(paste(urls$year, urls$week, urls$data_files))
  have <- unique(paste(all_tt_combined$year, all_tt_combined$week, all_tt_combined$data_files))
  expect_equal(setdiff(listed, have), character(0))
})

test_that("every file in all_tt_combined has a title and a GitHub URL", {
  files <- all_tt_combined[!is.na(all_tt_combined$data_files), ]
  expect_false(anyNA(files$title))
  expect_false(anyNA(files$github_url))
})
