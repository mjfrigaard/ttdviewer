# Reports

``` r

library(dplyr)
library(tidyr)
library(inspectdf)
library(ttdviewer)
```

Three modules build the downloadable reports in the \#TidyTuesday data
viewer. Together they let users download a Quarto or R Markdown report.
The modules include options for format selection, Quarto system
capability detection, and reliable file generation with comprehensive
error handling.

## Module Architecture

The report generation system consists of three main components:

1.  **`mod_report_input`**: Format selection interface  
2.  **`mod_report_desc`**: Dynamic format description and system
    status  
3.  **`mod_report_download`**: Report generation and download
    functionality

The call tree below comes from
[`stackcallr::call_tree_dir()`](https://mjfrigaard.github.io/stackcallr/reference/call_tree_dir.html),
which parses `R/` without running it. The three `mod_report_*` modules
sit beside the list, table, and plot modules:

``` r
stackcallr::call_tree_dir("../R", root = "launch", modules_only = TRUE)
█─launch
├─mod_input_ui
├─mod_report_input_ui
├─mod_report_desc_ui
├─mod_report_download_ui
├─mod_list_ui
├─mod_table_ui
├─mod_plot_ui
├─mod_input_server
├─mod_report_input_server
├─mod_report_desc_server
├─mod_list_server
├─mod_table_server
├─mod_plot_server
└─mod_report_download_server
```

These three modules work together to handle multiple rendering formats,
detect if quarto is installed on the system, and handle errors
gracefully.

## The Format Selector

The `mod_report_input` handles the format selection input from the user.

### UI

The input module provides a `selectInput()` interface for the two
available format selections: `"R Markdown" = "rmarkdown"` and
`"Quarto" = "quarto"`.

``` r

selectInput(
  inputId = ns("format"),
  label = strong("Download Report:"),
  choices = list(
    "R Markdown" = "rmarkdown",
    "Quarto" = "quarto"
  ),
  selected = "rmarkdown",
  width = "100%"
)
```

The input includes bold, user-friendly labels to emphasize
functionality. The default selected input (R Markdown) maximizes
compatibility.

### Server

The server demonstrates a simple, clean reactive pattern:

``` r

mod_report_input_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    return(
      reactive(
        list("format" = input$format)
      )
    )
  })
}
```

The server returns `input$format` as a reactive (instead of storing it
in internal state). Debugging support is provided with comprehensive
logging.

## The Description Generator

The description server calls
[`quarto_available()`](https://mjfrigaard.github.io/ttdviewer/reference/quarto_available.md)
(and
[`logr_msg()`](https://mjfrigaard.github.io/ttdviewer/reference/logr_msg.md)
for logging):

``` r
stackcallr::call_tree_dir("../R", root = "mod_report_desc_server")
█─mod_report_desc_server
├─logr_msg
└─█─quarto_available
  └─logr_msg
```

### UI

The description module uses complete dynamic UI generation:

``` r

mod_report_desc_ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(outputId = ns("desc"))
  )
}
```

The UI function is minimal, which delegates most of the content
generation to the server. This gives us dynamic control over
presentation.

### Server

The server function contains logic for quarto system detection and
adaptive messaging.

``` r

desc_inputs <- reactive({
  req(format())
  # System capability detection
  # Format-specific descriptions  
  # Alert styling logic
  return(list(
    "quarto_status" = quarto_status,
    "description" = description,
    "alert_class" = alert_class
  ))
})
```

The reactive expression orchestrates multiple outputs:

1.  Checks the system capability detection through
    [`quarto_available()`](https://mjfrigaard.github.io/ttdviewer/reference/quarto_available.md)  
2.  Format-specific messaging based on selection  
3.  Visual styling based on system state

After `quarto_status` is determined by the
[`quarto_available()`](https://mjfrigaard.github.io/ttdviewer/reference/quarto_available.md)
function, the value is stored as `available` with a `message`:

``` r

quarto_status <- if (format()$format == "quarto") {
  if (quarto_available()) {
    list(
      available = TRUE,
      message = "Quarto is available and ready to use."
    )
  } else {
    list(
      available = FALSE,
      message = "Quarto not detected. Will fall back to R Markdown if selected."
    )
  }
} else {
  list(available = TRUE, message = "Quarto is available and ready to use.")
}
```

The conditional checking behavior identifies when Quarto is selected and
provides graceful fallback messaging when it’s unavailable on the
system.

#### Format descriptions

The `description` returns information for `rmarkdown` and `quarto` with
bootstrap `icon` for visual identification, `title`, informative
`desc`riptions to guide user choice, and context-aware `note` that
reflect system state.

``` r

description <- switch(format()$format,
  "rmarkdown" = list(
    icon = "bi-file-earmark-code",
    title = "R Markdown",
    desc = "Traditional R Markdown report. Compatible with all R installations.",
    note = "Recommended for maximum compatibility."
  ),
  "quarto" = list(
    icon = "bi-file-earmark-richtext", 
    title = "Quarto",
    desc = "Modern scientific publishing with enhanced features and interactivity.",
    note = quarto_status$message
  )
)
```

In the UI, the observer creates `div()`s with Bootstrap classes for
styling, layout, and typography. The `bindEvent()` provides event-driven
updates for optimal performance.

``` r

observe({
  output$desc <- renderUI({
    tags$div(
      class = paste(
        "alert border-start border-primary border-3 py-2",
        desc_inputs()$alert_class
      ),
      tags$div(
        class = "d-flex align-items-center mb-1",
        tags$i(class = paste("bi", desc_inputs()$description$icon, "me-2")),
        tags$strong(desc_inputs()$description$title)
      ),
      tags$p(desc_inputs()$description$desc, class = "mb-1 small"),
      tags$small(desc_inputs()$description$note, class = "text-muted")
    )
  })
}) |>
  bindEvent(format())
```

## The Report Generator

The download server reaches the rendering functions through
[`render_report()`](https://mjfrigaard.github.io/ttdviewer/reference/render_report.md):

``` r
stackcallr::call_tree_dir("../R", root = "mod_report_download_server")
█─mod_report_download_server
├─logr_msg
├─█─quarto_available
│ └─logr_msg
├─█─render_report
│ ├─logr_msg
│ ├─get_template_path
│ ├─█─create_fallback_template
│ │ ├─logr_msg
│ │ ├─create_fallback_rmd_template
│ │ └─create_fallback_qmd_template
│ ├─█─validate_and_clean_params
│ │ └─logr_msg
│ ├─█─render_rmarkdown_report
│ │ └─logr_msg
│ ├─█─render_quarto_report
│ │ ├─logr_msg
│ │ ├─█─quarto_available
│ │ │ └─logr_msg
│ │ ├─█─validate_quarto_params
│ │ │ └─logr_msg
│ │ ├─█─render_quarto_system_call
│ │ │ └─logr_msg
│ │ └─█─render_quarto_alternative
│ │   ├─logr_msg
│ │   └─convert_qmd_to_rmd
│ └─█─create_error_report
│   └─logr_msg
└─█─create_error_report
  └─logr_msg
```

### UI

The download module provides an input with `downloadButton()`, some
custom `div()` classes, and informative help text describing report
contents:

``` r

mod_report_download_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(
      class = "d-grid",
      downloadButton(
        ns("download_report"),
        "Download Report",
        class = "btn btn-primary",
        icon = icon("download")
      )
    ),
    tags$small(
      class = "text-muted",
      "Report includes: data visualization, summary statistics, data preview, and variable information."
    )
  )
}
```

### Server

The
[`mod_report_download_server()`](https://mjfrigaard.github.io/ttdviewer/reference/mod_report_download_server.md)
function requires the following arguments:

- `format`: A reactive expression returning the report format  
- `data`: A reactive expression returning the dataset list  
- `selected_plot_type`: A reactive expression returning the selected
  plot type  
- `dataset_title`: A reactive expression returning the dataset title

The `format` comes from
[`mod_report_input_server()`](https://mjfrigaard.github.io/ttdviewer/reference/mod_report_input_server.md).
The `data` and `dataset_title` come from
[`mod_input_server()`](https://mjfrigaard.github.io/ttdviewer/reference/mod_input_server.md).
That leaves one adjustment to the
[`mod_plot_server()`](https://mjfrigaard.github.io/ttdviewer/reference/mod_plot_server.md)
so it returns the selected `input$dataset` and `input$plots`:

``` r

    return(
      reactive({
        list(
          "dataset" = input$dataset,
          "plots" = input$plots
        )
      })
    ) |>
      bindEvent(
        list(
          input$dataset, 
          input$plots
          ),
        ignoreNULL = TRUE)
```

## The Rendering Engine

The download handler (`downloadHandler()`) can be paired with any
download UI function (`downloadButton()` or `downloadLink()`). Every
`downloadHandler()` includes `filename` and `content` functions.

- The `filename` function builds the file name from the first dataset
  name, the format, and a timestamp. It replaces unsafe characters and
  falls back to `tidytuesday_report.html` on error.

``` r

filename = function() {
  tryCatch({
    current_data <- data()
    actual_title <- if (!is.null(current_data) && length(current_data) > 0) {
      first_dataset_name <- names(current_data)[1]
      if (!is.null(first_dataset_name) && first_dataset_name != "") {
        gsub("\\.csv$", "", first_dataset_name)
      } else {
        "tidytuesday_dataset"
      }
    } else {
      "tidytuesday_dataset"
    }
    
    clean_title <- gsub("[^A-Za-z0-9_-]", "_", actual_title)
    timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
    format_suffix <- switch(input$report_format,
      "rmarkdown" = "rmd",
      "quarto" = "qto"
    )
    
    filename <- paste0(clean_title, "_", format_suffix, "_", timestamp, ".html")
    return(filename)
  }, error = function(e) {
    return("tidytuesday_report.html")
  })
}
```

- The `content` portion includes data validation before processing (with
  format detection and automatic fallback). The structured `params` list
  are passed to each template and include `dataset_title`, `title`,
  `data_list`, `plots`, and `plot_type`:

``` r

content = function(file) {
  tryCatch({
    # data validation
    current_data <- data()
    if (is.null(current_data) || length(current_data) == 0) {
      stop("No data available. Please select a dataset first.")
    }
    
    # format detection
    if (input$report_format == "quarto") {
      if (!quarto_available()) {
        # fallback
        actual_format <- "rmarkdown"
        showNotification("Quarto not available. Generating R Markdown report instead.", 
                        type = "warning", duration = 5)
      } else {
        actual_format <- "quarto"
      }
    } else {
      actual_format <- input$report_format
    }
    
    # progress notification
    showNotification(paste("Generating", tools::toTitleCase(actual_format), "report..."),
                    type = "message", duration = 8, id = "report_progress")
    
    # parameter preparation
    params <- list(
      dataset_title = actual_dataset_title,
      title = paste("TidyTuesday Report:", actual_dataset_title),
      data_list = current_data,
      plots = plots,
      plot_type = current_plot_type
    )
    
    # render 
    tryCatch({
      render_report(format = actual_format, output_file = file, params = params)
    }, error = function(render_error) {
      if (actual_format == "quarto") {
        render_report(format = "rmarkdown", output_file = file, params = params)
        showNotification("Quarto failed, generated R Markdown report instead.", 
                        type = "warning", duration = 5)
      } else {
        stop(render_error)
      }
    })
  }, error = function(e) {
    # fallback
    create_error_report(file, e$message, actual_dataset_title %||% "Unknown", input$report_format)
  })
}
```

The progress notifications provide real-time user feedback with
multi-level error handling, graceful recovery, and error report
generation when all else fails.

### Rendering Reports

The call tree for
[`render_report()`](https://mjfrigaard.github.io/ttdviewer/reference/render_report.md)
and its supporting utility functions is below:

``` r
stackcallr::call_tree_dir("../R", root = "render_report")
█─render_report
├─logr_msg
├─get_template_path
├─█─create_fallback_template
│ ├─logr_msg
│ ├─create_fallback_rmd_template
│ └─create_fallback_qmd_template
├─█─validate_and_clean_params
│ └─logr_msg
├─█─render_rmarkdown_report
│ └─logr_msg
├─█─render_quarto_report
│ ├─logr_msg
│ ├─█─quarto_available
│ │ └─logr_msg
│ ├─█─validate_quarto_params
│ │ └─logr_msg
│ ├─█─render_quarto_system_call
│ │ └─logr_msg
│ └─█─render_quarto_alternative
│   ├─logr_msg
│   └─convert_qmd_to_rmd
└─█─create_error_report
  └─logr_msg
```

The core rendering function coordinates multiple rendering strategies:

1.  The `template_path` is passed to
    [`get_template_path()`](https://mjfrigaard.github.io/ttdviewer/reference/get_template_path.md)
    (either R Markdown or Quarto) and, if a file doesn’t exist, the
    template resolution is handled with
    [`create_fallback_template()`](https://mjfrigaard.github.io/ttdviewer/reference/create_fallback_template.md).  
2.  The `params` are passed to
    [`validate_and_clean_params()`](https://mjfrigaard.github.io/ttdviewer/reference/validate_and_clean_params.md)
    to ensure the correct values are passed into the report.  
3.  Conditional logic handles the specific `format` selected (either
    [`render_rmarkdown_report()`](https://mjfrigaard.github.io/ttdviewer/reference/render_rmarkdown_report.md)
    or
    [`render_quarto_report()`](https://mjfrigaard.github.io/ttdviewer/reference/render_quarto_report.md))

``` r

render_report <- function(format = c("rmarkdown", "quarto"), output_file, params = list(), template_path = NULL) {
  format <- match.arg(format)
  
  # resolution
  if (is.null(template_path)) {
    template_path <- get_template_path(format)
  }
  
  # validation with fallback 
  if (!file.exists(template_path)) {
    template_path <- create_fallback_template(format)
  }
  
  # params validation and cleaning
  params <- validate_and_clean_params(params)
  
  # format-specific rendering
  if (format == "rmarkdown") {
    render_rmarkdown_report(template_path, output_file, params)
  } else {
    render_quarto_report(template_path, output_file, params)
  }
}
```

#### R Markdown

R Markdown rendering is handled by
[`render_rmarkdown_report()`](https://mjfrigaard.github.io/ttdviewer/reference/render_rmarkdown_report.md),
which creates a clean environment for rendering and adds any required
libraries:

``` r

render_rmarkdown_report <- function(template_path, output_file, params) {
  
  logr_msg(
    message = "Rendering R Markdown report", 
    level = "DEBUG")
  
  logr_msg(
    message = paste("Output file:", output_file), 
    level = "DEBUG")

  # clean environment
  render_env <- new.env(parent = globalenv())

  # add libs/reqs
  render_env$library <- library
  render_env$require <- require

  # log parameter details
  logr_msg(
    message = paste("Rendering with dataset_title:", params$dataset_title), 
    level = "DEBUG")
  logr_msg(
    message = paste("Rendering with title:", params$title), 
    level = "DEBUG")

  rmarkdown::render(
    input = template_path,
    output_file = output_file,
    params = params,
    envir = render_env,
    quiet = FALSE, 
    clean = TRUE
  )
}
```

#### Quarto

Quarto rendering is handled by
[`render_quarto_report()`](https://mjfrigaard.github.io/ttdviewer/reference/render_quarto_report.md)
and has a second method as a fallback strategy
([`render_quarto_system_call()`](https://mjfrigaard.github.io/ttdviewer/reference/render_quarto_system_call.md)):

``` r

render_quarto_report <- function(template_path, output_file, params) {
  # data_list is written to a temp RDS file and replaced with data_list_path
  # because quarto::quarto_render() calls check_params_for_na() on all
  # execute_params, which rejects data frames containing NA values
  data_list_path <- ""
  if (!is.null(params$data_list) && length(params$data_list) > 0) {
    data_list_path <- file.path(tempdir(), "data_list.rds")
    saveRDS(params$data_list, data_list_path)
  }
  quarto_params <- params
  quarto_params$data_list <- NULL
  quarto_params$data_list_path <- data_list_path

  # method 1 using the quarto R package
  if (requireNamespace("quarto", quietly = TRUE)) {
    quarto::quarto_render(
      input = temp_qmd,
      output_file = basename(output_file),
      execute_params = quarto_params,
      quiet = TRUE
    )
  } else {
    # method 2 system call fallback
    render_quarto_system_call(template_path, output_file, params)
  }
}
```

[`render_quarto_report()`](https://mjfrigaard.github.io/ttdviewer/reference/render_quarto_report.md)
will render the report if the quarto R package is installed, and
[`render_quarto_system_call()`](https://mjfrigaard.github.io/ttdviewer/reference/render_quarto_system_call.md)
is called for command-line installations. The `data_list` is always
passed via an RDS file rather than directly through `execute_params` to
avoid the `check_params_for_na()` validation that rejects data frames
with `NA` values.

#### Error Handling and Report

If every rendering attempt fails,
[`create_error_report()`](https://mjfrigaard.github.io/ttdviewer/reference/create_error_report.md)
writes an HTML error page:

``` r

create_error_report <- function(file, error_msg, dataset_title = "Unknown", format = "rmarkdown") {
  error_html <- paste0(
    '<!DOCTYPE html>
    <html>
    <head>
      <title>Report Generation Error</title>
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
      <div class="error-container">
        <h1 class="text-danger">Report Generation Failed</h1>
        <div class="alert alert-danger" role="alert">
          <h4 class="alert-heading">Error Details</h4>
          <p class="mb-0">', error_msg, '</p>
        </div>
        <div class="alert alert-info mt-4" role="alert">
          <h6 class="alert-heading">Troubleshooting Tips</h6>
          <ul class="mb-0">
            <li>Try selecting a different dataset</li>
            <li>Try a different report format</li>
            <li>Check your internet connection</li>
            <li>Contact support if the problem persists</li>
          </ul>
        </div>
      </div>
    </body>
    </html>'
  )
  
  writeLines(error_html, file)
}
```

#### Fallback Templates

The system includes automatic template generation when templates are
missing:

``` r

create_fallback_template <- function(format = c("rmarkdown", "quarto")) {
  format <- match.arg(format)
  
  if (format == "rmarkdown") {
    return(create_fallback_rmd_template())
  } else {
    return(create_fallback_qmd_template())
  }
}
```

The template system provides automatic template generation if the
template file is missing.

### Main Application Integration

The modules are integrated in the
[`app_ui()`](https://mjfrigaard.github.io/ttdviewer/reference/app_ui.md)
and
[`app_server()`](https://mjfrigaard.github.io/ttdviewer/reference/app_server.md)
below:

``` r

# in app_ui()
bslib::sidebar(
  mod_input_ui("input"),
  mod_report_input_ui("rep_form"),
  br(),
  mod_report_desc_ui("rep_desc"),
  mod_report_download_ui("rep_dwnld")
)

# in app_server()
report_format <- mod_report_input_server("rep_form")

mod_report_desc_server("rep_desc", format = report_format)

mod_report_download_server("rep_dwnld", 
  format = report_format,
  data = selected_data,
  selected_plot_type = selected_plots,
  dataset_title = dataset_title
)
```

The functions are placed to clearly illustrate the reactive data flow
between modules.

## Module Features

[TABLE]

------------------------------------------------------------------------

## Utility functions

The
[`get_template_path()`](https://mjfrigaard.github.io/ttdviewer/reference/get_template_path.md)
function returns the specified

``` r

identical(
  # response from function
  x = get_template_path("rmarkdown"),
  # response from system.file()
  y = system.file("rmarkdown", "report_template.Rmd",
    package = "ttdviewer"
  )
)
```

``` r

identical(
  # response from function
  x = get_template_path("quarto"),
  # response from system.file()
  y = system.file("quarto", "report_template.qmd",
    package = "ttdviewer"
  )
)
```

``` r

rmd_temp <- create_fallback_template(format = "rmarkdown")
basename(rmd_temp)
```

``` r

qmd_temp <- create_fallback_template(format = "quarto")
basename(qmd_temp)
```

### Quarto Detection

The
[`quarto_available()`](https://mjfrigaard.github.io/ttdviewer/reference/quarto_available.md)
function implements comprehensive system detection:

``` r

quarto_available <- function() {
  # 1. Check for quarto R package
  if (requireNamespace("quarto", quietly = TRUE)) {
    tryCatch({
      quarto::quarto_version()
      return(TRUE)
    }, error = function(e) {
      # Package exists but not functional
    })
  }
  
  # 2. Check system PATH
  result <- system2("quarto", args = "--version", stdout = TRUE, stderr = TRUE, timeout = 5)
  if (!is.null(result) && length(result) > 0) {
    return(TRUE)
  }
  
  # 3. Check common installation paths
  quarto_paths <- c(
    "/usr/local/bin/quarto",
    "/usr/bin/quarto",
    "C:/Program Files/Quarto/bin/quarto.exe"
  )
  
  for (path in quarto_paths) {
    if (file.exists(path)) {
      return(TRUE)
    }
  }
  
  return(FALSE)
}
```
