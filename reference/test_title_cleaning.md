# Test Dataset Title Cleaning

A utility function to test the title cleaning functionality with various
edge cases and examples.

## Usage

``` r
test_title_cleaning()
```

## Value

A data frame showing original titles and their cleaned versions

## Examples

``` r
test_title_cleaning()
#>                                                  Original
#> 1                          Bring your own data from 2024!
#> 2  Donuts, Data, and D'oh - A Deep Dive into The Simpsons
#> 3                                             Moore's Law
#> 4                          U.S. Wind Turbines (2018-2022)
#> 5                       It's Always Sunny in Philadelphia
#> 6                         Bob's Burgers & Restaurant Data
#> 7                         COVID-19: The Pandemic's Impact
#> 8                           Taylor Swift's Albums & Songs
#> 9                                   NASA's Space Missions
#> 10                                 Women's World Cup 2023
#> 11                        Pride & Prejudice Text Analysis
#> 12                        R-Ladies: Global Chapter Events
#> 13                         Lorem Ipsum... Text Generator!
#> 14                                    Data Science @ Work
#> 15                                    AI/ML in Healthcare
#> 16                            50% Off: Black Friday Sales
#> 17                                 #TidyTuesday Community
#> 18                           Star Wars: The Force Awakens
#> 19                   Climate Change – Global Temperatures
#> 20                                   NYC Taxi & Uber Data
#>                                              Cleaned
#> 1                      bring_your_own_data_from_2024
#> 2  donuts_data_and_doh_a_deep_dive_into_the_simpsons
#> 3                                         moores_law
#> 4                        u_s_wind_turbines_2018_2022
#> 5                   its_always_sunny_in_philadelphia
#> 6                       bobs_burgers_restaurant_data
#> 7                      covid_19_the_pandemics_impact
#> 8                         taylor_swifts_albums_songs
#> 9                              nas_as_space_missions
#> 10                             womens_world_cup_2023
#> 11                     pride_prejudice_text_analysis
#> 12                    r_ladies_global_chapter_events
#> 13                        lorem_ipsum_text_generator
#> 14                                 data_science_work
#> 15                               ai_ml_in_healthcare
#> 16                 dataset_50_off_black_friday_sales
#> 17                            tidy_tuesday_community
#> 18                       star_wars_the_force_awakens
#> 19                climate_change_global_temperatures
#> 20                                nyc_taxi_uber_data
```
