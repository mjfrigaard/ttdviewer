test_that("get_template_path finds bundled templates", {
  rmd <- get_template_path("rmarkdown")
  qmd <- get_template_path("quarto")
  expect_true(file.exists(rmd))
  expect_true(file.exists(qmd))
  expect_match(rmd, "report_template\\.Rmd$")
  expect_match(qmd, "report_template\\.qmd$")
})
