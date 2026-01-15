# App

``` r
library(dplyr)
library(tidyr)
library(inspectdf)
library(lobstr)
library(ttdviewer)
```

## App structure

The application’s functions are in the abstract syntax tree below:

``` default
█─launch 
├─█─app_ui 
│ ├─█─mod_input_ui 
│ ├─█─mod_list_ui 
│ ├─█─mod_plot_ui 
│ ├─█─mod_table_ui 
│ ├─█─mod_report_input_ui 
│ ├─█─mod_report_desc_ui 
│ └─█─mod_report_download_ui 
└─█─app_server 
  ├─█─mod_input_server 
  ├─█─mod_list_server 
  ├─█─mod_plot_server 
  ├─█─mod_table_server 
  ├─█─mod_report_input_server 
  ├─█─mod_report_desc_server 
  └─█─mod_report_download_server 
```

### Variable inputs

The variable input (`input$dataset_title`) is collected in the
[`mod_input_ui()`](https://mjfrigaard.github.io/ttdviewer/reference/mod_input_ui.md)
and
[`mod_input_server()`](https://mjfrigaard.github.io/ttdviewer/reference/mod_input_server.md)
functions and passed to the
[`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)
function:

``` r
tryCatch({
    result <- load_tt_data(input$dataset_title)
    if (length(result) == 0) {
      logr_msg("Empty dataset returned", level = "WARN")
      showNotification("No data available for selected dataset",
        type = "warning", duration = 5
      )
    } else {
      logr_msg("Dataset successfully loaded in reactive",
        level = "SUCCESS"
      )
    }
    return(result)
  },
  error = function(e) {
    logr_msg(paste("Error in data reactive:", e$message),
      level = "ERROR"
    )
    showNotification(paste("Error loading data:", e$message),
      type = "error", duration = 10
    )
    return(list())
  }
)
```

[`mod_input_server()`](https://mjfrigaard.github.io/ttdviewer/reference/mod_input_server.md)
returns the dataset list and title as a reactive.

``` r
return(
    list(
      data = data,
      'ds_title' = reactive(input$ds_title)
    )
  )
```

In the
[`app_server()`](https://mjfrigaard.github.io/ttdviewer/reference/app_server.md),
the inputs are assigned to the `title_input` and separated into
`selected_data` and `dataset_title`:

``` r
# initialize modules
title_input <- mod_input_server("input")
# return the data and title
selected_data <- title_input$data
dataset_title <- title_input$ds_title
```

These reactive values are passed to the output modules.

## List

`mod_list` is a simple module that collects the list of `#TidyTuesday`
datasets from the
[`mod_input_server()`](https://mjfrigaard.github.io/ttdviewer/reference/mod_input_server.md):

### Input Controls

``` r
# collect data
mod_list_server(id = "listviewerlite", data = selected_data)
```

### List Display

The list display comes from the [`listviewerlite`
package](https://long39ng.github.io/listviewerlite/). The
[`mod_list_server()`](https://mjfrigaard.github.io/ttdviewer/reference/mod_list_server.md)
accepts the `selected_data` as
[`data()`](https://rdrr.io/r/utils/data.html)

``` r
# render data()
output$list <- renderUI({
  req(data())
  listviewerlite::listview(data())
})
```

## Table

The `mod_table` module is a Shiny module that provides interactive data
table functionality for `#TidyTuesday` datasets using [the `reactable`
package](https://glin.github.io/reactable/). This module provides users
with a powerful interface for exploring tabular data with built-in
search, sorting, and pagination capabilities.

### Input Controls

The UI function is wrapped in a
[`bslib::card()`](https://rstudio.github.io/bslib/reference/card.html):

``` r
bslib::card(
  bslib::card_body(
    selectInput(
      inputId = ns("ds_input"),
      label = "Dataset",
      choices = c(c("", NULL)),
      selected = ""
    ),
    markdown("The table display below is provided by [`reactable`](https://glin.github.io/reactable/):"),
    reactable::reactableOutput(ns("table"))
  )
)
```

The server function observes the selected
[`data()`](https://rdrr.io/r/utils/data.html) list and populates the
selector with available datasets:

``` r
observe({
  req(data())
  ds_names <- names(data())
  updateSelectInput(
    inputId = "ds_input",
    choices = ds_names, 
    selected = ds_names[1]
  )
}) |>
  bindEvent(data())
```

This observe waits for data availability with `req(data())`, extracts
dataset names from the reactive
[`data()`](https://rdrr.io/r/utils/data.html), updates the select input
with available choices, and responds to
[`data()`](https://rdrr.io/r/utils/data.html) changes via `bindEvent()`.

### Table Display

The display functionality lies in the rendering observer. This pattern
ensures the table is re-rendered whenever the underlying
[`data()`](https://rdrr.io/r/utils/data.html) changes, but not on every
reactive cycle.

``` r
observe({
  req(data())
  output$table <- reactable::renderReactable({
    # Table generation logic
  })
}) |>
  bindEvent(data())
```

Before the table is rendered, there are several data processing steps:

1.  Confirmation the data exists  
2.  The dataset input is properly selected from the
    [`data()`](https://rdrr.io/r/utils/data.html) list  
3.  The selected data is a valid data frame  
4.  Appropriate logging for debugging and monitoring

``` r
tryCatch({
  req(data())
  if (length(data()) == 0) {
    logr_msg(
      message = "No data available for table rendering", 
      level = "WARN")
    return(NULL)
  }
  
  ds_list <- data()
  ds_selected <- as.character(input$ds_input)
  display_ds <- ds_list[[ds_selected]]
  
  if (!is.data.frame(display_ds)) {
    logr_msg(
      message = "First dataset is not a data frame", 
      level = "ERROR")
    return(NULL)
  }
  # code continues...
})
```

### Large Datasets

Conditional logic handles large datasets:

``` r
display_ds <- if (nrow(display_ds) > 1000) {
  logr_msg(
    message = "Large dataset detected - limiting to first 1000 rows", 
    level = "INFO")
  head(display_ds, 1000)
} else {
  display_ds
}
```

This prevents performance issues by limiting display to 1000 rows for
large datasets and Logging the limitation for user awareness.

The module creates informative subtitles based on the data context:

``` r
subtitle <- if (length(ds_list) > 1) {
  paste("Showing:", ds_selected, "(", length(ds_list), "files total )")
} else {
  paste("File:", ds_selected)
}
```

### Table Features

The module leverages `reactable`’s extensive features for an enhanced
user experience:

``` r
reactable::reactable(
  display_ds,
  searchable = TRUE,
  sortable = TRUE,
  pagination = TRUE,
  defaultPageSize = 10,
  showPageSizeOptions = TRUE,
  pageSizeOptions = c(5, 10, 20, 50),
  highlight = TRUE,
  bordered = TRUE,
  striped = TRUE,
  resizable = TRUE,
  wrap = FALSE,
  defaultColDef = reactable::colDef(
    minWidth = 100,
    headerStyle = list(background = "#f7f7f8")
  )
)
```

This configuration provides:

1.  Search functionality across all columns  
2.  Sortable columns  
3.  Pagination (set to 10 by default)  
4.  Column resizing  
5.  Row highlighting  
6.  Striped rows  
7.  Bordered cells  
8.  Custom header styling with subtle background color  
9.  Minimum column width  
10. No text wrapping to maintain clean layout  
11. Multiple page size options (5, 10, 20, 50 rows)  
12. Show page size selector for user preference  
13. Resizable columns for custom layouts

### Error Handling

The UI includes comprehensive error handling:

``` r
tryCatch({
  # UI creation code
}, error = function(e) {
  logr_msg(message = paste("Error creating table UI:", e$message), level = "ERROR")
  bslib::card(
    bslib::card_header("Table Error"),
    bslib::card_body(
      h4("Error loading table interface", class = "text-danger")
    )
  )
})
```

If UI creation fails, users see a graceful error message instead of a
broken interface.

``` r
tryCatch({
  # Table rendering logic
}, error = function(e) {
  logr_msg(
    message = paste("Error rendering table:", e$message), 
    level = "ERROR")
  reactable::reactable(
    data.frame(Error = paste("Failed to load data:", e$message)),
    searchable = FALSE,
    sortable = FALSE,
    pagination = FALSE
  )
})
```

The server error handling logs errors for debugging and returns a
functional table with error information. The interactive features are
disabled on error tables with user-friendly error messages.

`mod_table` creates a user-friendly data table interface with
comprehensive error handling. The `reactable` integration provides data
exploration while the design makes it easy to include in the
[`app_ui()`](https://mjfrigaard.github.io/ttdviewer/reference/app_ui.md)
and
[`app_server()`](https://mjfrigaard.github.io/ttdviewer/reference/app_server.md).

## Graphs

The graphs are controlled by the `mod_plot` module, which handles the
interactive data visualizations for the `#TidyTuesday` dataset list. The
module is designed with a flexible interface for exploring different
types of plots across multiple datasets with:

1.  Unique namespace IDs and reactive data handling for flexible input
    processing  
2.  Dynamic UI generation and event-driven updates for creating outputs
    based on the underlying data

### Input Controls

The UI creates two main input controls:

``` r
selectInput(
  ns("dataset"),
  "Choose dataset:",
  choices = NULL,
  selected = NULL
)
```

This dropdown allows users to select which dataset they want to
visualize. The choices are populated dynamically based on the available
datasets.

``` r
checkboxGroupInput(
  ns("plots"),
  "Select plot type:",
  choices = c(
    "types"       = "types",
    "memory"      = "mem", 
    "missing"     = "na",
    "correlation" = "cor",
    "imbalance"   = "imb",
    "numeric"     = "num",
    "categorical" = "cat"
  ),
  selected = c("types","mem","na")
)
```

The checkbox group lets users select multiple plot types simultaneously.
The default selection includes three fundamental plots: column types,
memory usage, and missing values analysis.

``` r
uiOutput(ns("plots_ui"))
```

This `uiOutput` creates a dynamic container that will hold the plot
outputs generated by the user selections and server-side logic.

``` r
ttd_r <- if (is.reactive(ttd)) {
  logr_msg(message = "ttd is reactive", level = "DEBUG")
  ttd
} else {
  logr_msg(
    message = "ttd is static; wrapping in reactive()", 
    level = "DEBUG")
  reactive(ttd)
}
```

The server function handles both reactive and static data inputs,
ensuring the module works whether it receives reactive data (from the
input module) or static data passed directly. The observer extracts
dataset names from the reactive data (`ttd_r()`), and provides fallback
logic if names are missing (by using indices).

``` r
observe({
  tryCatch({
    ds <- names(ttd_r())
    if (is.null(ds) || length(ds) == 0) {
      ds <- seq_along(ttd_r()) %>% as.character()
      logr_msg(message = "No names in ttd; using indices", level = "WARN")
    }
    updateSelectInput(
      session, "dataset",
      choices  = ds,
      selected = ds[[1]]
    )
  }, error = function(err) {
    logr_msg(
      message = sprintf("Error populating dataset selector: %s", err$message), 
      level = "ERROR")
  })
}) |>
  bindEvent(ttd_r(), once = FALSE)
```

The `selectInput()` is updated with available choices and selects the
first dataset by default. The `bindEvent(ttd_r(), once = FALSE)` ensures
this runs whenever the data changes, but not on every reactive cycle.

`renderUI` creates plot containers dynamically by validating the input
with `req()`, then mapping over the selected plot types with
[`purrr::map()`](https://purrr.tidyverse.org/reference/map.html). The
namespace function (`NS()`) creates a unique plot id, which also creates
a unique plot container with headers and specified dimensions.

``` r
output$plots_ui <- renderUI({
  tryCatch({
    req(input$dataset, input$plots)
    purrr::map(input$plots, function(plt) {
      plot_id <- ns(paste0("plt_", plt))
      tagList(
        h4(plt),
        plotOutput(plot_id, height = "300px")
      )
    })
  }, error = function(err) {
    tagList(p(style = "color:red;", "Failed to generate plot UI."))
  })
})
```

### Plot Display

The most complex part of the `mod_plot` handles the plot generation. The
observer validates the dataset selection exists in the reactive list
(`ttd_r()`), then extracts the selected dataset as a standalone data
frame (`df`).

[`purrr::walk()`](https://purrr.tidyverse.org/reference/map.html)
iterates over each selected plot type and creates individual plot
outputs with unique IDs using the
[`inspect_plot()`](https://mjfrigaard.github.io/ttdviewer/reference/inspect_plot.md)
function. `bindEvent()` limits unnecessary updates with event-driven
reactivity and responding to changes in either dataset or plot
selections.

``` r
observe({
  tryCatch({
    ds_list <- req(ttd_r())
    sel_ds  <- input$dataset
    req(sel_ds %in% names(ds_list))
    df <- ds_list[[sel_ds]]
    
    purrr::walk(input$plots, function(plt) {
      out_id <- paste0("plt_", plt)
      output[[out_id]] <- renderPlot({
        tryCatch({
          inspect_plot(
            ttd = setNames(list(df), sel_ds),
            plots = plt
          )
        }, error = function(err2) {
          plot.new()
          text(0.5, 0.5, "Error generating plot", cex = 1.2, col = "red")
        })
      })
    })
  }, error = function(err) {
    logr_msg(
      message = sprintf("Error in plot observer: %s", err$message), 
      level = "ERROR")
  })
}) |>
  bindEvent(list(input$dataset, input$plots), ignoreNULL = TRUE)
```

#### inspect_plot()

The module interfaces use the
[`inspect_plot()`](https://mjfrigaard.github.io/ttdviewer/reference/inspect_plot.md)
utility function, which uses the `inspectdf` package to generate
different types of exploratory plots:

- **“types”**: Column type distributions
- **“mem”**: Memory usage analysis  
- **“na”**: Missing value patterns
- **“cor”**: Correlation analysis
- **“imb”**: Feature imbalance for categorical data
- **“num”**: Numeric column summaries
- **“cat”**: Categorical column summaries

The
[`inspect_plot()`](https://mjfrigaard.github.io/ttdviewer/reference/inspect_plot.md)
function handles the complexity of determining appropriate
visualizations based on data characteristics and the number of datasets.

In the main app, the module is integrated as:

``` r
# In app_ui()
bslib::nav_panel("Graphs", mod_plot_ui("viz"))

# In app_server()  
title_input <- mod_input_server("input")
selected_data <- title_input$data
mod_plot_server("viz", ttd = selected_data)
```

The module receives data through the `ttd` parameter, but it can be a
reactive expression from another module *or* static data passed
directly. `selected_data` is a reactive containing `#TidyTuesday`
datasets from the `mod_input` module, providing a complete visualization
interface within the “Graphs” tab.

The input handling also makes the module highly reusable across
different contexts.

### Error Handling

The module implements comprehensive error handling at multiple levels.
Input validation is handled using `req()` to avoid processing invalid
states. [`tryCatch()`](https://rdrr.io/r/base/conditions.html) is used
for graceful degradation with fallback UI elements. The
[`logr_msg()`](https://mjfrigaard.github.io/ttdviewer/reference/logr_msg.md)
function prints plot-level error handling at different severity levels
with visual placeholders and user-friendly error messages.

## Reports

### Input Controls

### Button Display

### Error Handling
