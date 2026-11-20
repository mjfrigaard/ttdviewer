# Get Dataset Metadata

Analyzes the column types across all datasets in a TidyTuesday data list
and returns a `tibble` with column type information.

## Usage

``` r
get_tt_title_meta(ttd)
```

## Arguments

- ttd:

  A list of data frames from
  [`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

## Value

A tibble with four columns:

- `clean_title`: Clean title of data

- `dataset`: Name of the dataset

- `col`: Column name (`NA` if no columns of that type exist)

- `col_type`: Type of column (numeric, logical, character, list)

## See also

[`load_tt_data()`](https://mjfrigaard.github.io/ttdviewer/reference/load_tt_data.md)

## Examples

``` r
ttd <- load_tt_data("Moore's Law")
#> Error in load_tt_data("Moore's Law"): No entries found for title: 'Moore's Law'
meta <- get_tt_title_meta(ttd)
#> Error: object 'ttd' not found
```
