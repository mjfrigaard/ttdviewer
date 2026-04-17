# Render Quarto Report via System Call

Invokes the `quarto` CLI directly via
[`system2()`](https://rdrr.io/r/base/system2.html) to render a `.qmd`
template. Used when the `quarto` R package is not available.

## Usage

``` r
render_quarto_system_call(template_path, output_file, params)
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
