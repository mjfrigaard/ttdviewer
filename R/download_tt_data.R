#' Strip data file extensions
#'
#' @param x Character vector of file names (e.g., `"a.csv.gz"`).
#'
#' @return `x` without its data extension (e.g., `"a"`).
#'
#' @keywords internal
#'
tt_file_stem <- function(x) {
  sub("\\.(csv|tsv|xlsx|rds|zip|parquet)(\\.gz)?$", "", x, ignore.case = TRUE)
}

#' Name a TidyTuesday data download
#'
#' A single file keeps its own name (with the extension for `format`).
#' Several files are bundled into one `.zip` named after the dataset title.
#'
#' @param data Named list of data frames from [load_tt_data()].
#' @param format One of `"csv"` or `"parquet"`.
#' @param title The dataset title.
#'
#' @return A file name.
#'
#' @keywords internal
#'
tt_download_filename <- function(data, format = c("csv", "parquet"), title) {
  format <- match.arg(format)
  if (length(data) > 1) {
    return(paste0(clean_title_string(title), "_", format, ".zip"))
  }
  paste0(tt_file_stem(names(data)[1]), ".", format)
}

#' Write TidyTuesday data for download
#'
#' Writes every data frame in `data` as CSV or parquet. One file is written
#' straight to `file`; several files are zipped into `file`.
#'
#' @param data Named list of data frames from [load_tt_data()].
#' @param format One of `"csv"` or `"parquet"`.
#' @param file Path to write the download to.
#'
#' @return `file`, invisibly.
#'
#' @keywords internal
#'
write_tt_download <- function(data, format = c("csv", "parquet"), file) {
  format <- match.arg(format)
  dir <- tempfile("tt_download_")
  dir.create(dir)
  on.exit(unlink(dir, recursive = TRUE), add = TRUE)

  paths <- purrr::map2_chr(data, names(data), function(df, name) {
    path <- file.path(dir, paste0(tt_file_stem(name), ".", format))
    switch(format,
      csv     = vroom::vroom_write(df, path, delim = ","),
      parquet = nanoparquet::write_parquet(df, path)
    )
    path
  })

  if (length(paths) == 1) {
    file.copy(paths, file, overwrite = TRUE)
  } else {
    zip::zip(file, files = basename(paths), root = dir)
  }
  logr_msg(paste("Wrote", format, "download:", paste(basename(paths), collapse = ", ")),
    level = "INFO")
  invisible(file)
}
