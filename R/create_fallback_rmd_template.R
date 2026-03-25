#' Create Fallback R Markdown Template
#'
#' Writes a minimal R Markdown template to a temporary file and returns its
#' path. Used when the package-bundled template cannot be found.
#'
#' @return Path to the temporary `.Rmd` template file.
#'
#' @keywords internal
#'
create_fallback_rmd_template <- function() {
  template_path <- tempfile(fileext = ".Rmd")

  template_content <- '---
title: "`r params$title`"
output:
  html_document:
    theme: bootstrap
    toc: true
params:
  dataset_title: "Dataset"
  title: "TidyTuesday Report"
  data_list: NULL
  plots: NULL
  plot_type: "type"
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE, warning = FALSE, message = FALSE)
library(ggplot2)
library(gt)
library(dplyr)
```

# `r params$dataset_title`

This is a basic R Markdown report for the TidyTuesday dataset: **`r params$dataset_title`**

## Data Overview

```{r data-info, results="asis"}
if (!is.null(params$data_list) && length(params$data_list) > 0) {
  first_df <- params$data_list[[1]]
  dataset_names <- names(params$data_list)

  cat("**Number of datasets:**", length(params$data_list), "\\n\\n")
  cat("**Dataset names:**", paste(dataset_names, collapse = ", "), "\\n\\n")
  cat("**Main dataset dimensions:**", nrow(first_df), "rows ×", ncol(first_df), "columns\\n\\n")

  # Show basic summary
  knitr::kable(head(first_df, 5), caption = "Data Preview")
} else {
  cat("No data available for preview.\\n")
}
```

## Visualization

```{r plots, fig.width=10, fig.height=6}
if (!is.null(params$plots) && inherits(params$plots, "gg")) {
  print(params$plots)
} else {
  cat("No visualization available.")
}
```
'

  writeLines(template_content, template_path)
  return(template_path)
}
