test_that("mod_plot_server returns the selected dataset and plots", {
  ttd <- list(a.csv = data.frame(x = 1:3), b.csv = data.frame(y = 4:6))
  testServer(mod_plot_server, args = list(ttd = ttd), {
    session$setInputs(dataset = "b.csv", plots = c("types", "na"))
    expect_equal(session$returned(), list(dataset = "b.csv", plots = c("types", "na")))
  })
})

test_that("mod_plot_server builds one plot output per selected type", {
  ttd <- reactiveVal(list(a.csv = data.frame(x = 1:3)))
  testServer(mod_plot_server, args = list(ttd = ttd), {
    session$setInputs(dataset = "a.csv", plots = c("types", "mem"))
    html <- output$plots_ui$html
    expect_match(html, "plt_types")
    expect_match(html, "plt_mem")
  })
})

test_that("mod_plot_server removes plots when data is purged", {
  ttd <- reactiveVal(list(a.csv = data.frame(x = 1:3)))
  testServer(mod_plot_server, args = list(ttd = ttd), {
    session$setInputs(dataset = "a.csv", plots = "types")
    expect_match(output$plots_ui$html, "plt_types")
    ttd(NULL)
    session$flushReact()
    expect_error(output$plots_ui)
  })
})

test_that("plot_labels() maps every plot code to a readable name", {
  labs <- plot_labels()
  expect_setequal(unname(labs), c("types", "mem", "na", "cor", "imb", "num", "cat"))
  expect_false(any(names(labs) == unname(labs)))
})

test_that("mod_plot_ui checkboxes show readable names", {
  ui <- as.character(mod_plot_ui("viz"))
  expect_match(ui, "Column types")
  expect_match(ui, "Memory usage")
  expect_match(ui, "Missing values")
})

test_that("plot headings use readable names, not codes", {
  ttd <- reactiveVal(list(a.csv = data.frame(x = 1:3)))
  testServer(mod_plot_server, args = list(ttd = ttd), {
    session$setInputs(dataset = "a.csv", plots = c("types", "mem", "na"))
    html <- output$plots_ui$html
    expect_match(html, "<h4>Column types</h4>", fixed = TRUE)
    expect_match(html, "<h4>Memory usage</h4>", fixed = TRUE)
    expect_match(html, "<h4>Missing values</h4>", fixed = TRUE)
    expect_no_match(html, "<h4>types</h4>", fixed = TRUE)
  })
})

test_that("mod_plot_server logs no error while data is purged", {
  levels <- character(0)
  local_mocked_bindings(
    logr_msg = function(message, level = "INFO", ...) levels <<- c(levels, level)
  )
  ttd <- reactiveVal(list(a.csv = data.frame(x = 1:3)))
  testServer(mod_plot_server, args = list(ttd = ttd), {
    session$setInputs(dataset = "a.csv", plots = "types")
    ttd(NULL)
    session$flushReact()
  })
  expect_false("ERROR" %in% levels)
})
