test_that("app_ui serves the React client with shinyreact", {
  ui <- app_ui()
  head <- htmltools::renderTags(ui)$head
  expect_match(head, "shinyreact-config", fixed = TRUE)
  deps <- htmltools::findDependencies(ui)
  dep_names <- vapply(deps, `[[`, character(1), "name")
  expect_true("shinyreact" %in% dep_names)
  client <- deps[[which(vapply(deps, function(d) "ui.js" %in% unlist(d$script), logical(1)))]]
  expect_true(file.exists(file.path(client$src$file, "ui.js")))
  expect_true(file.exists(file.path(client$src$file, "ui.css")))
})

test_that("app_ui loads Bootstrap 5 for the client's classes", {
  deps <- htmltools::findDependencies(app_ui())
  bs <- Filter(function(d) d$name == "bootstrap", deps)
  expect_length(bs, 1)
  expect_match(bs[[1]]$version, "^5")
})

test_that("app_ui turns on busy indicators (spinners)", {
  html <- as.character(app_ui())
  expect_match(html, "busy", ignore.case = TRUE)
})
