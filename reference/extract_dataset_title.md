# Extract and Clean Dataset Title

`extract_dataset_title()` takes a dataset title and returns a cleaned
version suitable for use as a filename or identifier. It handles various
punctuation marks, special characters, and formatting to create a
consistent snake_case output.

## Usage

``` r
extract_dataset_title(dataset_title)
```

## Arguments

- dataset_title:

  Character string of the original dataset title

## Value

Character string of the cleaned title in snake_case format

## Details

The function performs the following cleaning operations:

- Removes quotes (single and double)

- Removes apostrophes and converts contractions (e.g., "D'oh" becomes
  "Doh")

- Removes punctuation marks (commas, periods, exclamation marks, etc.)

- Removes parentheses and brackets

- Removes dashes and converts to underscores

- Converts to lowercase

- Replaces multiple spaces with single spaces

- Converts to snake_case format

- Removes multiple consecutive underscores

## See also

[snakecase::to_snake_case](https://cran.r-project.org/web/packages/snakecase/vignettes/introducing-the-snakecase-package.html)
for the underlying `snake_case` conversion

## Examples

``` r
extract_dataset_title("Bring your own data from 2024!")
#> SUCCESS [2026-01-15 19:40:10] Dataset title found in metadata! Bring your own data from 2024!
#> [1] "bring_your_own_data_from_2024"
# Returns: "bring_your_own_data_from_2024"

extract_dataset_title("Donuts, Data, and D'oh - A Deep Dive into The Simpsons")
#> SUCCESS [2026-01-15 19:40:10] Dataset title found in metadata! Donuts, Data, and D'oh - A Deep Dive into The Simpsons
#> [1] "donuts_data_and_doh_a_deep_dive_into_the_simpsons"
# Returns: "donuts_data_and_doh_a_deep_dive_into_the_simpsons"

extract_dataset_title("Moore's Law")
#> SUCCESS [2026-01-15 19:40:10] Dataset title found in metadata! Moore's Law
#> [1] "moores_law"

extract_dataset_title("U.S. Wind Turbines (2018-2022)")
#> SUCCESS [2026-01-15 19:40:10] Dataset title found in metadata! U.S. Wind Turbines (2018-2022)
#> [1] "u_s_wind_turbines_2018_2022"
```
