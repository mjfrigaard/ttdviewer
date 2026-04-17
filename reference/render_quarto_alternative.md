# Alternative Quarto Rendering via R Markdown

Converts a Quarto (`.qmd`) template to R Markdown and renders it with
[`rmarkdown::render()`](https://pkgs.rstudio.com/rmarkdown/reference/render.html).
Used as a fallback when the `quarto` package or system Quarto binary is
unavailable.

## Usage

``` r
render_quarto_alternative(template_path, output_file, params)
```

## Arguments

- template_path:

  Path to the `.qmd` template file.

- output_file:

  Output file path.

- params:

  Named list of report parameters.

## Value

Called for its side-effect of writing `output_file`.
