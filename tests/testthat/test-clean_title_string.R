test_that("clean_title_string returns fallback for invalid input", {
  expect_equal(clean_title_string(NULL), "unknown_title")
  expect_equal(clean_title_string(123), "unknown_title")
  expect_equal(clean_title_string(character(0)), "unknown_title")
})

test_that("clean_title_string converts punctuation to snake_case", {
  expect_equal(
    clean_title_string("Bring your own data from 2024!"),
    "bring_your_own_data_from_2024"
  )
  expect_equal(
    clean_title_string("Donuts, Data, and D'oh - A Deep Dive into The Simpsons"),
    "donuts_data_and_doh_a_deep_dive_into_the_simpsons"
  )
  expect_equal(clean_title_string("Moore’s Law"), "moores_law")
})

test_that("clean_title_string prefixes titles that start with a digit", {
  expect_match(clean_title_string("2024 Olympics"), "^dataset_2024")
})

test_that("clean_title_string output has no leading, trailing, or doubled underscores", {
  out <- clean_title_string("  U.S. Wind Turbines (2018-2022)  ")
  expect_false(grepl("^_|_$|__", out))
})

test_that("extract_dataset_title handles invalid and empty input", {
  expect_equal(extract_dataset_title(NULL), "unknown_dataset")
  expect_equal(extract_dataset_title(""), "empty_dataset")
})

test_that("extract_dataset_title matches clean_title_string", {
  ttl <- "U.S. Wind Turbines (2018-2022)"
  expect_equal(extract_dataset_title(ttl), clean_title_string(ttl))
})
