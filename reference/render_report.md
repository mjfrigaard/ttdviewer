# Render Report Based on Format Type

A utility function that renders either R Markdown or Quarto reports
based on the specified format. Validates and cleans parameters, resolves
the template path (creating a fallback if needed), delegates to the
appropriate renderer, and writes a self-contained HTML error page if
rendering fails.

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

  Character string: `"rmarkdown"` or `"quarto"`.

- output_file:

  Path to the output file.

- params:

  Named list of parameters to pass to the report template.

- template_path:

  Optional custom template path. When `NULL` (default), the bundled
  template for `format` is used.

## Value

The path to the rendered (or error-fallback) file, invisibly.

## See also

[`render_rmarkdown_report()`](https://mjfrigaard.github.io/ttdviewer/reference/render_rmarkdown_report.md),
[`render_quarto_report()`](https://mjfrigaard.github.io/ttdviewer/reference/render_quarto_report.md),
[`validate_and_clean_params()`](https://mjfrigaard.github.io/ttdviewer/reference/validate_and_clean_params.md),
[`validate_quarto_params()`](https://mjfrigaard.github.io/ttdviewer/reference/validate_quarto_params.md),
[`get_template_path()`](https://mjfrigaard.github.io/ttdviewer/reference/get_template_path.md),
[`create_fallback_template()`](https://mjfrigaard.github.io/ttdviewer/reference/create_fallback_template.md),
[`create_error_report()`](https://mjfrigaard.github.io/ttdviewer/reference/create_error_report.md)
