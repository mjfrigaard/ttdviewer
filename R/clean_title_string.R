#' Clean Title String
#'
#' Internal function that performs the actual string cleaning operations.
#' This function handles various types of punctuation and formatting issues
#' commonly found in dataset titles.
#'
#' @param title Character string to clean
#'
#' @return Character string cleaned and converted to snake_case
#'
#' @details
#' The cleaning process follows these steps:
#'  * Remove or replace problematic characters
#'  * Normalize whitespace
#'  * Convert to snake_case
#'  * Final cleanup of underscores
#'
#' @export
#'
clean_title_string <- function(title) {
  if (is.null(title) || !is.character(title) || length(title) == 0) {
    return("unknown_title")
  }

  cleaned <- title

  # remove all types of quotes
  cleaned <- gsub('["\'`\u201C\u201D\u2018\u2019]', "", cleaned)

  # contractions and possessives
  cleaned <- gsub("'([a-zA-Z])", "\\1", cleaned)
  cleaned <- gsub("([a-zA-Z])'s\\b", "\\1s", cleaned)
  cleaned <- gsub("([a-zA-Z])'([a-zA-Z])", "\\1\\2", cleaned)

  # punctuation marks
  cleaned <- gsub("[!@#$%^&*()+=\\[\\]\\{\\}|;:,.<>?/~`]", " ", cleaned)

  # dashes and special separators
  cleaned <- gsub("[-\u2013\u2014]", " ", cleaned)

  # special characters and symbols
  cleaned <- gsub("[\u00A9\u00AE\u2122\u00B0\u00A7\u00B6\u2020\u2021\u2022\u2030\u2031\u20AC\u00A3\u00A5\u20B9\u20BD\u00A2]", "", cleaned)

  # normalize whitespace
  cleaned <- gsub("\\s+", " ", cleaned)
  cleaned <- trimws(cleaned)

  # convert to snake_case
  cleaned <- snakecase::to_snake_case(cleaned)

  # final cleanup
  cleaned <- gsub("_+", "_", cleaned)
  cleaned <- gsub("^_|_$", "", cleaned)

  # ensure it starts with a letter
  if (grepl("^[0-9]", cleaned)) {
    cleaned <- paste0("dataset_", cleaned)
  }

  return(cleaned)
}
