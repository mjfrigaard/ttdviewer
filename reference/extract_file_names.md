# Extract File Names from TidyTuesday Data Object

Extract File Names from TidyTuesday Data Object

## Usage

``` r
extract_file_names(tt_data)
```

## Arguments

- tt_data:

  A named list of TidyTuesday data from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

## Value

Character vector of file names with extensions included

## Examples

``` r
ttd <- load_tt_data("Moore's Law")
#> Error in load_tt_data("Moore's Law"): No entries found for title: 'Moore's Law'
extract_file_names(ttd)
#> Error: object 'ttd' not found
```
