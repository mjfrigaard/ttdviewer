# App

``` r

library(dplyr)
library(tidyr)
library(inspectdf)
library(ttdviewer)
```

## App structure

The call tree below is built with
[`stackcallr`](https://mjfrigaard.github.io/stackcallr/).
`call_tree_dir()` parses the files in `R/` without running them, and
`modules_only = TRUE` keeps only the functions that call `NS()` or
`moduleServer()`:

``` r
stackcallr::call_tree_dir("../R", root = "launch", modules_only = TRUE)
█─launch
├─mod_input_ui
├─mod_download_ui
├─mod_summary_ui
├─mod_plot_ui
├─mod_list_ui
├─mod_input_server
├─mod_download_server
├─mod_summary_server
├─mod_list_server
└─mod_plot_server
```

### Variable inputs

The dataset title input (`input$ds_title`) is collected in the
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
returns a list with two reactives: the dataset list (`data`) and the
title (`ds_title`).

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
  choices = plot_labels(),
  selected = c("types","mem","na")
)
```

[`plot_labels()`](https://mjfrigaard.github.io/ttdviewer/reference/plot_labels.md)
maps readable names to the plot codes
[`inspect_plot()`](https://mjfrigaard.github.io/ttdviewer/reference/inspect_plot.md)
expects; the same names are used for the plot headings:

| Label                 | Code      |
|-----------------------|-----------|
| Column types          | `"types"` |
| Memory usage          | `"mem"`   |
| Missing values        | `"na"`    |
| Correlations          | `"cor"`   |
| Most common values    | `"imb"`   |
| Numeric distributions | `"num"`   |
| Categorical levels    | `"cat"`   |

The checkbox group lets users select multiple plot types simultaneously.
The default selection includes three fundamental plots: column types,
memory usage, and missing values analysis.

``` r

uiOutput(ns("plots_ui"))
```

This `uiOutput()` holds the plots. The server fills it based on the
user’s selections.

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

The server function accepts reactive or static data. Reactive data comes
from the input module; static data is wrapped in `reactive()`, so the
module works either way. The observer extracts dataset names from the
reactive data (`ttd_r()`), and provides fallback logic if names are
missing (by using indices).

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

#### Populating the dataset selector

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

#### Reactive or static data

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

## Summary

The Summary tab
([`mod_summary_ui()`](https://mjfrigaard.github.io/ttdviewer/reference/mod_summary_ui.md)
and
[`mod_summary_server()`](https://mjfrigaard.github.io/ttdviewer/reference/mod_summary_server.md))
lists each file with its rows and columns. For the file picked in its
dropdown, it shows three `reactable` tables:

- Summary statistics: rows, columns, missing values, complete rows, and
  data types, from
  [`tt_file_summary()`](https://mjfrigaard.github.io/ttdviewer/reference/tt_file_summary.md).
- Variable information: one row per column with its type, missing count,
  missing percent, and unique values, from
  [`tt_var_info()`](https://mjfrigaard.github.io/ttdviewer/reference/tt_var_info.md).
  Missing percents over 10 are shaded yellow; over 50, red.
- Data: the file itself in a searchable, sortable, paged table. Only the
  first 1,000 rows are shown to keep the browser responsive; the sidebar
  download has the full file.

## Download

The sidebar download
([`mod_download_ui()`](https://mjfrigaard.github.io/ttdviewer/reference/mod_download_ui.md)
and
[`mod_download_server()`](https://mjfrigaard.github.io/ttdviewer/reference/mod_download_server.md))
saves the loaded data. The first dropdown picks “All files” or one file
from the title (the server fills it with `names(data())` each time a
title loads); the second picks the format:

| Format | What is written |
|----|----|
| CSV | each data frame written with [`vroom::vroom_write()`](https://vroom.tidyverse.org/reference/vroom_write.html) |
| Parquet | each data frame written with [`nanoparquet::write_parquet()`](https://nanoparquet.r-lib.org/reference/write_parquet.html) |

One file downloads under its own name with the format’s extension (for
example, `sets.parquet`). “All files” from a title with several files
downloads one `.zip` named after the title and format (for example,
`lego_database_csv.zip`). The internal helpers
[`tt_download_filename()`](https://mjfrigaard.github.io/ttdviewer/reference/tt_download_filename.md)
and
[`write_tt_download()`](https://mjfrigaard.github.io/ttdviewer/reference/write_tt_download.md)
pick the name and write the file:

``` r

ttd <- load_tt_data("Space Launches")
ttdviewer:::tt_download_filename(ttd, "parquet", "Space Launches")
ttdviewer:::write_tt_download(ttd, "parquet", file = "space_launches_parquet.zip")
```
