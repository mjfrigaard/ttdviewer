# Render Quarto Report with Enhanced Error Handling

Renders a Quarto (`.qmd`) report using the `quarto` R package when
available, falling back to a system call or alternative rendering method
on failure.

## Usage

``` r
render_quarto_report(template_path, output_file, params)
```

## Arguments

- template_path:

  Path to the `.qmd` template file.

- output_file:

  Output file path.

- params:

  Named list of report parameters. `data_list` (a named list of data
  frames) is serialised to a temp `.rds` file; all other parameters are
  passed as-is via `execute_params`.

## Value

Called for its side-effect of writing `output_file`.

## Details

Before calling
[`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html),
any `data_list` element in `params` is written to a temporary `.rds`
file and replaced with a `data_list_path` string. This is required
because
[`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html)
validates all `execute_params` for `NA` values (via an internal
`check_params_for_na()` call), and data frames containing `NA`s cannot
be passed directly.
