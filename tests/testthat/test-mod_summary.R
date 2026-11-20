test_that("mod_summary_server shows the overview and tables for the selected file", {
  dat <- reactiveVal(list(
    a.csv = data.frame(x = 1:3, y = c("p", NA, "q")),
    b.csv = data.frame(z = 1)
  ))
  testServer(mod_summary_server, args = list(data = dat), {
    session$setInputs(ds_input = "a.csv")
    ov <- output$overview
    expect_length(ov$files, 2)
    expect_equal(ov$files[[1]], list(name = "a.csv", rows = 3L, cols = 2L))
    expect_equal(output$choices, c("a.csv", "b.csv"))
    expect_match(output$stats, "Complete rows")
    expect_match(output$vars, "\"y\"")
  })
})

test_that("mod_summary_server clears when data is purged", {
  dat <- reactiveVal(list(a.csv = data.frame(x = 1:3)))
  testServer(mod_summary_server, args = list(data = dat), {
    session$setInputs(ds_input = "a.csv")
    dat(NULL)
    session$flushReact()
    expect_null(output$overview)
    expect_null(output$choices)
    expect_match(output$vars, '"x":null', fixed = TRUE)
  })
})

test_that("mod_summary_server shows the selected file's data in a reactable", {
  dat <- reactiveVal(list(
    a.csv = data.frame(x = 1:2, y = c("first_value", "second_value")),
    b.csv = data.frame(z = "other_file")
  ))
  testServer(mod_summary_server, args = list(data = dat), {
    session$setInputs(ds_input = "a.csv")
    expect_match(output$table, "second_value")
    session$setInputs(ds_input = "b.csv")
    expect_match(output$table, "other_file")
  })
})

test_that("mod_summary_server shows only the first 1000 rows", {
  dat <- reactiveVal(list(big.csv = data.frame(n = 1:1500)))
  testServer(mod_summary_server, args = list(data = dat), {
    session$setInputs(ds_input = "big.csv")
    expect_match(output$table, "1000")
    expect_no_match(output$table, "1001")
  })
})

test_that("mod_summary_server clears the data table when data is purged", {
  dat <- reactiveVal(list(a.csv = data.frame(x = 1:3)))
  testServer(mod_summary_server, args = list(data = dat), {
    session$setInputs(ds_input = "a.csv")
    dat(NULL)
    session$flushReact()
    expect_match(output$table, '"x":null', fixed = TRUE)
  })
})

test_that("mod_summary_server shows the TidyTuesday date", {
  a <- data.frame(x = 1)
  attr(a, "date") <- as.Date("2024-08-06")
  dat <- reactiveVal(list(a.csv = a))
  testServer(mod_summary_server, args = list(data = dat), {
    session$setInputs(ds_input = "a.csv")
    expect_equal(output$overview$dates, "2024-08-06")
  })
})
