test_that("app_ui returns a bslib page with all module ids", {
  ui <- app_ui()
  expect_s3_class(ui, "shiny.tag.list")
  html <- as.character(ui)
  for (id in c("input-ds_title", "rep_form-format", "rep_dwnld-download_report",
               "listviewerlite-list", "table-table", "viz-plots")) {
    expect_match(html, id, fixed = TRUE)
  }
})
