### \--- INTERNAL FILE LOADERS --\ ----

# Internal helpers exist as named functions in the ttdviewer namespace so that
# tests can stub them with local_mocked_bindings().

.load_xlsx <- function(url) {
  tmp <- tempfile(fileext = ".xlsx")
  on.exit(unlink(tmp), add = TRUE)
  download.file(url, tmp, quiet = TRUE, mode = "wb")
  readxl::read_excel(tmp)
}

.load_rds <- function(url) {
  con <- url(url)
  on.exit(close(con), add = TRUE)
  readRDS(con)
}

.load_zip <- function(url) {
  tmp <- tempfile(fileext = ".zip")
  dir <- tempfile("unzip_")
  on.exit(unlink(c(tmp, dir), recursive = TRUE), add = TRUE)
  download.file(url, tmp, quiet = TRUE, mode = "wb")
  files <- utils::unzip(tmp, exdir = dir)
  files <- files[grepl("\\.(csv|tsv)$", files, ignore.case = TRUE) &
                 !grepl("__MACOSX", files, fixed = TRUE)]
  if (length(files) == 0) stop("No CSV or TSV files found in zip archive")
  delim <- if (all(grepl("\\.tsv$", files, ignore.case = TRUE))) "\t" else ","
  tryCatch(
    vroom::vroom(files, delim = delim, show_col_types = FALSE),
    error = function(e) {
      # files don't share columns (e.g., a clean table plus raw exports):
      # keep the widest file, then the longest
      dfs <- lapply(files, function(f) {
        suppressWarnings(vroom::vroom(f, delim = delim, show_col_types = FALSE))
      })
      best <- order(-vapply(dfs, ncol, integer(1)), -vapply(dfs, nrow, integer(1)))[1]
      logr_msg(
        message = paste0("Zip files have different columns; kept ", basename(files[best]),
          ", skipped ", paste(basename(files[-best]), collapse = ", ")),
        level = "WARN")
      dfs[[best]]
    }
  )
}

# Some upstream files mix Windows-1252 or Mac Roman text into UTF-8 columns;
# invalid strings break downstream rendering (e.g., listviewerlite), so
# re-encode them. Mac Roman smart quotes are bytes D0-D5; Windows-1252 uses
# 80-9F, which Mac Roman spends on accented letters.
.guess_encoding <- function(x) {
  bytes <- as.integer(charToRaw(x))
  if (any(bytes >= 0xD0 & bytes <= 0xD5) && !any(bytes >= 0x80 & bytes <= 0x9F)) {
    "macintosh"
  } else {
    "windows-1252"
  }
}

.fix_utf8 <- function(df) {
  if (!is.data.frame(df)) return(df)
  for (col in names(df)) {
    x <- df[[col]]
    if (is.character(x)) {
      bad <- !is.na(x) & !validUTF8(x)
      if (any(bad)) {
        x[bad] <- vapply(x[bad], function(s) {
          iconv(s, from = .guess_encoding(s), to = "UTF-8", sub = "?")
        }, character(1), USE.NAMES = FALSE)
        df[[col]] <- x
      }
    }
  }
  df
}

### \--- LOAD TIDY TUESDAY DATA --\ ----

#' Load TidyTuesday Datasets from GitHub by Title
#'
#' Filters the internal dataset `all_tt_combined` by `title` and loads the
#' associated data files using a method appropriate for each `data_type`.
#'
#' @section Supported file types:
#' * `"csv"` / `"csv.gz"` - [vroom::vroom()]
#' * `"tsv"` - [vroom::vroom()]
#' * `"xlsx"` - [readxl::read_excel()]
#' * `"rds"` - [readRDS()] via a URL connection
#' * `"zip"` - downloaded and unzipped; every CSV (or TSV) inside is read
#'   with [vroom::vroom()] and stacked into one data frame. If the files have
#'   different columns, only the widest file is kept (with a warning in the log)
#'
#' @section Unsupported:
#' * Any other `data_type`, or `NA`: skipped with error logging
#'
#' @param title A character string matching the `title` field in
#'   `all_tt_combined`.
#'
#' @return A named list of tibbles or data frames (one per file), each with
#'   `clean_title`, `github_url`, and `date` (TidyTuesday release date)
#'   attributes. Failed or skipped datasets are
#'   excluded.
#'
#' @export
#'
#' @examples
#' load_tt_data("posit::conf talks")
#'
load_tt_data <- function(title) {

  requireNamespace("purrr",  quietly = TRUE)
  requireNamespace("vroom",  quietly = TRUE)
  requireNamespace("readxl", quietly = TRUE)

  if (!exists("all_tt_combined", envir = .GlobalEnv)) {
    stop("Internal dataset `all_tt_combined` not found in global environment.")
  }

  df <- get("all_tt_combined", envir = .GlobalEnv)

  if (!title %in% df$title) {
    stop(glue::glue("No entries found for title: '{title}'"))
  }

  files <- df |>
    dplyr::filter(title == !!title) |>
    dplyr::distinct(data_files, data_type, github_url, clean_title, date) |>
    dplyr::filter(!is.na(data_files))

  purrr::pmap(
    list(
      file  = files$data_files,
      type  = files$data_type,
      url   = files$github_url,
      cname = files$clean_title,
      date  = files$date
    ),
    function(file, type, url, cname, date) {
      effective_type <- dplyr::case_when(
        grepl("\\.csv\\.gz$", file, ignore.case = TRUE) ~ "csv.gz",
        grepl("\\.csv$",      file, ignore.case = TRUE) ~ "csv",
        grepl("\\.tsv$",      file, ignore.case = TRUE) ~ "tsv",
        grepl("\\.xlsx$",     file, ignore.case = TRUE) ~ "xlsx",
        grepl("\\.rds$",      file, ignore.case = TRUE) ~ "rds",
        grepl("\\.zip$",      file, ignore.case = TRUE) ~ "zip",
        TRUE ~ tolower(type)
      )

      if (is.na(effective_type) || effective_type == "vgz") {
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
          "csv"    = vroom::vroom(url, delim = ",",  show_col_types = FALSE),
          "csv.gz" = vroom::vroom(url, delim = ",",  show_col_types = FALSE),
          "tsv"    = vroom::vroom(url, delim = "\t", show_col_types = FALSE),
          "xlsx"   = .load_xlsx(url),
          "rds"    = .load_rds(url),
          "zip"    = .load_zip(url),
          stop(glue::glue("Unknown or unsupported file type: {effective_type}"))
        )
      })()

      if (!is.null(result$result)) {
        logr_msg(
          message = glue::glue("Successfully loaded {file}"),
          level = "SUCCESS")
        result$result <- .fix_utf8(result$result)
        attr(result$result, "clean_title") <- cname
        attr(result$result, "github_url") <- url
        attr(result$result, "date") <- date
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
