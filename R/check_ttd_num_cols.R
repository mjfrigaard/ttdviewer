#' Check for Numeric Columns in TidyTuesday Data
#'
#' Checks all datasets in a TidyTuesday data list for numeric columns.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#'
#' @return A named list where each element contains column names of numeric type,
#'   or `0` if no numeric columns exist in that dataset
#'
#' @export
#'
check_ttd_num_cols <- function(ttd) {
  data_frames <- ttd[sapply(ttd, is.data.frame)]
  if (length(data_frames) == 0) {
    return(list())
  }
  lapply(data_frames, function(df) {
    num_cols <- names(df)[sapply(df, function(x) is.numeric(x) || is.integer(x))]
    if (length(num_cols) == 0) 0 else num_cols
  })
}
