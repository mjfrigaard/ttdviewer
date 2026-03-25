#' Determine Length of TidyTuesday Data
#'
#' @param ttd A list of data frames from [load_tt_data()]
#'
#' @return Integer length of `ttd` (counting only data frames)
#'
#' @export
#'
#' @examples
#' ttd <- load_tt_data("Moore's Law")
#' ttd_length(ttd)
#'
ttd_length <- function(ttd) {
  purrr::keep(ttd, is.data.frame) |> length()
}
