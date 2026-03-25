#' Check for Categorical (Character) Columns in TidyTuesday Data
#'
#' Checks all datasets in a TidyTuesday data list for character columns.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#'
#' @return A named list where each element contains column names of character type,
#'   or `0` if no character columns exist in that dataset
#'
#' @export
#'
check_ttd_cat_cols <- function(ttd) {
  data_frames <- ttd[sapply(ttd, is.data.frame)]
  if (length(data_frames) == 0) {
    return(list())
  }
  lapply(data_frames, function(df) {
    cat_cols <- names(df)[sapply(df, is.character)]
    if (length(cat_cols) == 0) 0 else cat_cols
  })
}
