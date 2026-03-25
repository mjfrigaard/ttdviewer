#' Check for List Columns in TidyTuesday Data
#'
#' Checks all datasets in a TidyTuesday data list for list columns.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#'
#' @return A named list where each element contains column names of list type,
#'   or `0` if no list columns exist in that dataset
#'
#' @export
#'
check_ttd_list_cols <- function(ttd) {
  data_frames <- ttd[sapply(ttd, is.data.frame)]
  if (length(data_frames) == 0) {
    return(list())
  }
  lapply(data_frames, function(df) {
    list_cols <- names(df)[sapply(df, is.list)]
    if (length(list_cols) == 0) 0 else list_cols
  })
}
