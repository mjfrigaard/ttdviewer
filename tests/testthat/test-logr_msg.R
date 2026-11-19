test_that("logr_msg accepts every level without error", {
  for (lvl in c("FATAL", "ERROR", "WARN", "SUCCESS", "INFO", "DEBUG", "TRACE", "OTHER")) {
    expect_no_error(suppressMessages(logr_msg("test message", level = lvl)))
  }
})

test_that("logr_msg creates the log file and its directory", {
  log_file <- file.path(tempfile(), "logs", "app.log")
  on.exit({
    logger::log_appender(logger::appender_console)
    logger::log_layout(logger::layout_simple)
  }, add = TRUE)
  suppressMessages(logr_msg("first", log_file = log_file))
  expect_true(file.exists(log_file))
})

test_that("logr_msg writes plain text lines, not JSON", {
  log_file <- file.path(tempfile(), "app.log")
  on.exit({
    logger::log_appender(logger::appender_console)
    logger::log_layout(logger::layout_simple)
  }, add = TRUE)
  suppressMessages(logr_msg("plain message", level = "WARN", log_file = log_file))
  lines <- readLines(log_file)
  expect_true(any(grepl("WARN", lines) & grepl("plain message", lines)))
  expect_false(any(grepl("^\\{", lines)))
})

test_that("logr_msg no longer has a json argument", {
  expect_false("json" %in% names(formals(logr_msg)))
})
