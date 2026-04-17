# Validate and Clean Report Parameters

Merges the supplied parameter list with defaults, coerces types, ensures
`data_list` is a named list, and strips characters from `dataset_title`
that could cause rendering issues.

## Usage

``` r
validate_and_clean_params(params)
```

## Arguments

- params:

  Named list of report parameters.

## Value

A cleaned and validated named list of parameters.
