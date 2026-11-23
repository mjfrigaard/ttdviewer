# Timestamp

Returns the current system time formatted as `"YYYY-MM-DD-HH.MM.SS"`.

## Usage

``` r
tstmp()
```

## Value

A character string of the current date and time.

## Examples

``` r
tstmp()
#> [1] "2026-11-23-16.24.38"
cat(paste("Last updated:", tstmp()))
#> Last updated: 2026-11-23-16.24.38
```
