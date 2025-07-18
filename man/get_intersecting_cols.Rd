% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/inspect_plot.R
\name{get_intersecting_cols}
\alias{get_intersecting_cols}
\title{Get Intersecting Column Names Between Two Datasets}
\usage{
get_intersecting_cols(ttd)
}
\arguments{
\item{ttd}{A list of data frames from \code{\link[=load_tt_data]{load_tt_data()}}}
}
\value{
A character vector of intersecting column names, or empty vector
if no intersections or if not exactly 2 datasets
}
\description{
Helper function to find column names that exist in both datasets when
there are exactly two datasets in the
\href{https://github.com/rfordatascience/tidytuesday}{TidyTuesday} data list.
}
\examples{
ttd <- load_tt_data("Moore’s Law")
get_intersecting_cols(ttd)
}
