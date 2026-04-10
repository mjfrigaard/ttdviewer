# Create Fallback Report Template

Dispatches to the appropriate fallback template creator based on the
requested report format.

## Usage

``` r
create_fallback_template(format = c("rmarkdown", "quarto"))

create_fallback_template(format = c("rmarkdown", "quarto"))
```

## Arguments

- format:

  Report format

## Value

Path to the created temporary template file.

Path to created template
