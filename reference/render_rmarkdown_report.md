# Render R Markdown Report

Renders an R Markdown (`.Rmd`) template to the specified output file
using
[`rmarkdown::render()`](https://pkgs.rstudio.com/rmarkdown/reference/render.html).

## Usage

``` r
render_rmarkdown_report(template_path, output_file, params)

render_rmarkdown_report(template_path, output_file, params)
```

## Arguments

- template_path:

  Path to the `.Rmd` template file.

- output_file:

  Output file path.

- params:

  Named list of report parameters.

## Value

Called for its side-effect of writing `output_file`.
