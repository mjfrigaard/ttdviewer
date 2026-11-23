ttd_one <- function() {
  df <- tibble::tibble(x = 1:3, y = c("a", "b", "c"))
  attr(df, "clean_title") <- "test_dataset"
  attr(df, "github_url") <- "https://example.com/data.tsv"
  list(data.tsv = df)
}

ttd_two <- function() {
  a <- tibble::tibble(x = 1:2)
  b <- tibble::tibble(y = c("p", "q"))
  attr(a, "github_url") <- "https://example.com/a.csv.gz"
  attr(b, "github_url") <- "https://example.com/b.xlsx"
  list(a.csv.gz = a, b.xlsx = b)
}

test_that("tt_file_stem() strips data file extensions", {
  expect_equal(
    tt_file_stem(c("a.csv", "b.csv.gz", "c.tsv", "d.xlsx", "e.rds", "f.zip")),
    c("a", "b", "c", "d", "e", "f")
  )
})

test_that("tt_download_filename() names a single file by format", {
  expect_equal(tt_download_filename(ttd_one(), "csv", "Test Dataset"), "data.csv")
  expect_equal(tt_download_filename(ttd_one(), "parquet", "Test Dataset"), "data.parquet")
})

test_that("tt_download_filename() uses a zip named after the title for several files", {
  expect_equal(tt_download_filename(ttd_two(), "csv", "Test Dataset"), "test_dataset_csv.zip")
  expect_equal(tt_download_filename(ttd_two(), "parquet", "Test Dataset"), "test_dataset_parquet.zip")
})

test_that("write_tt_download() writes one CSV that reads back", {
  out <- withr::local_tempfile(fileext = ".csv")
  write_tt_download(ttd_one(), "csv", out)
  back <- utils::read.csv(out)
  expect_equal(back$x, 1:3)
  expect_equal(back$y, c("a", "b", "c"))
})

test_that("write_tt_download() writes one parquet file that reads back", {
  skip_if_not_installed("nanoparquet")
  out <- withr::local_tempfile(fileext = ".parquet")
  write_tt_download(ttd_one(), "parquet", out)
  back <- nanoparquet::read_parquet(out)
  expect_equal(back$x, 1:3)
})

test_that("write_tt_download() zips several files with format extensions", {
  out <- withr::local_tempfile(fileext = ".zip")
  write_tt_download(ttd_two(), "csv", out)
  expect_setequal(zip::zip_list(out)$filename, c("a.csv", "b.csv"))
})

test_that("write_tt_download() rejects an unknown format", {
  out <- withr::local_tempfile()
  expect_error(write_tt_download(ttd_one(), "json", out))
})

test_that("downloads only offer csv and parquet", {
  out <- withr::local_tempfile()
  expect_error(write_tt_download(ttd_one(), "original", out))
  expect_error(tt_download_filename(ttd_one(), "original", "Test Dataset"))
})

test_that("write_tt_download() zips several parquet files", {
  skip_if_not_installed("nanoparquet")
  out <- withr::local_tempfile(fileext = ".zip")
  write_tt_download(ttd_two(), "parquet", out)
  expect_setequal(zip::zip_list(out)$filename, c("a.parquet", "b.parquet"))
})
