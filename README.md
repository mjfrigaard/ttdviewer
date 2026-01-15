
<!-- README.md is generated from README.Rmd. Please edit that file -->

# The \#TidyTuesday data viewer

<!-- badges: start -->

<!-- badges: end -->

The \#TidyTuesday data viewer (`ttdviewer`) is an Shiny app-package[^1]
for viewing the data from the [`#TidyTuesday`
project.](https://github.com/rfordatascience/tidytuesday) This package
started out as a small application to demonstrate various examples of
downloadable reports (R Markdown, Quarto, etc.), but it’s grown to
include additional features:

1.  The data are loaded directly from GitHub (i.e., with help from the
    [`tidytuesdayR`](https://dslc-io.github.io/tidytuesdayR/) and
    [`ttmeta`](https://r4ds.github.io/ttmeta/) packages).
2.  The returned object is visible as a list on the first `nav_panel()`
    via the [`listviewerlite`
    package](https://long39ng.github.io/listviewerlite/).  
3.  The data are visible as a table compliments of the [`reactable`
    package](https://glin.github.io/reactable/) in the second
    `nav_panel()`.  
4.  Data visualizations from the [`inspectdf`
    package](https://alastairrushworth.com/inspectdf/) ‘*summarise
    missingness, categorical levels, numeric distribution, correlation,
    column types and memory usage*’ are available on the third
    `nav_panel()`.

## Architecture

The app is packaged as a Shiny application with a single entry point
that wires UI and server logic together. The server loads the selected
dataset, routes it through module servers, and then exposes the
reactive outputs to the UI panels.

``` mermaid
%%{init: {'theme': 'neutral', 'look': 'handDrawn', 'themeVariables': { 'fontFamily': 'monospace', "fontSize":"18px"}}}%%
flowchart TD
  Launch["launch()"] --> UI["app_ui()"]
  Launch --> Server["app_server()"]
  Server --> Input["mod_input_server()"]
  Input --> Data["load_tt_data()"]
  Server --> ReportInput["mod_report_input_server()"]
  ReportInput --> ReportDesc["mod_report_desc_server()"]
  ReportInput --> ReportDownload["mod_report_download_server()"]
  ReportDownload --> RenderReport["render_report()"]
  Server --> List["mod_list_server()"]
  Server --> Table["mod_table_server()"]
  Server --> Plot["mod_plot_server()"]
  Plot --> InspectPlot["inspect_plot()"]
  Data --> List
  Data --> Table
  Data --> Plot
```

The UI arranges module outputs into panels while the sidebar hosts the
dataset selector and report generation options.

``` mermaid
%%{init: {'theme': 'neutral', 'look': 'handDrawn', 'themeVariables': { 'fontFamily': 'monospace', "fontSize":"18px"}}}%%
flowchart LR
  Sidebar["Sidebar inputs"] --> InputUI["mod_input_ui()"]
  Sidebar --> ReportUI["mod_report_input_ui()"]
  Sidebar --> ReportDescUI["mod_report_desc_ui()"]
  Sidebar --> ReportDownloadUI["mod_report_download_ui()"]
  Tabs["Tab panels"] --> ListUI["mod_list_ui()"]
  Tabs --> TableUI["mod_table_ui()"]
  Tabs --> PlotUI["mod_plot_ui()"]
```

Supporting utilities and tests wrap the core modules. Logging, data
helpers, and report builders are kept in standalone R files, while
`tests/testthat` validates module behavior and data helpers.

``` mermaid
%%{init: {'theme': 'neutral', 'look': 'handDrawn', 'themeVariables': { 'fontFamily': 'monospace', "fontSize":"18px"}}}%%
flowchart TB
  subgraph Utilities
    Log["logr_msg()"]
    Ctr["ctr()"]
    Load["load_tt_data()"]
    Inspect["inspect_plot()"]
    Render["render_report()"]
  end
  subgraph Modules
    ModInput["mod_input_*"]
    ModList["mod_list_*"]
    ModTable["mod_table_*"]
    ModPlot["mod_plot_*"]
    ModReport["mod_report_*"]
  end
  subgraph Tests
    TestApp["test-app_*"]
    TestModules["test-mod_*"]
    TestUtils["test-load_tt_data / test-inspect_plot / test-render_report / test-logr_msg"]
  end
  Utilities --> Modules
  Modules --> Tests
  Utilities --> Tests
```

## Installation

You can install the development version of `ttdviewer` from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("mjfrigaard/ttdviewer")
```

## Launch app

Launch the application using the standalone app function below:

``` r
library(ttdviewer)
launch()
```

[^1]: An R package containing a Shiny application. Read more
    [here](https://mastering-shiny.org/scaling-packaging.html).
