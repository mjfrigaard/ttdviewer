% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ctr.R
\name{ctr}
\alias{ctr}
\title{Print a colorized tree representation of an R object}
\usage{
ctr(x = as.list(), depth = 10L, length = 50L)
}
\arguments{
\item{x}{An R object—typically a list or other recursive structure—to
visualize. Defaults to an empty list created by \code{as.list()}.}

\item{depth}{Integer scalar. Maximum depth of recursion for the tree
traversal. Defaults to \code{10L}.}

\item{length}{Integer scalar. Maximum number of elements to show per node
for atomic vectors. Defaults to \code{50L}.}
}
\value{
Invisibly returns the original object \code{x}. The main purpose of the
function is its side effect of printing the tree.
}
\description{
This function displays a compact, colored tree of the structure of \code{x}
using \code{\link[lobstr:tree]{lobstr::tree()}} with sensible defaults. Environments and attributes
are hidden, scalar types are collapsed, class names are printed in blue,
and values are printed in green. Newlines in values are removed to keep
the output concise.
}
\examples{
# Basic usage on a nested list
ctr(list(a = 1, b = list(c = 2, d = 3)))

# Limit depth to 2 levels
ctr(list(a = 1, b = list(c = list(d = 4))), depth = 2)

# Show only up to 5 elements for large atomic vectors
ctr(as.list(1:100), length = 5)

}
