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
#' @param format One of `"csv"`, `"parquet"`, or `"original"`.
#' @param title The dataset title.
#'
#' @return A file name.
#'
#' @keywords internal
#'
tt_download_filename <- function(data, format, title) {
  if (length(data) > 1) {
    return(paste0(clean_title_string(title), "_", format, ".zip"))
  }
  file <- names(data)[1]
  switch(format,
    original = file,
    paste0(tt_file_stem(file), ".", format)
  )
}

#' Write TidyTuesday data for download
#'
#' Writes every data frame in `data` as CSV or parquet, or fetches the
#' original file from its `github_url` attribute. One file is written
#' straight to `file`; several files are zipped into `file`.
#'
#' @param data Named list of data frames from [load_tt_data()].
#' @param format One of `"csv"`, `"parquet"`, or `"original"`.
#' @param file Path to write the download to.
#'
#' @return `file`, invisibly.
#'
#' @keywords internal
#'
write_tt_download <- function(data, format = c("csv", "parquet", "original"), file) {
  format <- match.arg(format)
  dir <- tempfile("tt_download_")
  dir.create(dir)
  on.exit(unlink(dir, recursive = TRUE), add = TRUE)

  paths <- purrr::map2_chr(data, names(data), function(df, name) {
    out_name <- if (format == "original") {
      name
    } else {
      paste0(tt_file_stem(name), ".", format)
    }
    path <- file.path(dir, out_name)
    switch(format,
      csv      = vroom::vroom_write(df, path, delim = ","),
      parquet  = nanoparquet::write_parquet(df, path),
      original = utils::download.file(attr(df, "github_url"), path,
        quiet = TRUE, mode = "wb")
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
