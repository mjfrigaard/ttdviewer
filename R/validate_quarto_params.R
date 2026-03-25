#' Validate Quarto Parameters
#'
#' Coerces and sanitises the parameter list before passing it to a Quarto
#' render call. Provides safe defaults for all required parameters and
#' removes characters that would break YAML parsing.
#'
#' @param params Named list of report parameters.
#'
#' @return A validated named list of parameters.
#'
#' @keywords internal
#'
validate_quarto_params <- function(params) {

  logr_msg(
    message = "Validating Quarto parameters",
    level = "DEBUG")

  # validate all req params
  validated_params <- list(
    dataset_title = as.character(params$dataset_title %||% "TidyTuesday Dataset"),
    title = as.character(params$title %||% "TidyTuesday Report"),
    data_list = if (is.list(params$data_list)) params$data_list else list(),
    plots = params$plots, # Can be NULL
    plot_type = as.character(params$plot_type %||% "type")
  )

  # clean title for quarto
  validated_params$dataset_title <- gsub('["\'"]', "", validated_params$dataset_title)
  validated_params$title <- gsub('["\'"]', "", validated_params$title)

  logr_msg(
    message = paste("Validated dataset_title:", validated_params$dataset_title),
    level = "DEBUG")
  logr_msg(
    message = paste("Validated data_list length:", length(validated_params$data_list)),
    level = "DEBUG")

  return(validated_params)
}
