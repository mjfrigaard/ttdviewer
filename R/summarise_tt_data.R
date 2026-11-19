#' Summarise a TidyTuesday data file
#'
#' @param df A data frame.
#'
#' @return A tibble with `metric` and `value` columns: rows, columns, missing
#'   values, complete rows, and data types.
#'
#' @keywords internal
#'
tt_file_summary <- function(df) {
  types <- unique(vapply(df, function(x) class(x)[1], character(1)))
  tibble::tibble(
    metric = c("Rows", "Columns", "Missing values", "Complete rows", "Data types"),
    value = c(
      format(nrow(df), big.mark = ","),
      format(ncol(df), big.mark = ","),
      format(sum(is.na(df)), big.mark = ","),
      format(sum(stats::complete.cases(df)), big.mark = ","),
      paste(types, collapse = ", ")
    )
  )
}

#' Describe the variables in a TidyTuesday data file
#'
#' @param df A data frame.
#'
#' @return A tibble with one row per column: `variable`, `type`, `missing`,
#'   `missing_pct`, and `unique`.
#'
#' @keywords internal
#'
tt_var_info <- function(df) {
  missing <- vapply(df, function(x) sum(is.na(x)), integer(1))
  tibble::tibble(
    variable    = names(df),
    type        = vapply(df, function(x) class(x)[1], character(1), USE.NAMES = FALSE),
    missing     = unname(missing),
    missing_pct = unname(round(missing / max(nrow(df), 1) * 100, 1)),
    unique      = vapply(df, function(x) length(unique(x)), integer(1), USE.NAMES = FALSE)
  )
}
