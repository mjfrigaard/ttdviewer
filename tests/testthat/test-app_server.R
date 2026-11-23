test_that("app_server dev output renders while data is still NULL", {
  local_mocked_bindings(load_tt_data = function(title) list(a.csv = data.frame(x = 1)))
  testServer(app_server, {
    expect_no_error(output$dev)
  })
})
