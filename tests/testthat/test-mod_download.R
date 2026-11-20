test_that("mod_download_server downloads a single CSV", {
  dat <- reactiveVal(list(data.csv = data.frame(x = 1:2)))
  ttl <- reactiveVal("Test Dataset")
  testServer(mod_download_server, args = list(data = dat, title = ttl), {
    session$setInputs(format = "csv")
    path <- output$download
    expect_equal(basename(path), "data.csv")
    expect_equal(utils::read.csv(path)$x, 1:2)
  })
})

test_that("mod_download_server zips several files", {
  dat <- reactiveVal(list(a.csv = data.frame(x = 1), b.csv = data.frame(y = 2)))
  ttl <- reactiveVal("Test Dataset")
  testServer(mod_download_server, args = list(data = dat, title = ttl), {
    session$setInputs(format = "csv")
    path <- output$download
    expect_equal(basename(path), "test_dataset_csv.zip")
    expect_setequal(zip::zip_list(path)$filename, c("a.csv", "b.csv"))
  })
})
