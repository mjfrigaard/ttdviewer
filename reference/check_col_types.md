# Check Column Types in TidyTuesday Data

A wrapper function that checks for specific column types across all
datasets in a
[TidyTuesday](https://github.com/rfordatascience/tidytuesday) data list.

## Usage

``` r
check_col_types(ttd, type)
```

## Arguments

- ttd:

  A list of data frames from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

- type:

  Character string specifying the column type to check for. Options are:

  - `"num"` or `"numeric"` - numeric/integer columns

  - `"cat"` or `"character"` - character columns

  - `"log"` or `"logical"` - logical columns

  - `"list"` - list columns

  - `"date"` - date/datetime columns

## Value

A named list where each element contains column names of the specified
type, or 0 if no columns of that type exist in that dataset

## Examples

``` r
ttd <- load_tt_data("Moore's Law")
#> Error in load_tt_data("Moore's Law"): No entries found for title: 'Moore's Law'

# Check for numeric columns
check_col_types(ttd, "num")
#> Error: object 'ttd' not found

# Check for character columns
check_col_types(ttd, "cat")
#> Error: object 'ttd' not found

# Check for logical columns
check_col_types(ttd, "log")
#> Error: object 'ttd' not found
```
