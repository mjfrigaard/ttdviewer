test_that("mod_table_server renders a reactable for the selected dataset", {
  dat <- reactiveVal(list(a.csv = data.frame(x = 1:2), b.csv = data.frame(y = 3:4)))
  testServer(mod_table_server, args = list(data = dat), {
    session$setInputs(ds_input = "b.csv")
    expect_match(output$table, "\"y\"")
  })
})

test_that("mod_table_ui contains the dataset selector and table output", {
  ui <- as.character(mod_table_ui("tbl"))
  expect_match(ui, "tbl-ds_input")
  expect_match(ui, "tbl-table")
})
