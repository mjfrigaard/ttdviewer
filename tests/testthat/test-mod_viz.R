test_that("mod_plot_server returns the selected dataset and plots", {
  ttd <- list(a.csv = data.frame(x = 1:3), b.csv = data.frame(y = 4:6))
  testServer(mod_plot_server, args = list(ttd = ttd), {
    session$setInputs(dataset = "b.csv", plots = c("types", "na"))
    expect_equal(session$returned(), list(dataset = "b.csv", plots = c("types", "na")))
  })
})

test_that("mod_plot_server sends the file names to the client", {
  ttd <- reactiveVal(list(a.csv = data.frame(x = 1:3), b.csv = data.frame(y = 4:6)))
  testServer(mod_plot_server, args = list(ttd = ttd), {
    expect_equal(output$datasets, c("a.csv", "b.csv"))
  })
})

test_that("mod_plot_server renders only the selected plot types", {
  ttd <- reactiveVal(list(a.csv = data.frame(x = 1:3, y = c("a", "b", "c"))))
  testServer(mod_plot_server, args = list(ttd = ttd), {
    session$setInputs(dataset = "a.csv", plots = "types")
    expect_match(output$plt_types$src, "^data:image/png")
    expect_error(output$plt_mem)
  })
})

test_that("mod_plot_server clears when data is purged", {
  ttd <- reactiveVal(list(a.csv = data.frame(x = 1:3)))
  testServer(mod_plot_server, args = list(ttd = ttd), {
    session$setInputs(dataset = "a.csv", plots = "types")
    ttd(NULL)
    session$flushReact()
    expect_null(output$datasets)
    expect_error(output$plt_types)
  })
})
