# Set the Shiny app display

Sets `shiny.launch.browser` for RStudio or Positron. Does nothing
outside an interactive session or outside those IDEs.

## Usage

``` r
display_type(run = "w")
```

## Arguments

- run:

  Display mode: `"p"` (viewer pane), `"b"` (external browser), `"w"`
  (viewer window), or `"NULL"` (unset the option).

## Value

`NULL`, invisibly. Called for its side effect on
[`options()`](https://rdrr.io/r/base/options.html).
