#' Check if Dataset Has Minimum Required Columns
#'
#' Helper function to determine if a specific dataset has sufficient columns
#' of a given type for analysis.
#'
#' @param col_list A named list of column vectors (output from `check_col_types()`)
#' @param dataset_idx Integer index of the dataset to check
#' @param min_count Minimum number of columns required (default: 1)
#'
#' @return Logical indicating whether the dataset has sufficient columns
#'
#' @export
#'
#' @examples
#' ttd <- load_tt_data("Moore's Law")
#' num_cols <- check_col_types(ttd, "num")
#' has_min_cols(num_cols, 1, min_count = 2)
has_min_cols <- function(col_list, dataset_idx, min_count = 1) {
  purrr::pluck(col_list, dataset_idx, .default = character(0)) |>
    length() >= min_count
}
