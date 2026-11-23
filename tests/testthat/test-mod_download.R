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

test_that("mod_download_ui offers a file choice and only csv and parquet", {
  ui <- as.character(mod_download_ui("download"))
  expect_match(ui, 'id="download-file"', fixed = TRUE)
  expect_match(ui, "All files", fixed = TRUE)
  expect_match(ui, 'value="csv"', fixed = TRUE)
  expect_match(ui, 'value="parquet"', fixed = TRUE)
  expect_no_match(ui, "original", fixed = TRUE)
  expect_match(ui, 'id="download-download"', fixed = TRUE)
})

test_that("mod_download_server downloads one file from several", {
  dat <- reactiveVal(list(a.csv = data.frame(x = 1), b.csv = data.frame(y = 2:3)))
  ttl <- reactiveVal("Test Dataset")
  testServer(mod_download_server, args = list(data = dat, title = ttl), {
    session$setInputs(format = "csv", file = "b.csv")
    path <- output$download
    expect_equal(basename(path), "b.csv")
    expect_equal(utils::read.csv(path)$y, 2:3)
  })
})

test_that("mod_download_server downloads one parquet file from several", {
  skip_if_not_installed("nanoparquet")
  dat <- reactiveVal(list(a.csv = data.frame(x = 1), b.csv = data.frame(y = 2:3)))
  ttl <- reactiveVal("Test Dataset")
  testServer(mod_download_server, args = list(data = dat, title = ttl), {
    session$setInputs(format = "parquet", file = "a.csv")
    path <- output$download
    expect_equal(basename(path), "a.parquet")
    expect_equal(nanoparquet::read_parquet(path)$x, 1)
  })
})

test_that("mod_download_server zips all files when 'all' is chosen", {
  dat <- reactiveVal(list(a.csv = data.frame(x = 1), b.csv = data.frame(y = 2)))
  ttl <- reactiveVal("Test Dataset")
  testServer(mod_download_server, args = list(data = dat, title = ttl), {
    session$setInputs(format = "parquet", file = "all")
    path <- output$download
    expect_equal(basename(path), "test_dataset_parquet.zip")
    expect_setequal(zip::zip_list(path)$filename, c("a.parquet", "b.parquet"))
  })
})

test_that("mod_download_server falls back to all files when the chosen file is gone", {
  dat <- reactiveVal(list(a.csv = data.frame(x = 1), b.csv = data.frame(y = 2)))
  ttl <- reactiveVal("Test Dataset")
  testServer(mod_download_server, args = list(data = dat, title = ttl), {
    session$setInputs(format = "csv", file = "old.csv")
    path <- output$download
    expect_equal(basename(path), "test_dataset_csv.zip")
  })
})
