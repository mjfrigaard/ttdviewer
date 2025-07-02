#' Inspect and Plot TidyTuesday Data
#'
#' A comprehensive function that analyzes TidyTuesday datasets and generates
#' appropriate inspection plots based on data characteristics and number of datasets.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#' @param plot Character vector specifying which plots to generate. Options include:
#'   - `"types"` - Column type distributions
#'   - `"mem"` - Memory usage analysis
#'   - `"na"` - Missing value analysis
#'   - `"cor"` - Correlation analysis (numeric columns)
#'   - `"imb"` - Feature imbalance (categorical columns)
#'   - `"num"` - Numeric column summaries
#'   - `"cat"` - Categorical column summaries
#'   - `"all"` - Generate all available plots (default)
#'
#' @return Plots are displayed; function is called for side effects
#'
#' @export
#'
#' @examples
#' ttd <- load_tt_data("Moore’s Law")
#'
#' # Generate all plots
#' inspect_plot(ttd)
#'
#' # Generate only specific plots
#' inspect_plot(ttd, plot = c("types", "mem"))
#'
#' # Generate single plot type
#' inspect_plot(ttd, plot = "cor")
#'
inspect_plot <- function(ttd, plots = "all") {
  all_plots <- c("types","mem","na","cor","imb","num","cat")
  # normalize
  if ("all" %in% plots) plots <- all_plots
  bad <- setdiff(plots, all_plots)
  if (length(bad)) {
    stop("Invalid plot type(s): ", paste(bad, collapse = ", "),
         "\nValid are: ", paste(all_plots, collapse = ", "))
  }

  n   <- ttd_length(ttd)
  num <- check_col_types(ttd, "num")

  # mapping of names → inspectdf functions
  funs <- list(
    types = inspectdf::inspect_types,
    mem   = inspectdf::inspect_mem,
    na    = inspectdf::inspect_na,
    cor   = inspectdf::inspect_cor,
    imb   = inspectdf::inspect_imb,
    num   = inspectdf::inspect_num,
    cat   = inspectdf::inspect_cat
  )

  # for each requested plot type, dispatch
  for (plt in plots) {
    fn <- funs[[plt]]
    # if n == 2, compare the two frames; else do each separately
    if (n == 2) {
      p <- fn(df1 = ttd[[1]], df2 = ttd[[2]])
      print(p |> inspectdf::show_plot(text_labels = TRUE))
    } else {
      purrr::imap(ttd, function(df, nm) {
        # skip non–data.frame
        if (!is.data.frame(df)) return()
        # for cor/num, require ≥2 numeric cols
        if (plt %in% c("cor","num") &&
            !has_min_cols(num, which(names(ttd) == nm), min_count = 2)) {
          return()
        }
        p <- fn(df1 = df, df2 = NULL)
        print(p |> inspectdf::show_plot(text_labels = TRUE))
      })
    }
  }

  invisible(NULL)
}

#' Check if Dataset Has Minimum Required Columns
#'
#' Helper function to determine if a specific dataset has sufficient columns
#' of a given type for analysis.
#'
#' @param col_list A named list of column vectors (output from `check_col_types()`)
#' @param dataset_idx Integer index of the dataset to check
#' @param min_count Minimum number of columns required (default: 1)
#'
#' @return Logical indicating whether the dataset has sufficient columns
#'
#' @export
#'
#' @examples
#' ttd <- load_tt_data("Moore’s Law")
#' num_cols <- check_col_types(ttd, "num")
#' has_min_cols(num_cols, 1, min_count = 2)
has_min_cols <- function(col_list, dataset_idx, min_count = 1) {
  purrr::pluck(col_list, dataset_idx, .default = character(0)) |>
    length() >= min_count
}


#' Get Intersecting Column Names Between Two Datasets
#'
#' Helper function to find column names that exist in both datasets when
#' there are exactly two datasets in the
#' [TidyTuesday](https://github.com/rfordatascience/tidytuesday) data list.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#'
#' @return A character vector of intersecting column names, or empty vector
#'   if no intersections or if not exactly 2 datasets
#'
#' @export
#'
#' @examples
#' ttd <- load_tt_data("Moore’s Law")
#' get_intersecting_cols(ttd)
get_intersecting_cols <- function(ttd) {
  if (length(ttd) != 2) {
    return(character(0))
  }
  intersect(names(ttd[[1]]), names(ttd[[2]]))
}

