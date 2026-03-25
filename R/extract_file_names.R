#' Extract File Names from TidyTuesday Data Object
#'
#' @param tt_data A named list of TidyTuesday data from [load_tt_data()]
#'
#' @return Character vector of file names with extensions included
#'
#' @export
#'
#' @examples
#' ttd <- load_tt_data("Moore's Law")
#' extract_file_names(ttd)
#'
extract_file_names <- function(tt_data) {
  if (!is.list(tt_data)) {
    stop("`tt_data` must be a list, typically from `load_tt_data()`.")
  }

  file_names <- names(tt_data)

  if (is.null(file_names)) {
    stop("`tt_data` must be a *named* list with file names as names.")
  }

  return(file_names)
}
