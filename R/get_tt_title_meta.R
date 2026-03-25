#' Get Dataset Metadata
#'
#' Analyzes the column types across all datasets in a TidyTuesday data list
#' and returns a `tibble` with column type information.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#'
#' @return A tibble with four columns:
#'  * `clean_title`: Clean title of data
#'  * `dataset`: Name of the dataset
#'  * `col`: Column name (`NA` if no columns of that type exist)
#'  * `col_type`: Type of column (numeric, logical, character, list)
#'
#' @seealso [load_tt_data()]
#'
#' @export
#'
#' @examples
#' ttd <- load_tt_data("Moore's Law")
#' meta <- get_tt_title_meta(ttd)
#'
get_tt_title_meta <- function(ttd) {

  if (!is.list(ttd)) {
    logr_msg(paste("Error: Input is not a list:", class(ttd)), level = "ERROR")
    stop("Input must be a list of data frames")
  }

  data_frames <- ttd[sapply(ttd, is.data.frame)]

  if (length(data_frames) == 0) {
    logr_msg("Error: No data frames found in list", level = "ERROR")
    stop("No data frames found in the input list")
  }

  logr_msg(paste("Datasets in list:", paste(names(data_frames), collapse = ", ")),
    level = "INFO"
  )

  type_checks <- list(
    numeric = function(x) is.numeric(x) || is.integer(x),
    logical = is.logical,
    character = is.character,
    list = is.list
  )

  get_cols_by_type <- function(df, type_name, type_check_fn) {
    cols <- names(df)[sapply(df, type_check_fn)]
    if (length(cols) == 0) NA_character_ else cols
  }

  process_dataset <- function(dataset_name, df) {
    logr_msg(paste("Analyzing dataset:", dataset_name, "with", ncol(df), "columns"),
      level = "DEBUG"
    )

    type_results <- Map(function(type_name, type_check_fn) {
      cols <- get_cols_by_type(df, type_name, type_check_fn)
      tibble::tibble(
        dataset = dataset_name,
        col_type = type_name,
        col = cols
      )
    }, names(type_checks), type_checks)

    dataset_result <- do.call(rbind, type_results)

    type_counts <- sapply(type_checks, function(fn) sum(sapply(df, fn)))

    logr_msg(paste(
      "Dataset", dataset_name, "- Numeric:", type_counts[1],
      "Logical:", type_counts[2],
      "Character:", type_counts[3],
      "List:", type_counts[4]
    ), level = "DEBUG")

    return(dataset_result)
  }

  all_results <- Map(process_dataset, names(data_frames), data_frames)
  result <- do.call(rbind, all_results)

  clean_titles <- purrr::map_chr(data_frames, ~ attr(.x, "clean_title") %||% NA_character_)
  result$clean_title <- clean_titles[match(result$dataset, names(data_frames))]

  result <- result[, c("clean_title", "dataset", "col", "col_type")]

  logr_msg(paste(
    "Created metadata tibble with", nrow(result), "rows covering",
    length(unique(result$dataset)), "datasets"
  ), level = "INFO")

  return(result)
}
