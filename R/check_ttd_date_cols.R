#' Check for Date Columns in TidyTuesday Data
#'
#' Checks all datasets in a TidyTuesday data list for date/datetime columns.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#'
#' @return A named list where each element contains column names of date/datetime type,
#'   or `0` if no date columns exist in that dataset
#'
#' @export
#'
check_ttd_date_cols <- function(ttd) {
  data_frames <- ttd[sapply(ttd, is.data.frame)]
  if (length(data_frames) == 0) {
    return(list())
  }
  lapply(data_frames, function(df) {
    date_cols <- names(df)[sapply(df, function(x) {
      inherits(x, "Date") ||
        inherits(x, "POSIXct") ||
        inherits(x, "POSIXlt") ||
        inherits(x, "POSIXt")
    })]
    if (length(date_cols) == 0) 0 else date_cols
  })
}
