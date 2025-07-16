### \--- LOAD TIDY TUESDAY DATA --\ ----

#' Load TidyTuesday datasets from GitHub by title
#'
#' Filters an internal dataset `all_tt_combined` by `title`, and loads
#' associated data files using appropriate methods depending on `data_type`.
#' Supports functional error handling and logging.
#'
#' @section Features:
#' * Automatically selects the correct reader (`csv`, `tsv`, `xlsx`, `rds`)
#' * Logs messages using `logr_msg()`
#' * Adds a `clean_title` attribute to each dataset
#' * Skips unsupported formats (`vgz`, `zip`, `NA`)
#'
#' @section Supported file types:
#' * `"csv"` / `"csv.gz"` → `vroom::vroom()`
#' * `"tsv"`              → `vroom::vroom()`
#' * `"xlsx"`             → `readxl::read_excel()`
#' * `"rds"`              → `readRDS()` from a URL connection
#'
#' @section Unsupported:
#' * `"vgz"`, `"zip"`, or `NA` → skipped with error logging
#'
#' @param title A character string matching the `title` field in `all_tt_combined`.
#'
#' @return A named list of tibbles or data frames (one per file). Failed or skipped
#' datasets are excluded.
#'
#' @export
#'
#' @examples
#' load_tt_data("posit::conf talks")
load_tt_data <- function(title) {

  # required packages
  requireNamespace("purrr", quietly = TRUE)
  requireNamespace("vroom", quietly = TRUE)
  requireNamespace("readxl", quietly = TRUE)
  requireNamespace("logger", quietly = TRUE)

  # load metadata
  if (!exists("all_tt_combined", envir = .GlobalEnv)) {
    stop("Internal dataset `all_tt_combined` not found in global environment.")
  }

  df <- get("all_tt_combined", envir = .GlobalEnv)

  if (!title %in% df$title) {
    stop(glue::glue("No entries found for title: '{title}'"))
  }

  files <- df |>
    dplyr::filter(title == !!title) |>
    dplyr::distinct(data_files, data_type, github_url, clean_title) |>
    dplyr::filter(!is.na(data_files))

  purrr::pmap(
    list(
      file  = files$data_files,
      type  = files$data_type,
      url   = files$github_url,
      cname = files$clean_title
    ),
    function(file, type, url, cname) {
      # determine true file type using extension
      effective_type <- dplyr::case_when(
        grepl("\\.csv\\.gz$", file, ignore.case = TRUE) ~ "csv.gz",
        grepl("\\.csv$", file, ignore.case = TRUE) ~ "csv",
        grepl("\\.tsv$", file, ignore.case = TRUE) ~ "tsv",
        grepl("\\.xlsx$", file, ignore.case = TRUE) ~ "xlsx",
        grepl("\\.rds$", file, ignore.case = TRUE) ~ "rds",
        TRUE ~ tolower(type)
      )

      if (is.na(effective_type) || effective_type %in% c("vgz", "zip")) {
        logr_msg(
          message = glue::glue("Skipping unsupported file type '{type}' for {file}"),
          level = "ERROR")
        return(NULL)
      }

      logr_msg(
        message = glue::glue("Starting import for {file} from {url}"),
        level = "INFO")

      result <- purrr::safely(function() {
        switch(effective_type,
          "csv" = vroom::vroom(url, delim = ",", show_col_types = FALSE),
          "csv.gz" = vroom::vroom(url, delim = ",", show_col_types = FALSE),
          "tsv" = vroom::vroom(url, delim = "\t", show_col_types = FALSE),
          "xlsx" = readxl::read_excel(url),
          "rds" = {
            con <- url(url)
            on.exit(close(con), add = TRUE)
            readRDS(con)
          },
          stop(glue::glue("Unknown or unsupported file type: {effective_type}"))
        )
      })()

      if (!is.null(result$result)) {
        logr_msg(
          message = glue::glue("Successfully loaded {file}"),
          level = "SUCCESS"
          )
        attr(result$result, "clean_title") <- cname
        return(result$result)
      } else {
        logr_msg(
          message = glue::glue("Failed to load {file}: {result$error$message}"),
          level = "ERROR")
        return(NULL)
      }
    }
  ) |>
    rlang::set_names(files$data_files) |>
    purrr::compact()
}

### \--- GET TIDY TUESDAY TITLE METADATA --\ ----

