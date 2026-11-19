test_that("app_ui returns a bslib page with all module ids", {
  ui <- app_ui()
  expect_s3_class(ui, "shiny.tag.list")
  html <- as.character(ui)
  for (id in c("input-ds_title", "download-format", "download-download", "summary-vars",
               "listviewerlite-list", "summary-table", "viz-plots")) {
    expect_match(html, id, fixed = TRUE)
  }
})

test_that("app_ui turns on busy indicators (spinners)", {
  html <- as.character(app_ui())
  expect_match(html, "busy", ignore.case = TRUE)
})

test_that("app_ui has a Summary tab and a data download, not a report", {
  html <- as.character(app_ui())
  expect_match(html, "Summary")
  expect_match(html, "download-download")
  expect_no_match(html, "rep_dwnld")
})

test_that("app_ui has no separate Table tab", {
  html <- as.character(app_ui())
  expect_no_match(html, "table-table", fixed = TRUE)
  expect_no_match(html, ">Table<", fixed = TRUE)
})
