# Render Quarto Report with Enhanced Error Handling

Renders a Quarto (`.qmd`) report using the `quarto` R package when
available, falling back to a system call or alternative rendering method
on failure.

## Usage

``` r
render_quarto_report(template_path, output_file, params)

render_quarto_report(template_path, output_file, params)
```

## Arguments

- template_path:

  Path to qmd template

- output_file:

  Output file path

- params:

  Report parameters

## Value

Called for its side-effect of writing `output_file`.
