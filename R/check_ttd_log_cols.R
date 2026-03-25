#' Check for Logical Columns in TidyTuesday Data
#'
#' Checks all datasets in a TidyTuesday data list for logical columns.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#'
#' @return A named list where each element contains column names of logical type,
#'   or `0` if no logical columns exist in that dataset
#'
#' @export
#'
check_ttd_log_cols <- function(ttd) {
  data_frames <- ttd[sapply(ttd, is.data.frame)]
  if (length(data_frames) == 0) {
    return(list())
  }
  lapply(data_frames, function(df) {
    log_cols <- names(df)[sapply(df, is.logical)]
    if (length(log_cols) == 0) 0 else log_cols
  })
}
