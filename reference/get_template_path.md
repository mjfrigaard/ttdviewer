# Get Template Path for Report Format

Resolves the path to the bundled report template for the given format
using [`system.file()`](https://rdrr.io/r/base/system.file.html).

## Usage

``` r
get_template_path(format)
```

## Arguments

- format:

  Report format: `"rmarkdown"` or `"quarto"`.

## Value

Character string path to the template file (empty string `""` if not
found).
