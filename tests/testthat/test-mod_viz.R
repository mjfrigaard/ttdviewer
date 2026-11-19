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
