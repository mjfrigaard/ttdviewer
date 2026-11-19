test_that("mod_input_server loads data for the selected title", {
  fake <- list(a.csv = data.frame(x = 1:3))
  local_mocked_bindings(load_tt_data = function(title) fake)
  testServer(mod_input_server, {
    session$setInputs(ds_title = "Space Launches")
    session$flushReact()
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

test_that("mod_input_server purges old data before loading a new title", {
  local_mocked_bindings(
    load_tt_data = function(title) {
      if (title == "First") list(a.csv = data.frame(x = 1)) else list(b.csv = data.frame(y = 2))
    }
  )
  testServer(mod_input_server, {
    seen <- character(0)
    observe({
      d <- session$returned$data()
      seen <<- c(seen, if (is.null(d)) "NULL" else names(d))
    })
    session$setInputs(ds_title = "First")
    session$flushReact()
    session$setInputs(ds_title = "Second")
    session$flushReact()
    expect_equal(tail(seen, 3), c("a.csv", "NULL", "b.csv"))
    expect_equal(names(session$returned$data()), "b.csv")
  })
})
