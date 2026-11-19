test_that("launch(mode = 'run') returns a shiny app object", {
  app <- launch(mode = "run")
  expect_s3_class(app, "shiny.appobj")
})

test_that("launch() rejects unknown modes", {
  expect_error(launch(mode = "bogus"))
})

test_that("display_type() does nothing outside an interactive session", {
  skip_if(interactive())
  old <- getOption("shiny.launch.browser")
  expect_invisible(display_type("b"))
  expect_identical(getOption("shiny.launch.browser"), old)
})
