#' Print a colorized tree representation of an R object
#'
#' This function displays a compact, colored tree of the structure of `x`
#' using [lobstr::ast()](https://lobstr.r-lib.org/reference/ast.html) with 
#' sensible defaults. Environments and attributes are hidden, scalar types 
#' are collapsed, class names are printed in blue, and values are printed 
#' in green. Newlines in values are removed to keep the output concise.
#'
#' @param x An R object—typically a list or other recursive structure—to
#' visualize. Defaults to an empty list created by `as.list()`.
#' @param depth Integer scalar. Maximum depth of recursion for the tree
#' traversal. Defaults to `10L`.
#' @param length Integer scalar. Maximum number of elements to show per node
#' for atomic vectors. Defaults to `50L`.
#'
#' @return Invisibly returns the original object `x`. The main purpose of the
#' function is its side effect of printing the tree.
#'
#' @examples
#' # Basic usage on a nested list
#' ctr(list(a = 1, b = list(c = 2, d = 3)))
#'
#' # Limit depth to 2 levels
#' ctr(list(a = 1, b = list(c = list(d = 4))), depth = 2)
#'
#' # Show only up to 5 elements for large atomic vectors
#' ctr(as.list(1:100), length = 5)
#'
#' @export
#'
ctr <- function(x = as.list(), depth = 10L, length = 50L) {
  lobstr::tree(x,
    max_depth = depth,
    max_length = length,
    show_environments = FALSE,
    show_attributes = FALSE,
    hide_scalar_types = TRUE,
    class_printer = crayon::blue,
    remove_newlines = TRUE,
    val_printer = crayon::green
  )
}
