#' Extract and Clean Dataset Title
#'
#' `extract_dataset_title()` takes a dataset title and returns a cleaned version
#' suitable for use as a filename or identifier. It handles various punctuation
#' marks, special characters, and formatting to create a consistent snake_case
#' output.
#'
#' @param dataset_title Character string of the original dataset title
#'
#' @return Character string of the cleaned title in snake_case format
#'
#' @details
#' The function performs the following cleaning operations:
#'  * Removes quotes (single and double)
#'  * Removes apostrophes and converts contractions (e.g., "D'oh" becomes "Doh")
#'  * Removes punctuation marks (commas, periods, exclamation marks, etc.)
#'  * Removes parentheses and brackets
#'  * Removes dashes and converts to underscores
#'  * Converts to lowercase
#'  * Replaces multiple spaces with single spaces
#'  * Converts to snake_case format
#'  * Removes multiple consecutive underscores
#'
#' @examples
#' extract_dataset_title("Bring your own data from 2024!")
#' # Returns: "bring_your_own_data_from_2024"
#'
#' extract_dataset_title("Donuts, Data, and D'oh - A Deep Dive into The Simpsons")
#' # Returns: "donuts_data_and_doh_a_deep_dive_into_the_simpsons"
#'
#' extract_dataset_title("Moore's Law")
#'
#' extract_dataset_title("U.S. Wind Turbines (2018-2022)")
#'
#' @seealso
#' [snakecase::to_snake_case](https://cran.r-project.org/web/packages/snakecase/vignettes/introducing-the-snakecase-package.html)
#'
#' @export
#'
extract_dataset_title <- function(dataset_title) {

  if (is.null(dataset_title) || !is.character(dataset_title) || length(dataset_title) == 0) {
    logr_msg("Invalid dataset_title provided", level = "ERROR")
    return("unknown_dataset")
  }

  logr_msg(paste("Extracting clean title for:", dataset_title), level = "DEBUG")

  tryCatch({
      if (dataset_title != "") {
        title_exists <- TRUE
      } else {
        logr_msg("Empty dataset_title provided", level = "WARN")
        return("empty_dataset")
      }

      if (title_exists) {
        logr_msg(
          paste("Dataset title found in metadata!", dataset_title),
          level = "SUCCESS"
        )
        cleaned_title <- clean_title_string(dataset_title)
        return(cleaned_title)
      }

      title_tbl <- dplyr::inner_join(all_tt_data, all_tt_meta,
        by = c("year", "week")
      ) |>
        dplyr::filter(title == dataset_title) |>
        dplyr::mutate(
          clean_title = clean_title_string(title)
        ) |>
        dplyr::select(clean_title)

      cleaned_result <- unique(title_tbl[["clean_title"]])

      if (length(cleaned_result) == 0) {
        logr_msg("No clean title extracted, using fallback", level = "WARN")
        return(clean_title_string(dataset_title))
      }

      logr_msg(
        paste("Successfully extracted clean title:", cleaned_result[1]),
        level = "DEBUG"
      )

      return(cleaned_result[1])
    },
    error = function(e) {
      logr_msg(paste("Error extracting dataset title:", e$message), level = "ERROR")
      return(clean_title_string(dataset_title))
    }
  )
}
