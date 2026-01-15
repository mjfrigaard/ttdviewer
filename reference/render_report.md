# Render Report Based on Format Type

A utility function that renders either R Markdown or Quarto reports
based on the specified format.

## Usage

``` r
render_report(
  format = c("rmarkdown", "quarto"),
  output_file,
  params = list(),
  template_path = NULL
)
```

## Arguments

- format:

  Character string: "rmarkdown" or "quarto"

- output_file:

  Path to the output file

- params:

  List of parameters to pass to the report

- template_path:

  Optional custom template path

## Value

Path to the rendered file
