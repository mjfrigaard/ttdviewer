% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/load_tt_data.R
\name{load_tt_data}
\alias{load_tt_data}
\title{Load TidyTuesday datasets from GitHub by title}
\usage{
load_tt_data(title)
}
\arguments{
\item{title}{A character string matching the \code{title} field in \code{all_tt_combined}.}
}
\value{
A named list of tibbles or data frames (one per file). Failed or skipped
datasets are excluded.
}
\description{
Filters an internal dataset \code{all_tt_combined} by \code{title}, and loads
associated data files using appropriate methods depending on \code{data_type}.
Supports functional error handling and logging.
}
\section{Features}{

\itemize{
\item Automatically selects the correct reader (\code{csv}, \code{tsv}, \code{xlsx}, \code{rds})
\item Logs messages using \code{logr_msg()}
\item Adds a \code{clean_title} attribute to each dataset
\item Skips unsupported formats (\code{vgz}, \code{zip}, \code{NA})
}
}

\section{Supported file types}{

\itemize{
\item \code{"csv"} / \code{"csv.gz"} → \code{vroom::vroom()}
\item \code{"tsv"}              → \code{vroom::vroom()}
\item \code{"xlsx"}             → \code{readxl::read_excel()}
\item \code{"rds"}              → \code{readRDS()} from a URL connection
}
}

\section{Unsupported}{

\itemize{
\item \code{"vgz"}, \code{"zip"}, or \code{NA} → skipped with error logging
}
}

\examples{
load_tt_data("posit::conf talks")
}
