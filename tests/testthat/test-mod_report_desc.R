test_that("mod_report_desc_server warns when quarto is unavailable", {
  local_mocked_bindings(quarto_available = function() FALSE)
  fmt <- reactiveVal("quarto")
  testServer(mod_report_desc_server, args = list(format = fmt), {
    expect_false(desc_inputs()$quarto_status$available)
    expect_equal(desc_inputs()$alert_class, "alert-warning")
  })
})

test_that("mod_report_desc_server describes rmarkdown", {
  fmt <- reactiveVal("rmarkdown")
  testServer(mod_report_desc_server, args = list(format = fmt), {
    expect_equal(desc_inputs()$description$title, "R Markdown")
    expect_equal(desc_inputs()$alert_class, "alert-light")
  })
})
