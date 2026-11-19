# tests/testthat/test-load_tt_data.R

# ── Shared fixture ────────────────────────────────────────────────────────────

# Small data frame returned by all mocked loaders
.fake_df <- tibble::tibble(x = 1:3, label = c("a", "b", "c"))

# Build a minimal all_tt_combined row for one or more files
make_tt_fixture <- function(data_files, data_type,
                            github_url = paste0("https://example.com/", data_files)) {
  tibble::tibble(
    title       = "Test Dataset",
    clean_title = "test_dataset",
    data_files  = data_files,
    data_type   = data_type,
    github_url  = github_url
  )
}

# Inject fixture into .GlobalEnv; defer() cleans up when the test exits
setup_tt_env <- function(tbl) {
  assign("all_tt_combined", tbl, envir = .GlobalEnv)
  withr::defer(
    suppressWarnings(rm("all_tt_combined", envir = .GlobalEnv)),
    envir = parent.frame()
  )
}

# ── Input validation ──────────────────────────────────────────────────────────

test_that("errors for an unknown title", {
  setup_tt_env(make_tt_fixture("file.csv", "csv"))
  expect_error(load_tt_data("No Such Title"), "No entries found")
})

# ── CSV ───────────────────────────────────────────────────────────────────────

test_that("loads CSV files via vroom with comma delimiter", {
  setup_tt_env(make_tt_fixture("data.csv", "csv"))

  local_mocked_bindings(
    vroom = function(file, delim, ...) {
      expect_equal(delim, ",")
      .fake_df
    },
    .package = "vroom"
  )

  result <- load_tt_data("Test Dataset")

  expect_type(result, "list")
  expect_named(result, "data.csv")
  expect_s3_class(result[["data.csv"]], "data.frame")
  expect_equal(nrow(result[["data.csv"]]), 3L)
})

# ── CSV.GZ ────────────────────────────────────────────────────────────────────

test_that("loads CSV.GZ files (data_type 'vgz') via vroom with comma delimiter", {
  # In all_tt_combined, csv.gz files carry data_type = "vgz".
  # load_tt_data() detects the .csv.gz extension and routes them to vroom.
  setup_tt_env(make_tt_fixture("data.csv.gz", "vgz"))

  local_mocked_bindings(
    vroom = function(file, delim, ...) {
      expect_equal(delim, ",")
      .fake_df
    },
    .package = "vroom"
  )

  result <- load_tt_data("Test Dataset")

  expect_named(result, "data.csv.gz")
  expect_s3_class(result[["data.csv.gz"]], "data.frame")
})

# ── TSV ───────────────────────────────────────────────────────────────────────

test_that("loads TSV files via vroom with tab delimiter", {
  setup_tt_env(make_tt_fixture("data.tsv", "tsv"))

  local_mocked_bindings(
    vroom = function(file, delim, ...) {
      expect_equal(delim, "\t")
      .fake_df
    },
    .package = "vroom"
  )

  result <- load_tt_data("Test Dataset")

  expect_named(result, "data.tsv")
  expect_s3_class(result[["data.tsv"]], "data.frame")
})

# ── XLSX ──────────────────────────────────────────────────────────────────────

test_that("loads XLSX files by delegating to .load_xlsx()", {
  setup_tt_env(make_tt_fixture("data.xlsx", "xlsx"))

  local_mocked_bindings(.load_xlsx = function(url) .fake_df)

  result <- load_tt_data("Test Dataset")

  expect_named(result, "data.xlsx")
  expect_s3_class(result[["data.xlsx"]], "data.frame")
})

test_that(".load_xlsx() downloads to a temp .xlsx path then passes it to read_excel", {
  downloaded_to <- NULL
  read_from     <- NULL

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      downloaded_to <<- destfile
      invisible(0L)
    },
    .package = "utils"
  )
  local_mocked_bindings(
    read_excel = function(path, ...) {
      read_from <<- path
      .fake_df
    },
    .package = "readxl"
  )

  result <- .load_xlsx("https://example.com/data.xlsx")

  expect_s3_class(result, "data.frame")
  expect_equal(downloaded_to, read_from)
  expect_match(downloaded_to, "\\.xlsx$")
})

# ── RDS ───────────────────────────────────────────────────────────────────────

test_that("loads RDS files by delegating to .load_rds()", {
  setup_tt_env(make_tt_fixture("data.rds", "rds"))

  local_mocked_bindings(.load_rds = function(url) .fake_df)

  result <- load_tt_data("Test Dataset")

  expect_named(result, "data.rds")
  expect_s3_class(result[["data.rds"]], "data.frame")
})

