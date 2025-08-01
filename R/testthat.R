#' Timestamp
#'
#' @returns character string of date/time.
#'
#' @export
#'
#' @examples
#' tstmp()
#' cat(paste("Last updated:", tstmp()))
tstmp <- function() {
  # Format current system time as "YYYY-MM-DD-HH.MM.SS-"
  format(Sys.time(), "%Y-%m-%d-%H.%M.%S")
}

#' Test logger (test utility)
#'
#' @param start test start message 
#' @param end test end message 
#' @param msg test message 
#'
#' @return message to test output
#' 
#' @keywords internal
#'
test_logger <- function(start = NULL, end = NULL, msg) {
  if (is.null(start) & is.null(end)) {
    cat("\n")
    logger::log_info("{msg}")
  } else if (!is.null(start) & is.null(end)) {
    cat("\n")
    logger::log_info("\n[ START {start} = {msg}]")
  } else if (is.null(start) & !is.null(end)) {
    cat("\n")
    logger::log_info("\n[ END {end} = {msg}]")
  } else {
    cat("\n")
    logger::log_info("\n[ START {start} = {msg}]")
    cat("\n")
    logger::log_info("\n[ END {end} = {msg}]")
  }
}

#' Test Dataset Title Cleaning
#'
#' A utility function to test the title cleaning functionality with
#' various edge cases and examples.
#'
#' @return A data frame showing original titles and their cleaned versions
#'
#' @examples
#' test_title_cleaning()
#'
#' @export
test_title_cleaning <- function() {
  test_titles <- c(
    "Bring your own data from 2024!",
    "Donuts, Data, and D'oh - A Deep Dive into The Simpsons",
    "Moore's Law",
    "U.S. Wind Turbines (2018-2022)",
    "It's Always Sunny in Philadelphia",
    "Bob's Burgers & Restaurant Data",
    "COVID-19: The Pandemic's Impact",
    "Taylor Swift's Albums & Songs",
    "NASA's Space Missions",
    "Women's World Cup 2023",
    "Pride & Prejudice Text Analysis",
    "R-Ladies: Global Chapter Events",
    "Lorem Ipsum... Text Generator!",
    "Data Science @ Work",
    "AI/ML in Healthcare",
    "50% Off: Black Friday Sales",
    "#TidyTuesday Community",
    "Star Wars: The Force Awakens",
    "Climate Change – Global Temperatures",
    "NYC Taxi & Uber Data"
  )

  cleaned_titles <- sapply(test_titles, clean_title_string, USE.NAMES = FALSE)

  result <- data.frame(
    Original = test_titles,
    Cleaned = cleaned_titles
  )
  return(result)
}