#' Get Dataset Metadata
#'
#' Analyzes the column types across all datasets in a TidyTuesday data list
#' and returns a `tibble` with column type information.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#'
#' @return A tibble with four columns:
#'  * `clean_title`: Clean title of data
#'  * `col_type`: Type of column (numeric, logical, character, list)
#'  * `dataset`: Name of the dataset
#'  * `col`: Column name (NA if no columns of that type exist)
#'
#'
#' @seealso [load_tt_data()]
#'
#' @export
#'
#' @examples
#' ttd <- load_tt_data("Moore’s Law")
#' meta <- get_tt_title_meta(ttd)
#' print(meta)
#'
get_tt_title_meta <- function(ttd) {

  # check if input is a list
  if (!is.list(ttd)) {
    logr_msg(paste("Error: Input is not a list:", class(ttd)), level = "ERROR")
    stop("Input must be a list of data frames")
  }

  # filter to data.frames only
  data_frames <- ttd[sapply(ttd, is.data.frame)]

  if (length(data_frames) == 0) {
    logr_msg("Error: No data frames found in list", level = "ERROR")
    stop("No data frames found in the input list")
  }

  logr_msg(paste("Datasets in list:", paste(names(data_frames), collapse = ", ")),
    level = "INFO"
  )

  # type checking
  type_checks <- list(
    numeric = function(x) is.numeric(x) || is.integer(x),
    logical = is.logical,
    character = is.character,
    list = is.list
  )

  # get columns by type
  get_cols_by_type <- function(df, type_name, type_check_fn) {
    cols <- names(df)[sapply(df, type_check_fn)]
    if (length(cols) == 0) NA_character_ else cols
  }

  # process single dataset
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

    # combine results
    dataset_result <- do.call(rbind, type_results)

    # log type counts
    type_counts <- sapply(type_checks, function(fn) sum(sapply(df, fn)))

    logr_msg(paste(
      "Dataset", dataset_name, "- Numeric:", type_counts[1],
      "Logical:", type_counts[2],
      "Character:", type_counts[3],
      "List:", type_counts[4]
    ), level = "DEBUG")

    return(dataset_result)
  }

  # process datasets in list
  all_results <- Map(process_dataset, names(data_frames), data_frames)
  result <- do.call(rbind, all_results)

  ## clean_title attribute as a column
  clean_titles <- purrr::map_chr(data_frames, ~ attr(.x, "clean_title") %||% NA_character_)
  result$clean_title <- clean_titles[match(result$dataset, names(data_frames))]

  # reorder columns
  result <- result[, c("clean_title", "dataset", "col", "col_type")]

  # log summary
  logr_msg(paste(
    "Created metadata tibble with", nrow(result), "rows covering",
    length(unique(result$dataset)), "datasets"
  ), level = "INFO")

  return(result)
}

### \--- EXTRACT FILE NAMES --\ ----

#' Extract file names from TidyTuesday data object
#'
#' @param tt_data list of TidyTuesday data from [load_tt_data()]
#'
#' @return Character vector of file names with extensions included
#'
#' @export
#'
#' @examples
#'
#' ttd <- load_tt_data("Moore’s Law")
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

### \--- CLEAN TITLE STRING --\ ----

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
#'  *  Normalize whitespace
#'  *  Convert to snake_case
#'  *  Final cleanup of underscores
#'
#' @export
#'
clean_title_string <- function(title) {
  if (is.null(title) || !is.character(title) || length(title) == 0) {
    return("unknown_title")
  }

  # original title
  cleaned <- title

  # quotes and apostrophes
  # unicode escape sequences for special quote characters
  # remove all types of quotes
  cleaned <- gsub('["\'`\u201C\u201D\u2018\u2019]', "", cleaned)

  # contractions and possessives
  # remove apostrophes before letters
  cleaned <- gsub("'([a-zA-Z])", "\\1", cleaned)
  # convert possessives
  cleaned <- gsub("([a-zA-Z])'s\\b", "\\1s", cleaned)
  # internal apostrophes
  cleaned <- gsub("([a-zA-Z])'([a-zA-Z])", "\\1\\2", cleaned)

  # punctuation marks (note: escaped curly braces)
  # replace with spaces
  cleaned <- gsub("[!@#$%^&*()+=\\[\\]\\{\\}|;:,.<>?/~`]", " ", cleaned)

  # dashes and special separators
  cleaned <- gsub("[-–—]", " ", cleaned) # Convert all types of dashes to spaces

  # special characters and symbols
  cleaned <- gsub("[©®™°§¶†‡•‰‱€£¥₹₽¢]", "", cleaned) # Remove special symbols

  # normalize whitespace
  # multiple spaces to single space
  # remove leading/trailing whitespace
  cleaned <- gsub("\\s+", " ", cleaned)
  cleaned <- trimws(cleaned)

  # convert to snake_case using snakecase package
  cleaned <- snakecase::to_snake_case(cleaned)

  # final cleanup
  cleaned <- gsub("_+", "_", cleaned) # Multiple underscores to single
  cleaned <- gsub("^_|_$", "", cleaned) # Remove leading/trailing underscores

  # make sure it starts with a letter (for valid R names)
  if (grepl("^[0-9]", cleaned)) {
    cleaned <- paste0("dataset_", cleaned)
  }

  return(cleaned)
}


### \--- EXTRACT DATASET TITLE --\ ----

#' Extract and Clean Dataset Title
#'
#' `extract_dataset_title()` takes a dataset title and returns a cleaned version suitable
#' for use as a filename or identifier. It handles various punctuation marks,
#' special characters, and formatting to create a consistent snake_case output.
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
#' [snakecase::to_snake_case](https://cran.r-project.org/web/packages/snakecase/vignettes/introducing-the-snakecase-package.html) for the underlying `snake_case` conversion
#'
#' @export
#'
extract_dataset_title <- function(dataset_title) {

  # validate input
  if (is.null(dataset_title) || !is.character(dataset_title) || length(dataset_title) == 0) {
    logr_msg("Invalid dataset_title provided",
      level = "ERROR"
    )
    return("unknown_dataset")
  }

  logr_msg(
    paste("Extracting clean title for:", dataset_title),
    level = "DEBUG"
  )

  tryCatch({
      if (dataset_title != "") {
        # check if dataset exists in metadata
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
        # clean title (even if doesn't exist)
        cleaned_title <- clean_title_string(dataset_title)
        return(cleaned_title)
      }

      # get title from metadata
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

      # fallback to string cleaning
      return(clean_title_string(dataset_title))

    }
  )
}