test_that(".load_rds() opens a URL connection and passes it to readRDS", {
  url_opened <- NULL

  local_mocked_bindings(
    url     = function(description, ...) { url_opened <<- description; textConnection(character(0L)) },
    readRDS = function(con, ...) .fake_df,
    .package = "base"
  )

  result <- .load_rds("https://example.com/data.rds")

  expect_s3_class(result, "data.frame")
  expect_equal(url_opened, "https://example.com/data.rds")
})

# ── Skipped / unsupported types ───────────────────────────────────────────────

test_that("skips files whose effective type resolves to 'vgz'", {
  # A file whose extension doesn't match any known pattern falls back to data_type
  setup_tt_env(make_tt_fixture("data.vgz", "vgz"))
  result <- load_tt_data("Test Dataset")
  expect_length(result, 0L)
})

# ── ZIP ───────────────────────────────────────────────────────────────────────

test_that("loads ZIP files by delegating to .load_zip()", {
  setup_tt_env(make_tt_fixture("data.zip", "zip"))

  local_mocked_bindings(.load_zip = function(url) .fake_df)

  result <- load_tt_data("Test Dataset")

  expect_named(result, "data.zip")
  expect_s3_class(result[["data.zip"]], "data.frame")
})

test_that(".load_zip() reads every CSV inside the archive into one data frame", {
  src <- withr::local_tempdir()
  utils::write.csv(.fake_df, file.path(src, "a.csv"), row.names = FALSE)
  utils::write.csv(.fake_df, file.path(src, "b.csv"), row.names = FALSE)
  zip_path <- withr::local_tempfile(fileext = ".zip")
  withr::with_dir(src, utils::zip(zip_path, c("a.csv", "b.csv"), flags = "-q"))

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      file.copy(zip_path, destfile, overwrite = TRUE)
      invisible(0L)
    },
    .package = "utils"
  )

  result <- .load_zip("https://example.com/data.zip")

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 6L)
  expect_named(result, c("x", "label"))
})

test_that(".load_zip() errors when the archive holds no CSV or TSV files", {
  src <- withr::local_tempdir()
  writeLines("hello", file.path(src, "notes.txt"))
  zip_path <- withr::local_tempfile(fileext = ".zip")
  withr::with_dir(src, utils::zip(zip_path, "notes.txt", flags = "-q"))

  local_mocked_bindings(
    download.file = function(url, destfile, ...) {
      file.copy(zip_path, destfile, overwrite = TRUE)
      invisible(0L)
    },
    .package = "utils"
  )

  expect_error(.load_zip("https://example.com/data.zip"), "No CSV or TSV")
})

test_that("filters out NA data_files before attempting to load", {
  setup_tt_env(make_tt_fixture(NA_character_, "csv"))
  result <- load_tt_data("Test Dataset")
  expect_length(result, 0L)
})

# ── Return-value contracts ────────────────────────────────────────────────────

test_that("list names match the data_files values", {
  setup_tt_env(make_tt_fixture("report.csv", "csv"))
  local_mocked_bindings(vroom = function(...) .fake_df, .package = "vroom")

  result <- load_tt_data("Test Dataset")

  expect_named(result, "report.csv")
})

test_that("each element carries a clean_title attribute from all_tt_combined", {
  setup_tt_env(make_tt_fixture("data.csv", "csv"))
  local_mocked_bindings(vroom = function(...) .fake_df, .package = "vroom")

  result <- load_tt_data("Test Dataset")

  expect_equal(attr(result[["data.csv"]], "clean_title"), "test_dataset")
})

test_that("returns one data frame per file for multi-file datasets", {
  setup_tt_env(make_tt_fixture(c("a.csv", "b.csv"), "csv"))
  local_mocked_bindings(vroom = function(...) .fake_df, .package = "vroom")

  result <- load_tt_data("Test Dataset")

  expect_length(result, 2L)
  expect_named(result, c("a.csv", "b.csv"))
})

# ── Error handling ────────────────────────────────────────────────────────────

test_that("excludes failed files and returns the remaining successes", {
  setup_tt_env(make_tt_fixture(
    c("ok.csv", "bad.csv"), "csv",
    c("https://example.com/ok.csv", "https://example.com/bad.csv")
  ))

  local_mocked_bindings(
    vroom = function(file, ...) {
      if (grepl("bad", file)) stop("simulated network error")
      .fake_df
    },
    .package = "vroom"
  )

  result <- load_tt_data("Test Dataset")

  expect_length(result, 1L)
  expect_named(result, "ok.csv")
})

test_that("returns empty list when every file fails to load", {
  setup_tt_env(make_tt_fixture("bad.csv", "csv"))
  local_mocked_bindings(
    vroom = function(...) stop("connection refused"),
    .package = "vroom"
  )

  result <- load_tt_data("Test Dataset")

  expect_length(result, 0L)
})
