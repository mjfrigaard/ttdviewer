#' Validate and Clean Report Parameters
#'
#' Merges the supplied parameter list with defaults, coerces types, ensures
#' `data_list` is a named list, and strips characters from `dataset_title`
#' that could cause rendering issues.
#'
#' @param params Named list of report parameters.
#'
#' @return A cleaned and validated named list of parameters.
#'
#' @keywords internal
#'
validate_and_clean_params <- function(params) {

  logr_msg(
    message = "Validating and cleaning report parameters",
    level = "DEBUG")

  # required parameters exist
  default_params <- list(
    dataset_title = "TidyTuesday Dataset",
    title = "TidyTuesday Data Report",
    data_list = list(),
    plots = NULL,
    plot_type = "type"
  )

  # merge with defaults
  for (param_name in names(default_params)) {
    if (is.null(params[[param_name]])) {
      params[[param_name]] <- default_params[[param_name]]

      logr_msg(
        message = paste("Using default for parameter:", param_name),
        level = "DEBUG")
    }
  }

  # validate data_list
  if (!is.list(params$data_list)) {
    logr_msg(
      message = "data_list is not a list, converting",
      level = "WARN")
    params$data_list <- list(params$data_list)
  }

  # ensure data_list has proper names
  if (length(params$data_list) > 0 && is.null(names(params$data_list))) {
    logr_msg(
      message = "Adding default names to data_list",
      level = "DEBUG")
    names(params$data_list) <- paste0("dataset_", seq_along(params$data_list))
  }

  # clean dataset title
  if (is.character(params$dataset_title) && length(params$dataset_title) > 0) {
    # remove any problematic characters
    params$dataset_title <- gsub("[\"'`]", "", params$dataset_title)
  }

  # log parameters
  logr_msg(
    message = paste("Final dataset_title:", params$dataset_title),
    level = "DEBUG")
  logr_msg(
    message = paste("Number of datasets:", length(params$data_list)),
    level = "DEBUG")

  if (length(params$data_list) > 0) {
    logr_msg(
      message = paste("Dataset names:",
        paste(names(params$data_list), collapse = ", ")),
      level = "DEBUG")
  }

  return(params)
}
