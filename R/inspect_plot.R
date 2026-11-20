#' Inspect and Plot TidyTuesday Data
#'
#' Analyzes TidyTuesday datasets and generates inspection plots based on
#' data characteristics and number of datasets.
#'
#' @param ttd A list of data frames from [load_tt_data()]
#' @param plots Character vector specifying which plots to generate. Options:
#'   - `"types"` - Column type distributions
#'   - `"mem"` - Memory usage analysis
#'   - `"na"` - Missing value analysis
#'   - `"cor"` - Correlation analysis (numeric columns)
#'   - `"imb"` - Feature imbalance (categorical columns)
#'   - `"num"` - Numeric column summaries
#'   - `"cat"` - Categorical column summaries
#'   - `"all"` - Generate all available plots (default)
#'
#' @return Invisibly returns `NULL`. Called for side effects (plots are displayed).
#'
#' @export
#'
#' @examples
#' ttd <- load_tt_data("Moore’s Law")
#'
#' inspect_plot(ttd)
#' inspect_plot(ttd, plots = c("types", "mem"))
#' inspect_plot(ttd, plots = "cor")
#'
inspect_plot <- function(ttd, plots = "all") {

  logr_msg("inspect_plot(): starting analysis", level = "INFO")

  out <- tryCatch({
    all_plots <- c("types", "mem", "na", "cor", "imb", "num", "cat")
    if ("all" %in% plots) plots <- all_plots
    invalid <- setdiff(plots, all_plots)
    if (length(invalid) > 0) {
      msg <- paste0(
        "Invalid plot type(s): ", paste(invalid, collapse = ", "),
        " - valid are: ", paste(all_plots, collapse = ", ")
      )
      logr_msg(msg, level = "ERROR")
      stop(msg)
    }
    logr_msg(paste0("Requested plots: ", paste(plots, collapse = ", ")), level = "DEBUG")

    n_datasets <- ttd_length(ttd)
    num_cols   <- check_col_types(ttd, "num")

    funs <- list(
      types = inspectdf::inspect_types,
      mem   = inspectdf::inspect_mem,
      na    = inspectdf::inspect_na,
      cor   = inspectdf::inspect_cor,
      imb   = inspectdf::inspect_imb,
      num   = inspectdf::inspect_num,
      cat   = inspectdf::inspect_cat
    )

    for (plt in plots) {
      logr_msg(paste0("Beginning plot type '", plt, "'"), level = "INFO")
      fn <- funs[[plt]]

      tryCatch({
        if (n_datasets == 2) {
          p <- fn(df1 = ttd[[1]], df2 = ttd[[2]])
          print(p |> inspectdf::show_plot(text_labels = TRUE))
        } else {
          purrr::imap(ttd, function(df, nm) {
            if (!is.data.frame(df)) {
              logr_msg(paste0("Skipping non-data.frame element '", nm, "'"), level = "TRACE")
              return()
            }
            if (plt %in% c("cor", "num") &&
                !has_min_cols(num_cols, which(names(ttd) == nm), min_count = 2)) {
              logr_msg(
                paste0("Skipping '", nm, "' for plot '", plt, "' (insufficient numeric columns)"),
                level = "TRACE"
              )
              return()
            }
            p <- fn(df1 = df, df2 = NULL)
            print(p |> inspectdf::show_plot(text_labels = TRUE))
          })
        }
        logr_msg(paste0("Completed plot type '", plt, "'"), level = "SUCCESS")
      }, error = function(e_plot) {
        logr_msg(paste0("Error in plot type '", plt, "': ", e_plot$message), level = "ERROR")
      })
    }

    logr_msg("inspect_plot(): all requested plots finished", level = "SUCCESS")
    invisible(NULL)

  }, error = function(e) {
    logr_msg(paste0("inspect_plot(): FATAL error - ", e$message), level = "FATAL")
    stop(e)
  })
  out
}
