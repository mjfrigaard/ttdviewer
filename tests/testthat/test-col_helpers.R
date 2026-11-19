ttd_fixture <- function() {
  list(
    a.csv = data.frame(
      n1 = 1:3, n2 = c(1.5, 2.5, 3.5), chr = c("x", "y", "z"),
      lgl = c(TRUE, FALSE, NA), dt = as.Date("2024-01-01") + 0:2
    ),
    b.csv = data.frame(n1 = 4:6, chr = c("p", "q", "r"))
  )
}

test_that("check_col_types finds columns of each type", {
  ttd <- ttd_fixture()
  expect_equal(check_col_types(ttd, "num"), list(a.csv = c("n1", "n2"), b.csv = "n1"))
  expect_equal(check_col_types(ttd, "cat"), list(a.csv = "chr", b.csv = "chr"))
  expect_equal(check_col_types(ttd, "log"), list(a.csv = "lgl", b.csv = character(0)))
  expect_equal(check_col_types(ttd, "date"), list(a.csv = "dt", b.csv = character(0)))
})

test_that("check_col_types rejects unknown types", {
  expect_error(check_col_types(ttd_fixture(), "bogus"))
})

test_that("has_min_cols compares column counts", {
  num <- check_col_types(ttd_fixture(), "num")
  expect_true(has_min_cols(num, 1, min_count = 2))
  expect_false(has_min_cols(num, 2, min_count = 2))
  expect_false(has_min_cols(num, 5))
})

test_that("get_intersecting_cols only works on exactly two datasets", {
  ttd <- ttd_fixture()
  expect_equal(get_intersecting_cols(ttd), c("n1", "chr"))
  expect_equal(get_intersecting_cols(ttd[1]), character(0))
})

test_that("ttd_length counts only data frames", {
  ttd <- c(ttd_fixture(), list(junk = "not a df"))
  expect_equal(ttd_length(ttd), 2L)
})

test_that("extract_file_names returns names and validates input", {
  expect_equal(extract_file_names(ttd_fixture()), c("a.csv", "b.csv"))
  expect_error(extract_file_names("x"), "must be a list")
  expect_error(extract_file_names(list(1, 2)), "named")
})

test_that("get_tt_title_meta returns one row per column type per dataset", {
  ttd <- ttd_fixture()
  attr(ttd$a.csv, "clean_title") <- "fixture"
  meta <- get_tt_title_meta(ttd)
  expect_named(meta, c("clean_title", "dataset", "col", "col_type"))
  expect_setequal(unique(meta$dataset), c("a.csv", "b.csv"))
  expect_equal(unique(meta$clean_title[meta$dataset == "a.csv"]), "fixture")
  expect_true(all(is.na(meta$clean_title[meta$dataset == "b.csv"])))
})

test_that("get_tt_title_meta errors on bad input", {
  expect_error(get_tt_title_meta("x"), "must be a list")
  expect_error(get_tt_title_meta(list(1)), "No data frames")
})
