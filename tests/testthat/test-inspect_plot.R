test_that("inspect_plot errors on invalid plot types", {
  ttd <- list(a.csv = data.frame(x = 1:3))
  expect_error(inspect_plot(ttd, plots = "bogus"), "Invalid plot type")
})

test_that("inspect_plot returns NULL invisibly for valid plots", {
  ttd <- list(a.csv = data.frame(x = 1:5, y = c(2, 4, 6, 8, 10)))
  pdf(NULL)
  on.exit(dev.off(), add = TRUE)
  expect_invisible(out <- inspect_plot(ttd, plots = "types"))
  expect_null(out)
})

test_that("inspect_plot skips imb and cat without warnings when there are no categorical columns", {
  ttd <- list(nums.csv = data.frame(x = 1:5, y = c(2, 4, 6, 8, 10)))
  pdf(NULL)
  on.exit(dev.off(), add = TRUE)
  expect_no_warning(inspect_plot(ttd, plots = "imb"))
  expect_no_warning(inspect_plot(ttd, plots = "cat"))
})
