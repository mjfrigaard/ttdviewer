#' Check Column Types in TidyTuesday Data
#'
#' A wrapper function that checks for specific column types across all datasets
#' in a [TidyTuesday](https://github.com/rfordatascience/tidytuesday) data list.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#' @param type Character string specifying the column type to check for.
#'   Options are:
#'  * `"num"` or `"numeric"` - numeric/integer columns
#'  * `"cat"` or `"character"` - character columns
#'  * `"log"` or `"logical"` - logical columns
#'  * `"list"` - list columns
#'  * `"date"` - date/datetime columns
#'
#' @return A named list where each element contains column names of the
#' specified type, or `character(0)` if no columns of that type exist
#' in that dataset
#'
#' @export
#'
#' @examples
#' ttd <- load_tt_data("Moore's Law")
#'
#' # Check for numeric columns
#' check_col_types(ttd, "num")
#'
#' # Check for character columns
#' check_col_types(ttd, "cat")
#'
#' # Check for logical columns
#' check_col_types(ttd, "log")
check_col_types <- function(ttd, type) {
  type <- rlang::arg_match(
    type, c("num", "cat", "log", "date", "list")
  )
  pick_cols <- function(df, predicate) {
    names(df)[purrr::map_lgl(df, predicate)]
  }

  checker <- switch(type,
    num = function(df) pick_cols(df, ~ is.numeric(.x) || is.integer(.x)),
    cat = function(df) pick_cols(df, is.character),
    log = function(df) pick_cols(df, is.logical),
    date = function(df) {
            pick_cols(df, ~ inherits(.x, "Date") || inherits(.x, "POSIXt"))
            },
    list = function(df) pick_cols(df, is.list)
  )

  purrr::map(ttd, checker) |>
    purrr::map(~ if (length(.x) == 0) character(0) else .x)
}
