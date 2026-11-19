df_fixture <- function() {
  tibble::tibble(
    num = c(1, NA, 3, 4),
    chr = c("a", "a", NA, "b")
  )
}

test_that("tt_file_summary() reports rows, columns, missing, complete rows and types", {
  s <- tt_file_summary(df_fixture())
  expect_named(s, c("metric", "value"))
  expect_equal(
    s$value[match(c("Rows", "Columns", "Missing values", "Complete rows"), s$metric)],
    c("4", "2", "2", "2")
  )
  expect_match(s$value[s$metric == "Data types"], "numeric")
  expect_match(s$value[s$metric == "Data types"], "character")
})

test_that("tt_var_info() returns one row per variable", {
  v <- tt_var_info(df_fixture())
  expect_named(v, c("variable", "type", "missing", "missing_pct", "unique"))
  expect_equal(v$variable, c("num", "chr"))
  expect_equal(v$type, c("numeric", "character"))
  expect_equal(v$missing, c(1L, 1L))
  expect_equal(v$missing_pct, c(25, 25))
  expect_equal(v$unique, c(4L, 3L))
})
