test_that("mod_report_input_server returns the selected format", {
  testServer(mod_report_input_server, {
    session$setInputs(format = "quarto")
    expect_equal(session$returned(), "quarto")
    session$setInputs(format = "rmarkdown")
    expect_equal(session$returned(), "rmarkdown")
  })
})

test_that("mod_report_input_ui defaults to rmarkdown", {
  ui <- as.character(mod_report_input_ui("rep"))
  expect_match(ui, "rep-format")
  expect_match(ui, "value=\"rmarkdown\" selected")
})
