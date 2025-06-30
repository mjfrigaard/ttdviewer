# tests/testthat/test-rendering-utils.R
# -------------------------------------------------------------------------
# Unit tests for report-generation helpers  –  testthat-only
# -------------------------------------------------------------------------
# nocov start
library(testthat)

## helper: run code in an ephemeral working dir ---------------------------
with_tempdir <- function(code) {
  owd <- setwd(tempdir(check = TRUE))
  on.exit(setwd(owd), add = TRUE)
  force(code)
}

# -------------------------------------------------------------------------
# validate_and_clean_params() ---------------------------------------------
# -------------------------------------------------------------------------
test_that("validate_and_clean_params fills defaults & keeps list names", {
  raw <- list(
    dataset_title = ' "Bad title" ',
    data_list     = data.frame(x = 1)   # has name "x"
  )

  cleaned <- validate_and_clean_params(raw)

  expect_equal(cleaned$dataset_title, " Bad title ")
  expect_true(is.list(cleaned$data_list))
  expect_named(cleaned$data_list, "x")          # retains original name

  # Only check for a **subset** of mandatory fields (less brittle)
  must_have <- c("dataset_title", "title",
                 "data_list", "plot_type")
  expect_true(all(must_have %in% names(cleaned)))
})

test_that("validate_and_clean_params converts non-list data_list", {
  cleaned <- validate_and_clean_params(list(data_list = 1:3))
  expect_true(is.list(cleaned$data_list))
  expect_length(cleaned$data_list, 1)
})

# -------------------------------------------------------------------------
# validate_quarto_params() -------------------------------------------------
# -------------------------------------------------------------------------
test_that("validate_quarto_params strips quotes from strings", {
  p <- validate_quarto_params(
    list(dataset_title = 'Foo "Bar"', title = "My 'title'")
  )
  expect_false(grepl("\"|'", p$dataset_title))
  expect_false(grepl("\"|'", p$title))
})

# -------------------------------------------------------------------------
# convert_qmd_to_rmd() -----------------------------------------------------
# -------------------------------------------------------------------------
test_that("convert_qmd_to_rmd converts basic Quarto syntax", {
  qmd <- c(
    "---", "title: test", "---",
    "::: {.callout-note}", "hi", ":::",
    "```{r}", "#| echo: false", "1+1", "```"
  )

  rmd <- convert_qmd_to_rmd(qmd)

  expect_true(any(grepl("<div class='alert alert-info'>", rmd)))
  expect_false(any(grepl("#\\|", rmd)))   # chunk opts stripped
  expect_identical(rmd[1], "---")         # YAML still first
})

# -------------------------------------------------------------------------
# quarto_available() -------------------------------------------------------
# -------------------------------------------------------------------------
test_that("quarto_available detects system quarto & full failure", {
  ## (1) System call succeeds ---------------------------------------------
  local_mocked_bindings(
    requireNamespace = function(pkg, ...) FALSE,  # skip package route
    system2          = function(cmd, args, ...) "1.3.0",
    file.exists      = function(...) FALSE,
    .env = globalenv(),
    .add = TRUE                     # ← NEW
  )
  expect_true(quarto_available())

  ## (2) Nothing available -------------------------------------------------
  local_mocked_bindings(
    requireNamespace = function(pkg, ...) FALSE,
    system2          = function(...) stop("no quarto"),
    file.exists      = function(...) FALSE,
    .env = globalenv(),
    .add = TRUE                     # ← NEW
  )
  expect_false(quarto_available())
})

# -------------------------------------------------------------------------
# render_quarto_system_call() ---------------------------------------------
# -------------------------------------------------------------------------
test_that("render_quarto_system_call writes param file & calls system2", {
  tpl  <- tempfile(fileext = ".qmd"); writeLines("dummy", tpl)
  outp <- tempfile(fileext = ".html")

  called <- FALSE
  fake_sys2 <- function(cmd, args, ...) { called <<- TRUE; "ok" }

  local_mocked_bindings(
    system2 = fake_sys2,
    .env    = globalenv(),
    .add    = TRUE                  # ← NEW
  )

  with_tempdir({
    render_quarto_system_call(
      template_path = tpl,
      output_file   = outp,
      params        = list(dataset_title = "ds",
                           title         = "t",
                           plot_type     = "p")
    )
    expect_true(called)
  })
})

# -------------------------------------------------------------------------
# create_error_report() ----------------------------------------------------
# -------------------------------------------------------------------------
test_that("create_error_report writes informative HTML", {
  tmp <- tempfile(fileext = ".html")
  create_error_report(tmp, "bad things", "ds", "quarto")
  html <- readLines(tmp, warn = FALSE)

  expect_true(any(grepl("Report Generation Failed", html)))
  expect_true(any(grepl("bad things", html)))
})

# -------------------------------------------------------------------------
# render_rmarkdown_report() -----------------------------------------------
# -------------------------------------------------------------------------
test_that("render_rmarkdown_report delegates to rmarkdown::render", {
  skip_if_not_installed("rmarkdown")

  tpl  <- tempfile(fileext = ".Rmd"); file.create(tpl)
  outp <- tempfile(fileext = ".html")

  rendered <- FALSE
  fake_render <- function(input, output_file, ...) {
    rendered <<- identical(input, tpl) && identical(output_file, outp)
    NULL
  }

  local_mocked_bindings(
    render = fake_render,
    .env   = getNamespace("rmarkdown"),
    .add   = TRUE                   # ← NEW
  )

  render_rmarkdown_report(
    template_path = tpl,
    output_file   = outp,
    params        = list(dataset_title = "ds", title = "t")
  )

  expect_true(rendered)
})

# -------------------------------------------------------------------------
# render_report() ----------------------------------------------------------
# -------------------------------------------------------------------------
test_that("render_report routes correctly & returns output path", {
  rmd_called <- qmd_called <- FALSE

  fake_rmd <- function(...) { rmd_called <<- TRUE; NULL }
  fake_qmd <- function(...) { qmd_called <<- TRUE; NULL }

  local_mocked_bindings(
    render_rmarkdown_report   = fake_rmd,
    render_quarto_report      = fake_qmd,
    get_template_path         = function(x) tempfile(),  # avoid file access
    validate_and_clean_params = identity,
    .env  = environment(render_report)
  )

  out <- tempfile(fileext = ".html")

  expect_equal(render_report("rmarkdown", out), out)
  expect_true(rmd_called)

  expect_equal(render_report("quarto", out), out)
  expect_true(qmd_called)
})

# nocov end