#' Check Column Types in TidyTuesday Data
#'
#' A wrapper function that checks for specific column types across all datasets
#' in a [TidyTuesday](https://github.com/rfordatascience/tidytuesday) data list.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#' @param type Character string specifying the column type to check for.
#'   Options are:
#'  * `"num"` or `"numeric"` - numeric/integer columns
#'  * `"cat"` or `"character"` - character columns
#'  * `"log"` or `"logical"` - logical columns
#'  * `"list"` - list columns
#'  * `"date"` - date/datetime columns
#'
#' @return A named list where each element contains column names of the
#' specified type, or 0 if no columns of that type exist in that dataset
#'
#' @export
#'
#' @examples
#' ttd <- load_tt_data("Moore's Law")
#'
#' # Check for numeric columns
#' check_col_types(ttd, "num")
#'
#' # Check for character columns
#' check_col_types(ttd, "cat")
#'
#' # Check for logical columns
#' check_col_types(ttd, "log")
check_col_types <- function(ttd, type) {
  type <- rlang::arg_match(
    type, c("num", "cat", "log", "date", "list")
  )
  # a small helper to pick columns of each class
  pick_cols <- function(df, predicate) {
    names(df)[purrr::map_lgl(df, predicate)]
  }

  checker <- switch(type,
    num = function(df) pick_cols(df, ~ is.numeric(.x) || is.integer(.x)),
    cat = function(df) pick_cols(df, is.character),
    log = function(df) pick_cols(df, is.logical),
    date = function(df) {
      pick_cols(
        df,
        ~ inherits(.x, "Date") || inherits(.x, "POSIXt")
      )
    },
    list = function(df) pick_cols(df, is.list)
  )
  purrr::map(ttd, checker) |>
    purrr::map(~ if (length(.x) == 0) character(0) else .x)
}


#' Check for Numeric Columns in TidyTuesday Data
#'
#' Checks all datasets in a TidyTuesday data list for numeric columns.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#'
#' @return A named list where each element contains column names of numeric type,
#'   or 0 if no numeric columns exist in that dataset
#'
#' @export
#'
check_ttd_num_cols <- function(ttd) {
  # Filter out non-data.frame elements
  data_frames <- ttd[sapply(ttd, is.data.frame)]
  if (length(data_frames) == 0) {
    return(list())
  }
  # Check each dataset for numeric columns
  result <- lapply(data_frames, function(df) {
    num_cols <- names(df)[sapply(df, function(x) is.numeric(x) || is.integer(x))]
    if (length(num_cols) == 0) 0 else num_cols
  })
  return(result)
}

#' Check for Categorical (Character) Columns in TidyTuesday Data
#'
#' Checks all datasets in a TidyTuesday data list for character columns.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#'
#' @return A named list where each element contains column names of character type,
#'   or 0 if no character columns exist in that dataset
#'
#' @export
#'
check_ttd_cat_cols <- function(ttd) {
  # Filter out non-data.frame elements
  data_frames <- ttd[sapply(ttd, is.data.frame)]

  if (length(data_frames) == 0) {
    return(list())
  }

  # Check each dataset for character columns
  result <- lapply(data_frames, function(df) {
    cat_cols <- names(df)[sapply(df, is.character)]
    if (length(cat_cols) == 0) 0 else cat_cols
  })

  return(result)
}

#' Check for List Columns in TidyTuesday Data
#'
#' Checks all datasets in a TidyTuesday data list for list columns.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#'
#' @return A named list where each element contains column names of list type,
#'   or 0 if no list columns exist in that dataset
#'
#' @export
#'
check_ttd_list_cols <- function(ttd) {
  # Filter out non-data.frame elements
  data_frames <- ttd[sapply(ttd, is.data.frame)]

  if (length(data_frames) == 0) {
    return(list())
  }

  # Check each dataset for list columns
  result <- lapply(data_frames, function(df) {
    list_cols <- names(df)[sapply(df, is.list)]
    if (length(list_cols) == 0) 0 else list_cols
  })

  return(result)
}

#' Check for Logical Columns in TidyTuesday Data
#'
#' Checks all datasets in a TidyTuesday data list for logical columns.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#'
#' @return A named list where each element contains column names of logical type,
#'   or 0 if no logical columns exist in that dataset
#'
#' @export
#'
check_ttd_log_cols <- function(ttd) {
  # Filter out non-data.frame elements
  data_frames <- ttd[sapply(ttd, is.data.frame)]

  if (length(data_frames) == 0) {
    return(list())
  }

  # Check each dataset for logical columns
  result <- lapply(data_frames, function(df) {
    log_cols <- names(df)[sapply(df, is.logical)]
    if (length(log_cols) == 0) 0 else log_cols
  })

  return(result)
}

#' Check for Date Columns in TidyTuesday Data
#'
#' Checks all datasets in a TidyTuesday data list for date/datetime columns.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#'
#' @return A named list where each element contains column names of date/datetime type,
#'   or 0 if no date columns exist in that dataset
#'
#' @export
#'
check_ttd_date_cols <- function(ttd) {
  # Filter out non-data.frame elements
  data_frames <- ttd[sapply(ttd, is.data.frame)]

  if (length(data_frames) == 0) {
    return(list())
  }

  # Check each dataset for date columns
  result <- lapply(data_frames, function(df) {
    date_cols <- names(df)[sapply(df, function(x) {
      inherits(x, "Date") ||
        inherits(x, "POSIXct") ||
        inherits(x, "POSIXlt") ||
        inherits(x, "POSIXt")
    })]
    if (length(date_cols) == 0) 0 else date_cols
  })

  return(result)
}
#' Determine length of TidyTuesday Data
#'
#' @param ttd A list of data frames from [load_tt_data()]
#'
#' @returns integer length of `ttd`
#'
#' @export
#'
#' @examples
#' ttd <- load_tt_data("Moore’s Law")
#' ttd_length(ttd)
#'
ttd_length <- function(ttd) {
  purrr::keep(ttd, is.data.frame) |> length()
}
