test_that("mod_list_server renders the data list", {
  dat <- reactiveVal(list(a.csv = data.frame(x = 1:2)))
  testServer(mod_list_server, args = list(data = dat), {
    expect_match(output$list$html, "a.csv")
  })
})
