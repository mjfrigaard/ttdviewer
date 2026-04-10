# Validate Quarto Parameters

Coerces and sanitises the parameter list before passing it to a Quarto
render call. Provides safe defaults for all required parameters and
removes characters that would break YAML parsing.

## Usage

``` r
validate_quarto_params(params)

validate_quarto_params(params)
```

## Arguments

- params:

  Named list of report parameters.

## Value

Validated parameter list

A validated named list of parameters.
