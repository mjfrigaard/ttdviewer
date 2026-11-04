# Timestamp

Returns the current system time formatted as `"YYYY-MM-DD-HH.MM.SS"`.

## Usage

``` r
tstmp()

tstmp()
```

## Value

character string of date/time.

A character string of the current date and time.

## Examples

``` r
tstmp()
#> [1] "2026-11-04-05.52.11"
cat(paste("Last updated:", tstmp()))
#> Last updated: 2026-11-04-05.52.11
tstmp()
#> [1] "2026-11-04-05.52.11"
cat(paste("Last updated:", tstmp()))
#> Last updated: 2026-11-04-05.52.11
```
