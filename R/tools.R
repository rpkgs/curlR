self <- function(x) {
    x
}

#' @keywords internal
#' @export
fill_NULL <- function(x) {
    x[which.isnull(x)] <- NA
    x
}
