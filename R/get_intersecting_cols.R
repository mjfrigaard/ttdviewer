#' Get Intersecting Column Names Between Two Datasets
#'
#' Helper function to find column names that exist in both datasets when
#' there are exactly two datasets in the
#' [TidyTuesday](https://github.com/rfordatascience/tidytuesday) data list.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#'
#' @return A character vector of intersecting column names, or empty vector
#'   if no intersections or if not exactly 2 datasets
#'
#' @export
#'
#' @examples
#' ttd <- load_tt_data("Moore's Law")
#' get_intersecting_cols(ttd)
get_intersecting_cols <- function(ttd) {
  if (length(ttd) != 2) {
    return(character(0))
  }
  intersect(names(ttd[[1]]), names(ttd[[2]]))
}
