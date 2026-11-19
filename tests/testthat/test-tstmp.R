test_that("tstmp returns a formatted timestamp string", {
  ts <- tstmp()
  expect_type(ts, "character")
  expect_length(ts, 1L)
  expect_match(ts, "^\\d{4}-\\d{2}-\\d{2}-\\d{2}\\.\\d{2}\\.\\d{2}$")
})
