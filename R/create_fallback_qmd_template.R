#' Create Fallback Quarto Template
#'
#' Writes a minimal Quarto template to a temporary file and returns its
#' path. Used when the package-bundled template cannot be found.
#'
#' @return Path to the temporary `.qmd` template file.
#'
#' @keywords internal
#'
create_fallback_qmd_template <- function() {
  template_path <- tempfile(fileext = ".qmd")

  template_content <- '---
title: "{{< meta params.title >}}"
format: html
params:
  dataset_title: "Dataset"
  title: "TidyTuesday Report"
  data_list: NULL
  plots: NULL
  plot_type: "type"
execute:
  echo: false
  warning: false
  message: false
---

```{r setup}
library(ggplot2)
library(gt)
library(dplyr)
```

# {{< meta params.dataset_title >}}

This is a basic Quarto report for the TidyTuesday dataset.

```{r data-info}
#| results: asis
if (!is.null(params$data_list) && length(params$data_list) > 0) {
  first_df <- params$data_list[[1]]
  cat("Dataset dimensions:", nrow(first_df), "rows ×", ncol(first_df), "columns\\n")

  # Show basic summary
  knitr::kable(head(first_df, 5), caption = "Data Preview")
}
```

```{r plots}
if (!is.null(params$plots) && inherits(params$plots, "gg")) {
  print(params$plots)
}
```
'

  writeLines(template_content, template_path)
  return(template_path)
}
