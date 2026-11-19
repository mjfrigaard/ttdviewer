test_that("mod_input_server loads data for the selected title", {
  fake <- list(a.csv = data.frame(x = 1:3))
  local_mocked_bindings(load_tt_data = function(title) fake)
  testServer(mod_input_server, {
    session$setInputs(ds_title = "Space Launches")
    expect_equal(session$returned$data(), fake)
    expect_equal(session$returned$ds_title(), "Space Launches")
    expect_match(output$vals, "Downloaded a.csv data.")
  })
})

test_that("mod_input_server returns an empty list when loading fails", {
  local_mocked_bindings(load_tt_data = function(title) stop("boom"))
  testServer(mod_input_server, {
    session$setInputs(ds_title = "Space Launches")
    expect_equal(session$returned$data(), list())
  })
})

test_that("mod_input_ui lists dataset titles", {
  ui <- as.character(mod_input_ui("input"))
  expect_match(ui, "input-ds_title")
  expect_match(ui, "Space Launches")
})
