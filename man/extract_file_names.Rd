% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/load_tt_data.R
\name{extract_file_names}
\alias{extract_file_names}
\title{Extract file names from TidyTuesday data object}
\usage{
extract_file_names(tt_data)
}
\arguments{
\item{tt_data}{list of TidyTuesday data from \code{\link[=load_tt_data]{load_tt_data()}}}
}
\value{
Character vector of file names with extensions included
}
\description{
Extract file names from TidyTuesday data object
}
\examples{

ttd <- load_tt_data("Moore’s Law")
extract_file_names(ttd)

}
