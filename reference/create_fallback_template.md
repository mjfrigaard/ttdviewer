# Create Fallback Report Template

Dispatches to the appropriate fallback template creator based on the
requested report format.

## Usage

``` r
create_fallback_template(format = c("rmarkdown", "quarto"))
```

## Arguments

- format:

  Report format: `"rmarkdown"` or `"quarto"`.

## Value

Path to the created temporary template file.
