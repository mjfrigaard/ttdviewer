# Convert Quarto Syntax to R Markdown

Performs a best-effort conversion of a Quarto (`.qmd`) document's lines
to R Markdown-compatible syntax, replacing Quarto chunk options, callout
divs, and the YAML header.

## Usage

``` r
convert_qmd_to_rmd(qmd_lines)

convert_qmd_to_rmd(qmd_lines)
```

## Arguments

- qmd_lines:

  Character vector of lines read from a `.qmd` file.

## Value

Character vector of lines suitable for use in an `.Rmd` file.
