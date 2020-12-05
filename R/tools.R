#' @keywords internal
#' @export
listk <- function(...) {
    # get variable names from input expressions
    cols <- as.list(substitute(list(...)))[-1]
    vars <- names(cols)
    Id_noname <- if (is.null(vars)) seq_along(cols) else which(vars == "")

    if (length(Id_noname) > 0) {
          vars[Id_noname] <- sapply(cols[Id_noname], deparse)
      }
    # ifelse(is.null(vars), Id_noname <- seq_along(cols), Id_noname <- which(vars == ""))
    x <- setNames(list(...), vars)
    return(x)
}

#' @keywords internal
#' @export
reorder_name <- function(
    d,
    headvars = c("site", "date", "year", "doy", "d8", "d16"),
    tailvars = "")
{
    names <- names(d)
    headvars %<>% intersect(names)
    tailvars %<>% intersect(names)
    varnames <- c(headvars, setdiff(names, union(headvars, tailvars)), tailvars)

    if (is.data.table(d)) {
        d[, varnames, with = F]
    } else if (is.data.frame(d)) {
        d[, varnames]
    } else if (is.list(d)){
        d[varnames]
    } else{
        stop("Unknown data type!")
    }
}

#' @keywords internal
#' @export
rm_empty <- function(x) {
    if (is.list(x)) {
        x[sapply(x, length) > 0]
    }
    else {
        x[!is.na(x)]
    }
}


#' @keywords internal
#' @export
fill_NULL <- function(x) {
    x[which.isnull(x)] <- NA
    x
}

#' @keywords internal
#' @export
which.isnull <- function(x) {
    which(sapply(x, is.null))
}
